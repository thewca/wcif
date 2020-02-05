# Style guide

## Identifiers

Objects can have an `id` field.
It is named `id` in the object it identifies,
and `objectId` when referring to another `object` from somewhere else.
IDs must be unique for the competition they show up in.
It's okay for IDs to be the same across competitions, however.

## Typed names

Field names should indicate their format for non trivial types. For example:
- `xTime` - specific point in time
- `xDate` - date in the `YYYY-MM-DD` format

## Humanly readable and writeable

Everything should be humanly read- and writeable as far as possible.
