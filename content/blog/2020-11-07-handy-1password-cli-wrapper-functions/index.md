---
title: Handy 1Password CLI Wrapper Functions
date: "2020-11-07T15:10:00.000Z"
description: Handy 1Password CLI Wrapper Functions
---

I quickly got bored of having to execute the login command each time I wanted a password from
1Password CLI. These functions check for the _not logged in_ error and ask for your password
there and then.

Also the functions wrap up getting the password and copying it to the clipboard.

You will need:

* [1Password CLI](https://support.1password.com/command-line-getting-started/)
* [xclip](https://github.com/astrand/xclip) eg `apt-get install xclip`
* [jq](https://github.com/stedolan/jq) eg `apt-get install xclip`

The following will cover 99% of my requirements from 1Password (provided I know the _exact_ name of the password item).

## Get Password

Use it like `pass Google` and the password for Google will be copied to the clipboard.

`gist:b5cda46f10539a73ffd7bc574b0b2f3a#pass.sh`

## Get OTP

Use it like `otp Github` and the one-time password for Github will be copied to the clipboard.

`gist:b5cda46f10539a73ffd7bc574b0b2f3a#otp.sh`
