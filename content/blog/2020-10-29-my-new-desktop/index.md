---
title: Raspberry Pi 4 Dinner
date: "2020-10-29T18:30:00.000Z"
description: I'm going to use my Raspberry PI for anything which doesn't need the oompf
---

A friend of mine is really into using their Pi for personal computing. They're also really
into privacy and security. It is kinda great considering their career isn't technical.
It's impressive stuff and makes a nice change to hear someone be genuinely concerned about
passwords.

They use a Pi so why can't _i_?

This morning I had a RaspberryPi 4 sitting around at home. Installed on it was Raspian Lite
which is a terminal-only version of Raspberry Pi's Linux variety.

Despite all the great benefits of a terminal, I think a GUI will be needed if I intend
to do things like visit websites and write code.

_Side note: I've just noticed my hand is going a little numb due to the position of my arm against the desk._

## From Lite to GUI Raspian

First of all I had to "upgrade" out of Lite and get the GUI. There are a few options, but
I just wanted the simplest and least-hassle. I followed the tips at [raspberrytips.com](https://raspberrytips.com/upgrade-raspbian-lite-to-desktop/)
to make this dream a reality:

```shell
sudo apt update
sudo apt upgrade
sudo apt install raspberrypi-ui-mods
sudo apt install lightdm
sudo apt install xserver-xorg
sudo reboot
```

Most or all of the things were already installed. After reboot I found that I had to run `sudo raspi-config`
and edit `System Options > Boot / Auto Login`. I set this to `Desktop AutoLogin` (SCARY).

After I changed this, a quick reboot proved that I now jump directly to the desktop.

It's important to get the basics set up quickly on a new machine. For me this is:

* Install a 1Password client
* Login to GitHub
* Write a new blog post (yeah that's this, and this is a joke)

## 1Password CLI

I have bitten the bullet. After many years of wondering what it would be like. I have finally gone
in and done that thing and gone with CLI-only for 1Password.

Until I'd put about 3000 commands through the thing I wondered if I had totally missed
the point. Basic use cases are hard to achieve first time around. I'll try and summarise those important ones now,
for me in the future.

### Login

This is all you need to login. Obviously if you're not using my.1password.com then you'll know about that. Otherwise,
go wild. This single command is all you need.

```shell
eval $(op signin my.1password.com)
```

### Search

This was not immediately obvious to me when I started. I was looking around for the truth, then I realised that
they have really handed over all the logic to `jq`. That is pretty smart.

Install `jq`:

```shell
sudo apt-get install jq
```

Then you probably don't remember the exact names of the items in your vault, or the UUIDs, I certainly don't. If that
is the case you want to make use of the `contains()` function of `jq` to find your stuffs.

Follow that with a command to get the actual password.

```shell
op list items --vault Personal | jq '.[] | select(.overview.title | contains("Github"))'
{
  "uuid": "123123123123123123123123",
  "templateUuid": "001",
  "trashed": "N",
  "createdAt": "2000-01-01T08:00:00Z",
  "updatedAt": "2020-09-10T07:16:38Z",
  "changerUuid": "345345345345345345345",
  "itemVersion": 8,
  "vaultUuid": "45646456456456456456456456",
  "overview": {
    "URLs": [
      {
        "l": "website",
        "u": "https://github.com"
      }
    ],
    "ainfo": "matthewcanty@gmail.com",
    "ps": 84,
    "tags": [
      "imported 17/10/2016 10:39"
    ],
    "title": "Github",
    "url": "https://github.com"
  }
}

op get item 123123123123123123123123 --vault Personal | jq -r '.details.fields[] | select(.name == "password") | .value'
```

Ask me about adding or editing items. I haven't got the muster to write about it now.
Also if you get this far, you can probably manage... **hint** `op create item Login --help`

## pbcopy / xclip

I've found one thing particularly annoying compared to Mac.

On a Mac there is the handy `cmd` button. With this button I can do copy & paste commands in the terminal.
Perhaps someone can tell me how to do this on Raspian. I've always also liked `pbcopy` which is useful
for seamlessly sending piped output to the clipboard on Mac.

```shell
echo "hello!" | pbcopy
# then go and cmd+p somewhere
```

On this occasion I opted for `xclip` (`sudo apt-get install xlip`). I've never used it before, but I was
immediately disappointed at how verbose the basic command is:

```shell
xclip -sel clip
```

How am I meant to remember `-sel` and `clip` in the heat of the moment. I know I won't. So it's time to
add my first function to this machine. I created `~/.functions` and added it to my `.bashrc` with
`echo "source ~/.functions >> ~/.bashrc"`

In `~/.functions` I added:

```shell
clip() {
  xclip -sel clipboard $1
}
```

Now I can just `| clip` to my hearts content. In fact I used it just now to to copy that last code snippet (`cat ~/.functions | clip`)!

## Self-Documenting Awesome History

I thank [Martin Kiesel](https://github.com/Kyslik) forever for this tip. Just use `fzf`.

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd `~/.fzf`
./install
```

Now in the terminal `ctrl+r` becomes this wonderland of things you once knew but
can never remember. You do not need to remember anymore.

## SSH Keys

Remember everyone. New SSH key for each machine. Private means private. For the
machine, not for you.

Make it strong, sure it takes longer, but what else did you have planned for those
3.8 seconds?

```shell
ssh-keygen -t rsa -b 4096 -C yourName@email.address
```

Set a password. Make it 64 characters and very complicated. Put the password in 1Password.

It is safe. Do not worry about it. Log in to you Github account or wherever you need that
SSH key and plop it in to start coding.

```shell
cat .ssh/id_rsa.pub | clip
```

## All done

Who did I write this for again?
