---
title: Handy 1Password CLI Wrapper Functions
date: "2020-11-07T15:10:00.000Z"
description: Handy 1Password CLI Wrapper Functions
---

I made these functions just now. Add them to your bash profile to make standard functionality
of 1Password's CLI easier to manage. If login is required then it asks for your password and retries.

The following will cover 99% of my requirements from 1Password (provided I know the _exact_ name of the password item).

Note that they both require xclip. Perhaps you don't have xclip so plonk something else in there.

## Get Password

Use it like `pass Google` and the password for Google will be copied to the clipboard.

`gist:b5cda46f10539a73ffd7bc574b0b2f3a#pass.sh`

## Get OTP

Use it like `otp Github` and the one-time password for Github will be copied to the clipboard.

`gist:b5cda46f10539a73ffd7bc574b0b2f3a#otp.sh`
