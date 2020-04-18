#!/bin/sh

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

read -p "Enter Name of Post: "  name

kebab_name=$(echo $name | tr '[:upper:]' '[:lower:]' | sed "s/ /-/g" | sed "s/[^a-z0-9-]//g")

post_path="$parent_path/content/blog/$(date +"%Y-%m-%d")-$kebab_name"

mkdir "$post_path"

cat > "$post_path/index.md" << EOL
---
title: $name
date: "$(date +"%Y-%m-%dT%H:%M:00.000Z")"
description: $name
---

EOL
