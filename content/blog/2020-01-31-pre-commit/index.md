---
title: Pre-Commit Tip
date: "2020-01-31T12:00:00.000Z"
description: |
  Installing pre-commit in a repo on your machine won’t automatically make
  pre-commit work in that repo on your colleagues machine.
---

[pre-commit.com](https://pre-commit.com/)

**pre-commit** is a straightforward way to ensure basic checks are maintained in
a respository, before errors are even committed to a local branch.

This is particularly useful for light-touch validations like linting.

Find out here how to:

- Install pre-commit locally
- Configure pre-commit to lint all your files on commit
- Use GitHub actions to ensure nothing is merged pre-commit

## Installing

As a user, you need to ensure you have the pre-commit installed first:

```bash
brew install pre-commit
```

Each repo needs it installed separately. From a checked out repository, install by running:

```bash
pre-commit install
```

This will now run pre-commit each time you git commit. If you want to run pre-commit manually without committing, run:

```bash
pre-commit run --all-files
```

## Configuring

On it’s own it won’t actually do anything. You need to provide a `.pre-commit-config.yaml` in the repository root, something like:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-merge-conflict
```

There are lots of other hooks, see the supported list here: [pre-commit.com/hooks.htm](https://pre-commit.com/hooks.htm)l

## Caveat

Installing pre-commit in a repo on your machine won’t automatically make pre-commit work in that repo on your colleagues machine.

Remember that pre-commit install is making a change to _your local revision_.

### Work Around

Make use of GitHub actions, to run pre-commit checks post-push!

Add the following to `.github/workflows/pre-commit.yml` (source [github.com/pre-commit/action](https://github.com/pre-commit/action))

```yaml
name: pre-commit

on:
  pull_request:
  push:
    branches: [master]

jobs:
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions/setup-python@v1
      - name: set PY
        run: echo "::set-env name=PY::$(python --version --version | sha256sum | cut -d' ' -f1)"
      - uses: actions/cache@v1
        with:
          path: ~/.cache/pre-commit
          key: pre-commit|${{ env.PY }}|${{ hashFiles('.pre-commit-config.yaml') }}
      - uses: pre-commit/action@v1.0.1
```

This way if someone checks in badly formatted YAML because they forgot to pre-commit install, this workflow will catch them in the act before it is merged into master.
