# Qualification

```json
{
  "whenDate": "2020-04-25",
  "condition": {
    "type": "attemptResult",
    "resultType": "single",
    "level": 6000
  }
}
```


# ParticipationCondition

```json
{
  "competitions.events.rounds.333-r1.participationCondition": {
    "source": {
      "type": "registrations",
      "roundIds": null
    },
    "condition": null,
    "reservedPlaces": {...}
  }
}

{
  "competitions.events.rounds.333-r2.participationCondition": {
    "source": {
      "type": "rounds"
      "roundIds": ["333-r1"],
    },
    "condition": {
      "type": "percent",
      "resultType": null,
      "level": 75
    },
    "reservedPlaces": {...}
  }
}
```

## or, different object per condition

```json
// each of these fall under the `...etc.condition` key:
{
  "type": "percent",
  "percent": 75
},
{
  "type": "result", // Should we not be using this instead of attemptResult? Can people not qualify based on single or average? It's possible that the meaning of `attempt` has shifted
  "resultValue": 6000
},
{
  "type": "ranking",  // Perhaps we should use `position` instead? `ranking` infers _global_ ranking, whereas we want ranking within a round
  "ranking": 50
},
{

}


}
```
