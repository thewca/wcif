# Vision

The vision behind creating the WCIF specification.

## Motivation

There has always been tools used to help organizers prepare the various aspects of organizing a competition,
but as those were separate, it was hard for them to talk to one another
(which lead to various export files in different formats).
In order to support the idea of relatively small tools cooperating with each other
and allow them to talk the same language, the idea of a standardized data format has been coined.

The underlying spirit is the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
emphasizing building small, focused software trying to solve one problem, and solve it well
(as opposed to monolithic systems).

## Example applications

#### Nametag generation

A tool generating nametags for all the competitors requires at least the following information:
- competitor name
- competitors WCA ID
- competitor task assignments (e.g. in which group they participate)

#### Scorecard generation

A tool generating scorecards for the given round requires at lest the following information:
- competitor name
- competitor ID (for data entry)
- round cutoff and time limit (to display it on the scorecard)
- expected number of attempts

Furthermore, there is a need to generate scorecards for subsequent rounds of an event.
Without a proper way of exchanging results data, this forces authors of data entry platforms
to implement scorecards (a task which is somewhat orthogonal to data entry itself).
With a standardized data format that includes all the information about who advanced to the later rounds of an event,
there can be a single piece of software handling the entirety of scorecard generation.

#### Group assignment

A tool assigning groups to people (i.e. competing as well as other tasks)
requires or may benefit from the following information:
- competitor personal bests (to split people into groups based on their skills)
- competitor roles (to handle organizers, delegates, staff in a special manner)
- competitor WCA ID (to handle newcomers in a special manner)
- competitor birthdate (to handle youngsters in a special manner)
- schedule data (to avoid assigning multiple tasks at the same time and also optimize assignments based on time)
- round results, advancement information (to assign groups for subsequent rounds)

#### Scramble generation

A tool generating scrambles for a competition requires at lest the following information:
- the number of events an rounds
- the number of scramble sets to generate for each round

## Falsehoods programmers believe about WCA competitions

> A competition occurs in one time zone and all competitors register for the same venue of a competition.

**False!** Some competitions have multiple venues, such as FMC simultaneous competitions (FMC USA, FMC Europe).

> Ok, but surely a given venue of a competition can be identified by a latitude and a longitude?

**Mostly false!** [Euro 2016](https://euro2016.cubing.net/venue) had a side room that was a noticeable walk from the main venue.

> At a given point in time, a competition has at most one event occurring at once.

**False!** US Nationals has had 6 stages spread across multiple rooms and buildings, with up to 5 events occurring simultaneously.

> One round of a competition occurs on one calendar day.

**False!** The 3 attempts of a 3x3x3 Fewest Moves round are usually split across multiple days. The same is true for 3x3x3 Multi-Blind.

> Ok, but FMC and MBLD are weird. Surely a given round of 3x3x3 will at least all occur on one calendar day?

**False!** US Nationals runs a staff competition on Thursday before the regular competitors do their first rounds on Friday or Saturday.

> A competitor will receive all his scrambles for a round from one group.

**False!** Many competitions have a "rolling group" system where competitors get called up in groups, but the next group might get called up while you're still competing, which means you'll roll into the next group.

> Ok, that's annoying, but at least for planning purposes, we can assign competitors to 1 group for a given round, and if they roll into the next group, then that's ok.

**False!** Remember FMC and MBLD from before? You may be scheduled to compete in group A of MBLD Round 1 Attempt 1, but group B of MBLD Round 1 Attempt 2.

> 3x3x3 Final Round will have >= 3 competitors in it.

**False!** See the results of [Korean Spring Picnic 2017](https://www.worldcubeassociation.org/competitions/KoreanSpringPicnic2017/results/all?event=333).
