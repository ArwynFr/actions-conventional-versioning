# Conventional Versioning

This Github action creates a new Github Release, using [Semantic Versioning](https://semver.org/) and [Conventional Commits](https://www.conventionalcommits.org/) messages.

## Current version
The current version is based on latest Github Release *tag name*.
If there is no release or the tag is not a valid version number, the action will default to `0.0.0`.
Current version should not include any prefix, values such as `v1.2.3` or `ver-1.2.3` are **not** understood by this action and will have the action default to `0.0.0`.

## Change type
The type of version change is based on HEAD commit message, taken from [`github.event` context](https://docs.github.com/en/actions/learn-github-actions/contexts). 
* `Fix` will bump the patch version
* `Feature` will bump the minor version
* `Breaking` will bump major version

Breaking changes can either use the explicit notation (`BREAKING CHANGE:` in the body or footer) or the bang notation (`type(scope)!: description` in the first line).
If the message is not understood as a valid conventional commit, the change type will default to `Fix`.
You should consider using this action in conjunction with another one enforcing commit message format.

## Release creation
This action uses [Github CLI](https://cli.github.com/) and needs **not** to checkout the repository.
The release will autogenerate the notes, tag the source code, and include source archives to the release by default.
You can add additional files using the [`pattern` input variable](#pattern).
This pattern matches the syntax for [`gh release create`](https://cli.github.com/manual/gh_release_create) command.

## Inputs
### Pattern
Wildcard pattern used to add files in the release.

### Whatif
Used to run the action in what-if mode, that will calculate the new version without creating an actual release.
This can be used to add the next-version number in the product source before build.
If you want to run the action in what-if mode, you must set the value to `$true`.

## Outputs
### Current-version
Current version found in the repository, format `1.2.3`.

### Bump-type
Type of version bumping, one of the following: `Breaking`, `Feature`, `Fix`.

### Next-version
Version number for the new release, format `1.2.3`.

## Example

This action will create a release with artifacts for each commit on the master branch :

```yml
on:
  push:
    branches: [master]

jobs:

  # insert another job that will build and upload some artifacts

  publish:
    runs-on: ubuntu-latest
    name: 'Publish a new release'
    steps:

    - uses: actions/download-artifact@v2
      with:
        name: my-artifact
        path: artifacts

    - uses: arwynfr/actions-conventional-versioning@1.0.0
      with:
        pattern: artifacts/*
```
