## Mailing List 

Sign up in your [profile preferences](https://www.worldcubeassociation.org/profile/edit?section=preferences) to our developer mailing list to receive updates about new versions and deprecations.

## Version Numbering

We will follow [SemVer](https://semver.org/)’s Major.Minor.Patch format, defined as follows: 
- **Major**: increments upon _breaking changes_ - ie, changes that would cause errors in implementations relying on the current latest version
    - Removing or renaming a field
    - Changing a field’s type, or removing previously-available enum values
    - Major changes in business logic - such as the addition of a new round format or advancement type.[^1]
- **Minor**: increments upon the addition of new functionality that maintains _forward compatibility_ - ie, existing implementations can continue without error
    - Adding a new field, adding values to an existing enum
- **Patch**: clerical changes improving spec clarity, or a change which does not meaningfully alter API output
    - Correcting an inconsistency in field naming between documentation and the example of the documentation
    - Bugfixes that alter incorrect behaviour to align with documented behaviour

[^1] Sometimes these changes may "just" take the form of a new enum value, which would usually be handled by a Minor version increment. In certain cases, however, the change to business logic is significant enough to mandate a Major version change, to ensure that backwards-compatibility doesn't allow third-party tools to create undesireable outcomes (such as incorrectly determining round advancement from a new round advancement criterion). 

## Version Lifecycle

There are several stages of a version lifecycle, specified by `version_status` field in WCIF. A nullable `status_advancement_date` field will indicate when the `version_status` will progress to the next stage of the lifecycle.
- **Beta**: Early release of a new version - made available to developers for testing, or early access to newly-supported features. Spec may be subject to change
- **Latest**: Latest WCIF version, made available to developers for feedback and early migration. Spec is considered final.
    - When a `latest` version is released, a `status_advancement_date` will be given to the current `stable` version
- **Stable**: The WCIF version served by default
- **Deprecated**: Backwards compatibility will be maintained where possible, but clients should updated their version to either `latest` (ideally) or `stable` (at minimum) by the `status_advancement_date` to maintain functionality
- **Removed**: No longer supported, not possible to access via API endpoints

## Requesting Specific Versions
The existing WCIF endpoints will remain, and always serve the `stable` version of WCIF.

The following endpoints are not yet available, but will be implemented when we increment to v2.0 - this is expected in Q1 2026.
- `api/v0/competitions/{competition-id}/wcif/{lifecycle-name}` to request the latest, or beta versions
- `api/v0/competitions/{competition-id}/wcif/version/{version-number}` to request a specific version number

## Backwards Compatibility  
- In general, we aim to align with Google's [API-180](https://google.aip.dev/180) - feel free to raise concerns with us by opening a Github issue if you feel we deviate from this
- We guarantee that new version releases within the same major version number (v2.1 -> v2.2) will maintain backwards compatibility.
- In some cases, features will be introduced which require a major version increment, and for which backwards compatibility is not possible. When competitions use these features, we will return a `403: Forbidden` error for both GET and PATCH requests against an unsupported version of WCIF.
