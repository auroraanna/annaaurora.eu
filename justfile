#!/usr/bin/env just --justfile
NAME:='papojari.codeberg.page'
BUILD_DIR:='public'

# By default, recipes are only listed.
default:
	@just --list

alpine-install-deps:
	@apk add {{ALPINE_DEPS}}

alpine-uninstall-deps:
	@apk del {{ALPINE_DEPS}}

non-nixos-install-deps:
	#!/bin/sh
	set -euxo pipefail
	# Serve Website
	zola serve
	for package_name in {{NIXPKGS_DEPS}}; do
		nix-env -iA nixpkgs.$package_name
	done

nixos-install-deps:
	#!/bin/sh
	set -euxo pipefail
	for package_name in {{NIXPKGS_DEPS}}; do
		nix-env -iA nixos.$package_name
	done

nix-uninstall-deps:
	#!/bin/sh
	set -euxo pipefail
	for package_name in {{NIXPKGS_DEPS}}; do
		nix-env -e $package_name
	done

git-download-submodules:
	@git submodule update --init --recursive

# Serve website
serve: git-download-submodules
	@zola serve

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


