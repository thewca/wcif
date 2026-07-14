## Changelog from v2.1.1

### Minor
- `FTO` will be added to the list of event id's referenced in [Event](#Event)
- Added "Required Fields" section and marked `id` and `formatVersion` as required

## v2.1.1: Change from v2.0.1

### Minor
- Added `scope` to `ResultCondition` types `ranking` and `percent`, to clarify whether the single or average should be used to determine ranking.

### Patch
- Clarified that `ParticipationSource` may be `null` for competitions during and before 2021.

## v2.0.1: Change from v2.0.0

### Patch: 
- Corrected usage of field names and clarified which fields may also return null values.

## v2.0.0: Changelog from v1.1

### Major:
- Replaced `AdvancementCondition` object with `ParticipationRuleset`
- `ResultCondition` object added, which is used by both `ParticipationRuleset` and `Qualification`
- `Qualification` object changed to make use of `ResultCondition`
- `ParticipationRuleset` includes `ReservedPlaces`, which implements [Regulation 9p2b](https://www.worldcubeassociation.org/regulations/#9p2b)
- Renamed `AttemptResult` to `ResultValue`
    - Renamed `Attempt.result` to `Attempt.value`
    - Renamed `PersonalBest.best` to `PersonalBest.value`
- Renamed `Qualification.whenDate` to `Qualification.latestResultDate`


### Minor
- Added value `h` to `round.format` enum - `h` corresponds to the Head-to-Head format described in the [2026 Regulations](https://www.worldcubeassociation.org/regulations/#article-I-headtohead).
- Added `linkedRounds` field to `Round` object, which indicates a round's participation in a [Dual Round](https://www.worldcubeassociation.org/regulations/#9v).
- Added `Qualification.earliestResultDate`, to prepare for upcoming WCRP changes

## v1.1.0: Changelog from v1.0

### Minor:
- Added value `5` to `round.format` enum - `5` corresponds to a Best of 5 format as described in the [2026 Regulation Changes](https://github.com/thewca/wca-regulations-january-2026/pull/48).
