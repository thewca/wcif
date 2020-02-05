# WCIF

The official specification of the WCA Competition Interchange Format.

## Implementation notes

Currently the WCA website implements most of the specification.
The WCIF data for the given competition can be obtained via the following endpoints:

###### Public endpoint

`https://worldcubeassociation.org/api/v0/competitions/:competition_id/wcif/public`

Publicly available (with the confidential attributes stripped out). *Note: the data may be cached up to 5 minutes.*

###### Authorized endpoint

`https://worldcubeassociation.org/api/v0/competitions/:competition_id/wcif`

Restricted to competition managers. Additionally, a `PATCH` request allows for saving the data (currently a significant subset of it).

#### Limitations

- Currently the WCA website returns `Person#registrantId` of `null`
for people without a registration (e.g. non-participating organizer).
- Currently the WCA website does not implement the following attributes: `Event#competitorLimit`, `Event#qualification`, `Round#scrambleSets`, `Activity#scrambleSetId`

## Examples

There are many applications using the WCIF format already, those include:
- [WCA Live](https://github.com/thewca/wca-live)
- [Groupifier](https://github.com/jonatanklosko/groupifier)
- [Scrambles Matcher](https://github.com/viroulep/scrambles-matcher)
- [TNoodle](https://github.com/thewca/tnoodle)
- [WCIF Scripts](https://github.com/jonatanklosko/wcif-scripts)
