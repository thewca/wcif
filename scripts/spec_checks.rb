#!/usr/bin/env ruby
# frozen_string_literal: true

# check_spec.rb — WCIF specification consistency checker
# Usage: ruby check_spec.rb [path/to/specification.md]
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

require "json"

spec_path = File.join(__dir__, "../specification.md")

unless File.exist?(spec_path)
  warn "ERROR: specification file not found at #{spec_path}"
  exit 1
end

content = File.read(spec_path)
errors   = []
warnings = []

# ── Helpers ───────────────────────────────────────────────────────────────────

# Split by exactly ## headings (not ### or ####)
def top_level_sections(content)
  content.split(/^(?=## [^#])/)
end

# Extract only the bullet-list entries from ## Objects (not inline type refs)
def extract_objects_list(content)
  obj_section = top_level_sections(content).find { |p| p.start_with?("## Objects") }
  return [] unless obj_section
  # Only match lines that start with "- [Name](...)"
  obj_section.scan(/^-\s+\[([^\]]+)\]/).flatten
end

def extract_h3_names(content)
  content.scan(/^### ([^\n]+)/).flatten.map(&:strip)
end

# Return everything from a ### heading up to (but not including) the next ## or ### heading
def section_body_for_h3(content, name)
  pattern = /^### #{Regexp.escape(name)}[^\n]*\n(.*?)(?=^## [^#]|^### |\z)/m
  content.match(pattern)&.captures&.first
end

def extract_table_fields(section_text)
  return [] unless section_text
  table = section_text[/(\|[^\n]+\|\n)+/]
  return [] unless table
  rows = table.lines.reject { |l| l.match?(/^\|\s*[-:]+/) }
  rows.map { |row|
    cell = row.split("|").map(&:strip).reject(&:empty?).first
    cell&.gsub(/`/, "")
  }.compact.reject { |f| f.downcase == "attribute" }
end

def extract_example_keys(section_text)
  return [] unless section_text
  json_block = section_text[/```json[^\n]*\n(\{.*?\})\s*\n```/m, 1]
  return [] unless json_block
  cleaned = json_block.gsub(%r{^\s*//[^\n]*\n?}, "")
  cleaned = cleaned.gsub(/\{\.\.\.?\}/, '"__obj__"')
  cleaned = cleaned.gsub(/\[\.\.\.?\]/, '["__arr__"]')
  cleaned = cleaned.gsub(/,(\s*[\}\]])/, '\1')
  begin
    parsed = JSON.parse(cleaned)
    parsed.is_a?(Hash) ? parsed.keys : []
  rescue JSON::ParserError
    nil
  end
end

def slugify(heading)
  heading.downcase.gsub(/[^a-z0-9\s-]/, "").gsub(/\s+/, "-").strip
end

# ── Check 1: Objects list vs H3 headers ──────────────────────────────────────

objects_list = extract_objects_list(content)
h3_names     = extract_h3_names(content)

objects_list.each do |name|
  unless h3_names.any? { |h| h.casecmp(name).zero? }
    errors << "## Objects lists '#{name}' but no matching ### #{name} section found"
  end
end

h3_names.each do |name|
  unless objects_list.any? { |o| o.casecmp(name).zero? }
    errors << "### #{name} section exists but '#{name}' is not listed under ## Objects"
  end
end

# ── Check 2: Table <-> Example field consistency ──────────────────────────────

# Sections that are intentionally scalars, enums, or use sub-sections rather
# than a flat fields table — skip table/example cross-check for these.
EXEMPT_SECTIONS = %w[
  ActivityCode AssignmentCode CountryCode CurrencyCode Date DateTime
  ResultCondition ResultValue Role Scramble ParticipationSource
].freeze

h3_names.each do |name|
  next if EXEMPT_SECTIONS.include?(name)

  body = section_body_for_h3(content, name)
  unless body
    warnings << "Could not isolate body of ### #{name} — skipping checks"
    next
  end

  table_fields = extract_table_fields(body)
  has_example  = body.include?("```json")

  warnings << "### #{name}: no fields table found" if table_fields.empty?

  unless has_example
    warnings << "### #{name}: no example JSON block found"
    next
  end

  example_keys = extract_example_keys(body)

  if example_keys.nil?
    warnings << "### #{name}: example JSON could not be parsed — skipping field cross-check"
    next
  end

  next if example_keys.empty?  # scalar example, nothing to cross-check

  (table_fields - example_keys).each do |field|
    errors << "### #{name}: field '#{field}' is in the table but missing from the example"
  end

  (example_keys - table_fields).each do |key|
    errors << "### #{name}: key '#{key}' appears in the example but is not in the fields table"
  end
end

# ── Check 3: Broken internal anchor links ─────────────────────────────────────

all_headings  = content.scan(/^[#]+ ([^\n]+)/).flatten
valid_anchors = all_headings.map { |h| slugify(h) }.to_set

content.scan(/\[[^\]]*\]\(#([^)]+)\)/).each do |m|
  anchor = m.first
  unless valid_anchors.include?(slugify(anchor))
    errors << "Broken internal link: ##{anchor} — no matching heading found"
  end
end

# ── Check 4: Trailing commas in JSON blocks ────────────────────────────────────

trailing_comma_lines = []
block_count = 0
content.scan(/```json[^\n]*\n(.*?)```/m) do |block_arr|
  block_count += 1
  block_arr.first.gsub(%r{^\s*//[^\n]*\n?}, "").each_line do |line|
    trailing_comma_lines << "Block ##{block_count}: #{line.strip[0..70]}" if line =~ /,\s*$/
  end
end

unless trailing_comma_lines.empty?
  warnings << "#{trailing_comma_lines.size} trailing comma(s) found in JSON examples " \
              "(invalid JSON). First occurrence: #{trailing_comma_lines.first}"
end

# ── Check 5: Duplicate H3 headings ───────────────────────────────────────────

h3_names.group_by { |n| n.downcase }.each do |_k, group|
  errors << "Duplicate heading: '#{group.first}' appears #{group.size} times" if group.size > 1
end

# ── Check 6: ## Objects list is alphabetically ordered ───────────────────────

sorted_objects = objects_list.sort_by(&:downcase)
objects_list.each_with_index do |name, i|
  expected = sorted_objects[i]
  if name != expected
    errors << "## Objects list is not alphabetically ordered: " \
              "found '#{name}' at position #{i + 1}, expected '#{expected}' " \
              "(first out-of-order entry — fix ordering from here)"
    break  # one actionable message is enough; further entries are cascading noise
  end
end

# ── Check 7: Type references in tables are missing anchors ────────────────────

# Built-in primitive types that intentionally have no H3 section and need no anchor.
PRIMITIVE_TYPES = %w[String Integer Boolean Object].freeze

content.each_line.with_index(1) do |line, lno|
  # Match [`TypeName`] or [`[TypeName]`] NOT followed by ( — meaning no anchor present.
  # The inner pattern strips array brackets and backticks to get the bare type name.
  line.scan(/\[`[\[]?([^`\]]+)`[\]]?\](?!\()/) do |m|
    type_name = m.first.strip
    next if PRIMITIVE_TYPES.include?(type_name)
    # Ignore if the whole thing is inside a code block context (very unlikely in tables but safe)
    errors << "Line #{lno}: type reference [`#{type_name}`] is missing an anchor link " \
              "— should be [`#{type_name}`](##{type_name.downcase})"
  end
end

# ── Check 8: Every anchor in a type reference resolves to a known heading ────

# This is distinct from Check 3 (all links in the doc): this one focuses
# specifically on type-reference links so the error message is more targeted.

all_headings  = content.scan(/^[#]+ ([^\n]+)/).flatten
valid_anchors = all_headings.map { |h| slugify(h) }.to_set

content.each_line.with_index(1) do |line, lno|
  # Match [`TypeName`](#anchor) in all their variant forms
  line.scan(/\[`[\[\\]?([A-Z][a-zA-Z]+)[`\]\\|]*\]\(#([^)]+)\)/) do |type_name, anchor|
    unless valid_anchors.include?(slugify(anchor))
      errors << "Line #{lno}: type reference [`#{type_name}`](##{anchor}) — " \
                "anchor ##{anchor} does not resolve to any heading"
    end
  end
end

# ── Report ────────────────────────────────────────────────────────────────────

puts "=" * 65
puts "WCIF Specification Checker"
puts "File: #{spec_path}"
puts "=" * 65

if errors.empty? && warnings.empty?
  puts "\n✅  All checks passed — no issues found.\n\n"
  exit 0
end

unless warnings.empty?
  puts "\n⚠️  WARNINGS (#{warnings.size})\n"
  warnings.each_with_index { |w, i| puts "  #{i + 1}. #{w}" }
end

unless errors.empty?
  puts "\n❌  ERRORS (#{errors.size})\n"
  errors.each_with_index { |e, i| puts "  #{i + 1}. #{e}" }
end

puts "\n#{errors.size} error(s), #{warnings.size} warning(s) found.\n\n"
exit errors.empty? ? 0 : 1
