#!/bin/sh

root=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

read -p "Enter Name of Post: "  name

kebab_name=$(echo $name | \
  tr '[:upper:]' '[:lower:]' | \
  sed "s/ /-/g" | \
  sed "s/[^a-z0-9-]//g")

post_dir="$root/content/blog/$(date +"%Y-%m-%d")-$kebab_name"

mkdir "$post_dir"
post_path="$post_dir/index.md"

cat > $post_path << EOL
---
title: $name
date: "$(date +"%Y-%m-%dT%H:%M:00.000Z")"
description: $name
---

EOL

echo $post_path
