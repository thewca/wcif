## v2.0.0: Changelog from v1.1

Changes from v1.1 are as follows:

### Major
- Replaced `AdvancementCondition` object with `ParticipationRuleset`
- `ResultCondition` object added, which is used by both `ParticipationRuleset` and `Qualification`
- `Qualification` object changed to make use of `ResultCondition`
- `ParticipationRuleset` includes `ReservedPlaces`, which implements [Regulation 9p2b](https://www.worldcubeassociation.org/regulations/#9p2b)
- Renamed `ResultAttempt` to `ResultValue`
- Renamed `Attempt.result` to `Attempt.value`

### Minor
- Added value `h` to `round.format` enum - `h` corresponds to the Head-to-Head format described in the [2026 Regulations](https://www.worldcubeassociation.org/regulations/#article-I-headtohead).
- Added `linkedRounds` field to `Round` object, which indicates a round's participation in a [Dual Round](https://www.worldcubeassociation.org/regulations/#9v).

## v1.1.0: Changelog from v1.0

Changes from v1.0 are as follows:
- Added value `5` to `round.format` enum - `5` corresponds to a Best of 5 format as described in the [2026 Regulation Changes](https://github.com/thewca/wca-regulations-january-2026/pull/48).
