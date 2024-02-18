# WCIF

*Version: 1.0*

WCIF stands for WCA Competition Interchange Format and is a specification of competition data in JSON format.
It's designed as a way for many applications to exchange data in a standardized manner.

## Objects

The specification defines the following types:

- [Activity](#Activity)
- [ActivityCode](#ActivityCode)
- [AdvancementCondition](#AdvancementCondition)
- [Assignment](#Assignment)
- [AssignmentCode](#AssignmentCode)
- [Attempt](#Attempt)
- [AttemptResult](#AttemptResult)
- [Avatar](#Avatar)
- [Competition](#Competition)
- [CountryCode](#CountryCode)
- [CurrencyCode](#CurrencyCode)
- [Cutoff](#Cutoff)
- [Date](#Date)
- [DateTime](#DateTime)
- [Event](#Event)
- [Extension](#Extension)
- [Percent](#Percent)
- [Person](#Person)
- [PersonalBest](#PersonalBest)
- [Qualification](#Qualification)
- [Ranking](#Ranking)
- [Registration](#Registration)
- [RegistrationInfo](#RegistrationInfo)
- [Result](#Result)
- [Role](#Role)
- [Room](#Room)
- [Round](#Round)
- [Series](#Series)
- [Schedule](#Schedule)
- [Scramble](#Scramble)
- [ScrambleSet](#ScrambleSet)
- [TimeLimit](#TimeLimit)
- [Venue](#Venue)

### Competition

Represents the root object and is usually referred to as a WCIF.

| Attribute | Type | Description |
| --- | --- | --- |
| `formatVersion` | `String` | Used to distinguish different versions of the format (most notably compared to the past `0.3`). |
| `id` | `String` | The unique competition identifier. |
| `name` | `String` | The full name of the competition. |
| `shortName` | `String` | A briefer version of `name`, may be the same if `name` is already short. |
| `series` | [`[Series\|null]`](#series) | The Competition Series that this competition is part of, if any. |
| `persons` | [`[Person]`](#person) | List of all the people related to the competition. |
| `events` | [`[Event]`](#event) | List of all events held at the competition. |
| `schedule` | [`Schedule`](#schedule) | All the data related to time and scheduling. |
| `registrationInfo` | [`RegistrationInfo`] | All the data related to the competition's registration. |
| `competitorLimit` | `Integer\|null` | The maximal number of competitors that can register for the competition. |
| `extensions` | [`[Extension]`](#extension) | List of custom competition extensions. |

#### Example

```json
{
  "formatVersion": "1.0",
  "id": "WC2019",
  "name": "WCA World Championship 2019",
  "shortName": "WCA WC 2019",
  "series": {...},
  "persons": [...],
  "events": [...],
  "schedule": {...},
  "registrationInfo": [...],
  "competitorLimit": 1000,
  "extensions": [...]
}
```


### Series

Represents a Competition Series as per the WCA Competition Requirements Policy.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `String` | The unique Competition Series identifier. |
| `name` | `String` | The full name of the Competition Series. |
| `shortName` | `String` | A briefer version of `name`, may be the same if `name` is already short. |
| `competitionIds` | `[String]` | The identifiers of all competitions that are part of this series, ordered by start date. **Includes the current competition represented by this WCIF**. |

#### Example

```json
{
  "id": "AwesomeAustralianSeries2022",
  "name": "An Absolutely Awesome Australian Series 2022",
  "shortName": "Awesome Australian Series 2022",
  "competitionIds": ["MyFirstAwesomeCompetition2022", "MySecondAwesomeCompetition2022", "MyThirdAwesomeCompetition2022"],
}
```


### Person

Represents a person related to the competition (not necessarily a competitor).

| Attribute | Type | Description |
| --- | --- | --- |
| `registrantId` | `Integer` | The person identifier, unique within the competition. |
| `name` | `String` | The person full name. May include local name in parentheses. |
| `wcaUserId` | `Integer` | The identifier of the WCA account used to register for the competition. |
| `wcaId` | `String\|null` | The WCA ID of the corresponding competitor profile. |
| `countryIso2` | [`CountryCode`](#countrycode) | The person nationality. |
| `gender` | `"m"\|"f"\|"o"` | The person gender. Either male, female or other. |
| `birthdate` | [`Date`](#date) | The person birthdate. *Note: this attribute is not public.* |
| `email` | `String` | The person email address. *Note: this attribute is not public.* |
| `avatar` | `Avatar\|null` | The person avatar image. |
| `roles` | [`[Role]`](#role) | List of roles assigned to this person at the competition. |
| `registration` | [`[Registration]`](#registration)\|`null` | All the data related to the online registration for the competition. May be `null` if the person hasn't registered, but is still relevant to the competition (e.g. organizer, delegate). |
| `assignments` | [`[Assignment]`](#assignment) | List of task assignments. |
| `personalBests` | [`[PersonalBest]`](#personalbest) | List of official personal records. |
| `extensions` | [`[Extension]`](#extension) | List of custom person extensions. |

#### Example

```json
{
  "registrantId": 1,
  "name": "Sherlock Holmes",
  "wcaUserId": 221,
  "wcaId": "2015HOLM01",
  "countryIso2": "GB",
  "gender": "m",
  "birthdate": "1854-06-20",
  "email": "sholmes@gmail.com",
  "avatar": {...},
  "roles": [...],
  "registration": {...},
  "assignments": [...],
  "personalBests": [...],
  "extensions": [...]
}
```

### CountryCode

A `String` representing the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code of the given country.

#### Example

```json
"US"
```

### CurrencyCode

A `String` representing the [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code of the given currency.

#### Example

```json
"CAD"
```

### Role

A `String` representing a role at the competition.

The specification defines the following roles:
- `"delegate"`
- `"trainee-delegate"`
- `"organizer"`

Applications may define additional roles, however, other applications are not required to recognize or display these roles.

#### Example

```json
"staff-dataentry"
```

### Registration

Represents person registration data.

| Attribute | Type | Description |
| --- | --- | --- |
| `wcaRegistrationId` | `Integer` | The identifier of the registration in the WCA registration system. |
| `eventIds` | `[String]` | List of identifiers of WCA events for which the person registered. |
| `status` | `"accepted"\|"pending"\|"deleted"` | The status of the registration in the registration system. |
| `guests` | `Integer` | The number of guests the person declared. *Note: this attribute is not public.* |
| `comments` | `String` | The additional information typed during registration. *Note: this attribute is not public.* |
| `administrativeNotes` | `String` | Additional information typed by an organizer or delegate as part of managing the registration. *Note: this attribute is not public.* |

#### Example

```json
{
  "wcaRegistrationId": 1,
  "eventIds": ["333", "333fm", "444", "777"],
  "status": "accepted",
  "guests": 2,
  "comments": "I would like to opt-in for the pizza.",
  "administrativeNotes": "Emailed competitor on 05/08 to verify their date of birth"
}
```

### RegistrationInfo

Represents information related to when and how to register for the competition.

| Attribute | Type | Description |
| --- | --- | --- |
| `openTime` | [`DateTime`](#datetime) | The point in time when online registration opens. |
| `closeTime` | [`DateTime`](#datetime) | The point in time when online registration closes. |
| `baseEntryFeeLowestDenomination` | `Integer` | The competition's base fee for online registration, in the lowest denomination of the specified currency code. |
| `currencyCode` | [`CurrencyCode`](#currencycode) | The currency of the `baseEntryFee`, following ISO 4217. |
| `onTheSpotRegistration` | `Boolean` | Whether non-registered competitors are permitted to sign up at the competition. |
| `useWcaRegistration` | `Boolean` | Whether registration takes place on the WCA website. |

#### Example

```json
{
  "openTime": "2023-08-29T05:00:00Z",
  "closeTime": "2023-11-18T05:00:00Z",
  "baseEntryFeeLowestDenomination": 2000,
  "currencyCode": "USD",
  "onTheSpotRegistration": false,
  "usesWcaRegistration": true,
}
```

In this example, the registration fee is $20.00 USD, because the lowest denomination of USD is cents ($0.01 USD).

### Avatar

Represents an avatar image.

| Attribute | Type | Description |
| --- | --- | --- |
| `url` | `String` | The address of the avatar picture. |
| `thumbUrl` | `String` | The address of a thumbnail version of the picture. |

#### Example

```json
{
  "url": "https://path.to/avatar",
  "thumbUrl": "https://path.to/avatar/thumbnail"
}
```

### Assignment

Represents an assignment of specific task during a specific time.

| Attribute | Type | Description |
| --- | --- | --- |
| `activityId` | `Integer` | The identifier of schedule activity for which the task is assigned. |
| `assignmentCode` | [`AssignmentCode`](#assignmentcode) | The identifier of the task type. |
| `stationNumber` | `Integer\|null` | An optional attribute pointing to a specific station, if the task is to be performed only there. |

#### Example

```json
{
  "activityId": 1,
  "assignmentCode": "competitor",
  "stationNumber": null
}
```

### AssignmentCode

A `String` representing type of a task that may be assigned.

The specification defines the following codes:
- `"competitor"`
- `"staff-judge"`
- `"staff-scrambler"`
- `"staff-runner"`
- `"staff-dataentry"`
- `"staff-announcer"`

Applications may define additional roles under the `staff` namespace, however, other applications are not required to recognize or display these roles.

#### Example

```json
"staff-scrambler"
```

### PersonalBest

Represents an official personal record.

| Attribute | Type | Description |
| --- | --- | --- |
| `eventId` | `String` | Identifier of the WCA event. |
| `best` | [`AttemptResult`](#attemptresult) | The actual record value. |
| `type` | `"single"\|"average"` | The type of the record. |
| `worldRanking` | `Integer` | The position in the official world ranking. |
| `continentalRanking` | `Integer` | The position in the official continental ranking. |
| `nationalRanking` | `Integer` | The position in the official national ranking. |

#### Example

```json
{
  "eventId": "333",
  "best": 790,
  "type": "single",
  "worldRanking": 995,
  "continentalRanking": 105,
  "nationalRanking": 6
}
```

### Event

Represents data of an event held at the competition.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `String` | The WCA event identifier. Look [here](https://github.com/thewca/worldcubeassociation.org/blob/master/WcaOnRails/db/seeds/events.seeds.rb) for the list of all the WCA events. |
| `rounds` | [`[Round]`](#round) | List of rounds of the event held at the competition. |
| `competitorLimit` | `Integer\|null` | The maximal number of competitors that can register for the event. |
| `qualification` | [`Qualification`](#qualification)\|`null` | The requirement that a person must meet in order to register for the event. |
| `extensions` | [`[Extension]`](#extension) | List of custom competition extensions. |

#### Example

```json
{
  "id": "333",
  "rounds": [...],
  "competitorLimit": null,
  "qualification": null,
  "extensions": [...]
}
```

### Round

Represents data of a round held at the competition.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `String` | The round identifier of the form `{eventId}-r{roundNumber}`. *Note: this is a valid [`ActivityCode`](#activitycode).* |
| `format` | `"1"\|"2"\|"3"\|"a"\|"m"` | The round format. Look [here](https://github.com/thewca/worldcubeassociation.org/blob/master/WcaOnRails/db/seeds/formats.seeds.rb) for the list of all the WCA formats. |
| `timeLimit` | [`TimeLimit`](#timelimit)\|`null` | The time limit in this round. For events with unchangeable time limit (3x3x3 MBLD, 3x3x3 FM) the value is `null`. |
| `cutoff` | [`Cutoff`](#cutoff)\|`null` | The cutoff in this round. |
| `advancementCondition` | [`AdvancementCondition`](#advancementcondition)\|`null` | The condition specifying which competitors advance to the next round. |
| `results` | [`[Result]`](#result) | List of all round results. |
| `scrambleSetCount` | `Integer` | The number of scramble sets needed for this round. |
| `scrambleSets` | [`[ScrambleSet]`](#scrambleset) | List of scramble sets used in this round. |
| `extensions` | [`[Extension]`](#extension) | List of custom competition extensions. |

#### Example

```json
{
  "id": "333-r1",
  "format": "a",
  "timeLimit": {...},
  "cutoff": {...},
  "advancementCondition": {...},
  "results": [...],
  "scrambleSetCount": 4,
  "scrambleSets": [...],
  "extensions": [...]
}
```

### TimeLimit

Represents a time under which an attempt(s) must be completed. See [regulation A1a](https://www.worldcubeassociation.org/regulations/#A1a) for more details.

| Attribute | Type | Description |
| --- | --- | --- |
| `centiseconds` | `Integer` | The time. |
| `cumulativeRoundIds` | `[String]` | An empty array the time limit applies to each attempt. |

#### Example

```json
{
  "centiseconds": 18000,
  "cumulativeRoundIds": []
}
```

### Cutoff

Represents an attempt result the competitor needs to beat in one of the first phase attempts in order to be eligible for the remaining attempts. See [regulation 9g](https://www.worldcubeassociation.org/regulations/#9g) for more details.

| Attribute | Type | Description |
| --- | --- | --- |
| `numberOfAttempts` | `Integer` | The number of attempts the competitors has to get an attempt better than `attemptResult`. |
| `attemptResult` | [`[AttemptResult]`](#attemptresult) | The attempt result that needs to be beaten in order to be eligible for the remaining attempts. |

#### Example

```json
{
  "numberOfAttempts": 2,
  "attemptResult": 3000,
}
```

### AdvancementCondition

Represents a requirement a competitor must satisfy in the given round in order to advance to the next round of the event.
See [regulation 9p2](https://www.worldcubeassociation.org/regulations/#9p2) for more details.
Regardless of the advancement condition type, [regulation 9p1](https://www.worldcubeassociation.org/regulations/#9p1) must be applied.

| Attribute | Type | Description |
| --- | --- | --- |
| `type` | `"ranking"\|"percent"\|"attemptResult"` | The type of advancement condition. Either of ranking (top N competitors), percent (top X% of competitors) or attempt result (competitors with result better than Y - either single or average as per [9p2+](https://www.worldcubeassociation.org/regulations/guidelines.html#9p2+)). |
| `level` | [`Ranking`](#ranking)\|[`Percent`](#percent)\|[`AttemptResult`](#attemptresult) | The parameter of advancement condition of the given type. |

### Ranking

An `Integer` number of competitors.

### Percent

An `Integer` (between 0 and 100, inclusive) representing a percent of competitors (rounded down to the nearest integer).

### AttemptResult

An `Integer` representing a competitor result in a single attempt.

The following values are defined to have special meaning:
- `0` represents a skipped attempt (e.g. an attempt may be skipped if a competitor does not meet the cutoff)
- `-1` represents a DNF (Did Not Finish)
- `-2` represents a DNS (Did Not Start)

In the default case the value represents the number of centiseconds measured
(e.g. `1:10.25` would be represented as `7025`).

For 3x3x3 Fewest Moves the value represents the number of moves,
but averages are represented as 100 times the average
(i.e. an single result of `25` moves is represented as `25`, while an average result of `25.33` moves is represented as `2533`).

For 3x3x3 Multi-Blind the value encodes the time as well as the number of cubes attempted and solved
(designed so that a lower value means a better result).\
An attempt result `0DDTTTTTMM` encodes the following information:
- `timeInSeconds = TTTTT (99999 means unknown)`
- `difference    = 99 - DD`
- `missed        = MM`
- `solved        = difference + missed`
- `attempted     = solved + missed`

*Note: the leading zero indicates that this is the New Multi-Blind format, as opposed to the Old one having a leading 1.
As the other format is very old and doesn't need to be supported by new applications, the specification omits it entirely.*

### Qualification

Represents a requirement that a person must satisfy to qualify to register for the given event.
See paragraph 5.1 of [WCA Competition Requirements Policy](https://www.worldcubeassociation.org/documents/policies/external/Competition%20Requirements.pdf) for more details.

| Attribute | Type | Description |
| --- | --- | --- |
| `whenDate` | [`Date`](#date) | The date by which the qualification requirement must be satisfied.  If a result is set in a multiple-day competition which ends before this date, that is considered to have been set by this date. |
| `type` | `"attemptResult"\|"ranking"\|"anyResult"` | The type of qualification. Either of ranking (top N competitors), attempt result (competitors with result better than Y - either single or average) or any result (competitors with any successful result of the given type). |
| `resultType` | `"single"\|"average"` | The type of result the requirement refers to. |
| `level` | [`AttemptResult`](#attemptresult)\|[`Ranking`](#ranking)\|`null` | The parameter of the qualification condition of the given type. Not used with `anyResult`. |

#### Examples

```json
{
  "whenDate": "2020-04-25",
  "type": "attemptResult",
  "resultType": "single",
  "level": 6000
}
```

```json
{
  "whenDate": "2020-04-25",
  "type": "ranking",
  "resultType": "average",
  "level": 50
}
```

```json
{
  "whenDate": "2020-04-25",
  "type": "anyResult",
  "resultType": "single",
  "level": null
}
```

### Result

Represents a competitor result in a single round.

| Attribute | Type | Description |
| --- | --- | --- |
| `personId` | `Integer` | The corresponding person `registrantId`. |
| `ranking` | `Integer\|null` | The ranking in this round. May be `null` if the result is empty (yet to be entered). |
| `attempts` | [`Attempt`](#attempt) | List of attempt results the competitor got. If there are fewer attempts than expected, the rest is considered skipped (effectively `0`). |
| `best` | [`AttemptResult`](#attemptresult) | The best attempt result of `attempts`. |
| `average` | [`AttemptResult`](#attemptresult) | The average attempt result of `attempts` (depending on the format, either average of 5 or mean of 3). |

#### Example

```json
{
  "personId": 1,
  "ranking": 10,
  "attempts": [...],
  "best": 720,
  "average": 950
}
```

### Attempt

Represents one of attempts a competitor got during the given round.

| Attribute | Type | Description |
| --- | --- | --- |
| `result` | [`AttemptResult`](#attemptresult) | The achieved attempt result. |
| `reconstruction` | `String\|null` | An optional reconstruction of the attempt. |

#### Example

```json
{
  "result": 650,
  "reconstruction": "z y2 U Rw' D2 L F' L' D' ..."
}
```

### ScrambleSet

Represents a set of scrambles used in the given round (in one or multiple simultaneous groups).

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `Integer` | The scramble set identifier, unique within the competition. |
| `scrambles` | [`[Scramble]`](#scramble) | List of scrambles. |
| `extraScrambles` | [`[Scramble]`](#scramble) | List of additional scrambles, used for extra attempts granted by the delegate. |

#### Example

```json
{
  "id": 1,
  "scrambles": [...],
  "extraScrambles": [...]
}
```

### Scramble

A `String` representing a single scramble (a sequence of moves used to mix up the given puzzle).
Scrambles for official competitions are generated by [TNoodle](https://www.worldcubeassociation.org/regulations/scrambles).

For 3x3x3 Multi-Blind, where each attempt involves many physical puzzles to be mixed up,
the value consists of all the individual scrambles separated by a new line (`"\n"`).

#### Example

```json
"B D2 U2 B2 R2 F D2 L2 D2 F2 D2 L' F D' R' D L' U F L"
```

### Schedule

Represents the competition data related to time and scheduling.

| Attribute | Type | Description |
| --- | --- | --- |
| `startDate` | [`Date`](#date) | The date when the competition starts. If the competition has multiple venues, this date must be the earliest one, considering every timezone. |
| `numberOfDays` | `Integer` | The number of days the competition spans. |
| `venues` | [`[Venue]`](#venue) | List of all the competition venues. |

#### Example

```json
{
  "startDate": "2020-06-12",
  "numberOfDays": 2,
  "venues": [...]
}
```

### Venue

Represents a physical location where the competition takes place.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `Integer` | The venue identifier, unique within the competition. |
| `name` | `String` | The venue name. |
| `latitudeMicrodegrees` | `Integer` | The geographic latitude of the venue in microdegrees (degrees times 10^6). |
| `longitudeMicrodegrees` | `Integer` | The geographic longitude of the venue in microdegrees (degrees times 10^6). |
| `countryIso2` | [`CountryCode`](#countrycode) | The country where the venue is locates. |
| `timezone` | `String` | The [Olson timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) of the venue. |
| `rooms` | [`[Room]`](#room) | List of all the relevant rooms at the venue. |
| `extensions` | [`[Extension]`](#extension) | List of custom competition extensions. |

#### Example

```json
{
  "id": 1,
  "name": "Melbourne Convention and Exhibition Centre",
  "latitudeMicrodegrees": -37825214,
  "longitudeMicrodegrees": 144952280,
  "countryIso2": "AU",
  "timezone": "Australia/Melbourne",
  "rooms": [...],
  "extensions": [...],
}
```

### Room

Represents a specific room at the given venue.
If there are multiple stages (areas with timing stations), each should be treated as a separate, virtual room.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `Integer` | The room identifier, unique within the competition. |
| `name` | `String` | The room name. |
| `color` | `String` | The color representing the room. Must be an hexadecimal code (3 or 6 digits). |
| `activities` | [`[Activity]`](#activity) | List of all the activities taking place in the room. |
| `extensions` | [`[Extension]`](#extension) | List of custom competition extensions. |

#### Example

```json
{
  "id": 1,
  "name": "Main stage",
  "color": "#00aeff",
  "activities": [...],
  "extensions": [...]
}
```

### Activity

Represents an activity taking place in the given room in a specified timeframe.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `Integer` | The activity identifier, unique within the competition. |
| `name` | `String` | The activity name. |
| `activityCode` | [`ActivityCode`](#activitycode) | The standardized code representing the activity. |
| `startTime` | [`DateTime`](#datetime) | The point in time when the activity starts. |
| `endTime` | [`DateTime`](#datetime) | The point in time when the activity ends. |
| `childActivities` | [`[Activity]`](#activity) | List of all the sub-activities taking place as part of the activity (e.g. groups in a round activity). Each child activity's `activityCode` must contain its parent's `activityCode`. |
| `scrambleSetId` | `Integer\|null` | An optional attribute pointing to a specific [ScrambleSet](#scrambleset). If this activity is an Nth attempt, then the Nth scramble in that scramble set is used. Multiple activities may use the same `scrambleSetId` if desired. Can only be set for activities that represent a group or an attempt. |
| `extensions` | [`[Extension]`](#extension) | List of custom activity extensions. |

#### Example

```json
{
  "id": 1,
  "name": "3x3x3 Cube, Round 1",
  "activityCode": "333-r1",
  "startTime": "2019-07-13T05:20:00Z",
  "endTime": "2019-07-13T08:00:00Z",
  "childActivities": [...],
  "scrambleSetId": 1,
  "extensions": [...]
}
```

### ActivityCode

A `String` identifying something happening at the competition.

###### Official WCA activities

Format: `{eventId}[-r{roundNumber}][-g{groupName}][-a{attemptNumber}]`

For example, these are all valid WCA activity codes (in decreasing specificity):

|  Activity code | Name |
| --- | --- |
| `333-r1-g3-a1` | 3x3x3 Cube, Round 1, Group 3, Attempt 1 |
| `333-r1-g3` | 3x3x3 Cube, Round 1, Group 3 |
| `333-r1` | 3x3x3 Cube, Round 1 |
| `333` | 3x3x3 Cube |

In some events (e.g. 3x3x3 Multi-Blind, 4x4x4 Blindfolded, 5x5x5 Blindfolded) all attempts aren't necessarily done in the same group. Because of this, the code may specify an attempt without regard to group.
Here are some valid WCA activity codes for 3x3x3 Multi-Blind (in decreasing specificity):

|  Activity code | Name |
| --- | --- |
| `333mbf-r1-g3-a2` | 3x3x3 Multi-Blind, Round 1, Attempt 2, Group 3 |
| `333-r1-a2` | 3x3x3 Multi-Blind, Round 1, Attempt 2 (any group) |
| `333-r1` | 3x3x3 Multi-Blind, Round 1 |
| `333` | 3x3x3 Multi-Blind |

Activities may be nested. If an activity A contains a child activity B, then activity B's code must contain all items from the parent activity's code.

For example:

- `333-r1-g3` is a valid child of `333-r1`
- `444bf-r1-g3-a1` is a valid child of `444bf-r1-g3` or `444bf-r1`
- `333-g3` is **not** a valid child of `333-r1`
- `333-r2-g3` is **not** a valid child of `333-r1`

###### Other activities

Format: `other-{id}`

The specification defines the following common IDs:

|  Activity code | Name |
| --- | --- |
| `other-registration` | Registration at the venue. |
| `other-checkin` | Check-in at the venue. |
| `other-tutorial` | Tutorial for new competitors. |
| `other-multi` | Submission of multi-blind cubes in advance of an attempt. |
| `other-breakfast` | Breakfast time. |
| `other-lunch` | Lunch time. |
| `other-dinner` | Dinner time. |
| `other-awards` | Awards ceremony. |
| `other-unofficial-{activityCode}` | Unofficial event. The activity code should follow the rules above, except that the event id will be competition-specific. Where possible, the event ids listed [here](http://cubing.github.io/icons) are recommended. For example, `other-unofficial-magic-r1-g3` is a possible activity code. |

All other activities not defined by the specification should use either `other-misc` or `other-misc-{id}`.

### Date

A `String` representing the date in `YYYY-MM-DD` format.

### DateTime

A `String` representing a date and time according to [ISO 8601
](https://en.wikipedia.org/wiki/ISO_8601).

### Extension

Represents custom data that may be added to several WCIF entities.

| Attribute | Type | Description |
| --- | --- | --- |
| `id` | `String` | The extension identifier. Should follow the Java package naming convention, starting with a URI related to the developer and specifying the object in question. |
| `specUrl` | `String` | A valid URI pointing to a published specification documenting the format of their extension (e.g. using [JSON Schema](https://json-schema.org)). |
| `data` | `Object` | An object containing an arbitrary extension-specific data compliant with the documented format. |

#### Information

Users of custom extensions should have lower expectations about how permanent the specifications are.
While fields defined by this specification should be expected not to change regularly,
users of custom extensions should expect to update their code more regularly as the extension specifications evolve.

Developers who create extensions that become widely used are expected to propose additions of their custom fields to this specification.

Any application that consumes WCIF data should (whenever possible) save extensions as JSON blobs and include them in future WCIF outputs.

#### Motivation

Many developers will find it useful to attach data related to their specific application,
which may not be used widely-enough to include in this specification. For example:
- references to entities in their datastores
- data such as shirt sizes for competitors, which has not yet been proven to be generalized
- data such as US states where competitors live, which is only relevant to applications in the USA

Finally, this helps to protect the specification from bloat or namespace pollution,
by allowing developers to introduce new fields before they are proven to be generally useful.

#### Example

```json
{
  "id": "org.someapplication.Stage",
  "specUri": "https://someapplication.org/wcif/stage.json",
  "data": {
    "timingStations": 16,
    "area": 50
  }
}
```
