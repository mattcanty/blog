---
title: Disabling Pihole with iOS Shortcuts
date: "2020-11-11T19:24:00.000Z"
description: Disabling Pihole with iOS Shortcuts
---

This morning, I had the 2nd annoyance since installing a Pihole on my home network.
Pihole redirects DNS requests to a "hole" if the requested domain is found on one
of the lists you configure it with.

The purpose of the Pihole application is to reduce needless traffic traversing
your network. This is useful for things like tracking and ads. However there have
been some times with a legitmate domain being blocked.

In both of these cases, I knew that I didn't want or need to update my lists, I
just needed to pause it for a brief time. Long enough to click a link in an email.

Problem is I am on my phone and I don't really want to boot up a computer, SSH
into the Pi, run the command. I'd rather just not click the link.

Then I checked out Shortcuts which is an app with comes with iPhone. Lo' and behold
there is an SSH function!

So here goes:

1. Download [Shortcuts from the App Store](https://apps.apple.com/us/app/shortcuts/id915249334) if you haven't already got it.
2. Open the app once it has downloaded and tap **Create Shortcut**
3. Tap **Add Action** and search for **SSH** - _Run Script Over SSH_ should appear, tap it!
4. This will add the action, but you need to configure it. Tap **Show More**. You will need to enter:
   1. Host - This is the IP address or hostname on your network where pihole is running
   2. Port - Usually `22`
   3. User - If you're using Raspberry Pi, you probably want to enter `pi` (Professionals see end of page)
   4. Password - If you're using Raspberry Pi, you probably want to enter `raspberry` (Professionals see end of page)
   5. Script - type `pihole disable 30s`

That is it.

![Pause Pihole shortcut settings showing host port user password and script](https://lh3.googleusercontent.com/RdwUW8n6x5M3aCbBks6BkSXFXwtOs2wD8GylPjKJSbu9lWgPaAOAfEoUOsIkuIp1uzBPCWA8cpc3zPiDQWqf6wjm5e7aFW7edKgmHYTDiBtg4m_eryMDTPNczLQ4n4kHxyasrhePuus=w400 "iPhone Screenshot of shortcut settings")

I have also set up the shortcuts widget so that I can easily access the functionality
from my home screen.

![Widget screen on iPhone showing the Pause Pihole function](https://lh3.googleusercontent.com/8duBfn-9k6Mm5CfoSjMkDnivhrPgcef9shKZkEBunqduWKilE9_MAXTpPhHlrt-7FYeNqk-LGsApELV5tzkco43-qq75KIVteXwCahMNlWC1avW4Cx77zgdpXEWQwD8aMHIK__cz1_0=w400 "iPhone widgets screen")

## End of Page

If you are a pro. Then you are going to want to do a bit more than use the default
username and password for your Raspberry Pi.

My advice would be to:

1. Use SSH (yes the app supports SSH Key as well - I still need to do this)
2. Create a 2nd user, which does not have root access to your device. In essence the `pi` user is allowed to do _anything_ on your Pi. So you are leaving yourself a little vulnerable...

You have been warned.

I hope you find this useful :-)
