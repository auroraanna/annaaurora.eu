#!/usr/bin/env just --justfile
NAME:='papojari.codeberg.page'
BUILD_DIR:='public'

# By default, recipes are only listed.
default:
	@just --list

build:
	#!/usr/bin/env bash
	set -uxo pipefail
	# `lossless.webp`s sha256s
	BUILD_LOSSLESS_IMAGE_SHA256S=$(ls -1 $PWD/public/art/*/* | awk '/lossless.webp/' | sed 's/ /" "/g' | sed 's/(/"("/g' | sed 's/)/")"/g' | sed 's/:/":"/g'| xargs sha256sum | cut -c 1-64)
	# Let Zola compile the website
	zola build
	# Art section generate lossy images if the lossless images changed
	if [[ $(echo $(ls -1 $PWD/content/art/*/* | awk '/lossless.webp/' | sed 's/ /" "/g' | sed 's/(/"("/g' | sed 's/)/")"/g' | sed 's/:/":"/g'| xargs sha256sum | cut -c 1-64)) != $(echo $BUILD_LOSSLESS_IMAGE_SHA256S) ]]; then
		for art_name in $(ls -1 public/art | awk '! /.html/'); do
			convert {{BUILD_DIR}}/art/$art_name/lossless.webp -quality 90% 	{{BUILD_DIR}}/art/$art_name/lossy.webp
		done
	fi


