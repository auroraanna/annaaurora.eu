#!/usr/bin/env just --justfile
NAME:='annaaurora.eu'
BUILD_DIR:='public'
ALPINE_DEPS:='git just zola tidyhtml imagemagick rsync lmms jack --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/'
NIXPKGS_DEPS:='git just zola html-tidy imagemagick rsync lmms'

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

build: git-download-submodules
	#!/bin/sh
	set -uxo pipefail
	# Let Zola compile the website and format HTML
	zola build
	for file in $(find public -name '*.html'); do
		tidy -m --wrap 0 --indent true --indent-with-tabs false --indent-spaces 4 $file
		sed -i 's/    /	/g' $file
	done
	# Copy license file into top directory
	cp content/License.md public/LICENSE.md
	# Art section generate lossy images and generate audio
	for art_name in $(ls -1 public/art | awk '! /.html/'); do
		if [ -f "{{BUILD_DIR}}/art/$art_name/lossless.webp" ]; then
			convert {{BUILD_DIR}}/art/$art_name/lossless.webp -quality 90% {{BUILD_DIR}}/art/$art_name/lossy.webp
		fi
		if [ -f "{{BUILD_DIR}}/art/$art_name/source.mmpz" ]; then
			lmms render {{BUILD_DIR}}/art/$art_name/source.mmpz --allowroot --format wav --loop --output {{BUILD_DIR}}/art/$art_name/lossless.wav
			lmms render {{BUILD_DIR}}/art/$art_name/source.mmpz --allowroot --format ogg --loop --output {{BUILD_DIR}}/art/$art_name/lossy.ogg
		fi
	done
	# Delete error 404 page because the Caddy web server delivers the error 404 page from somewhere else.
	rm {{BUILD_DIR}}/404.html

deploy: build
	#!/bin/sh
	set -euxo pipefail
	# Configure git identity
	git config --global user.email "mail@ci.codeberg.org"
	git config --global user.name "Codeberg CI"
	# Clone deploy repository
	git clone https://"$CODEBERG_ACCESS_TOKEN"@codeberg.org/annaaurora/pages.git pages
	# Preserve find-billy folder and .domains while copying build to pages
	mkdir backup
	cp -r pages/find-billy backup/find-billy
	cp pages/.domains backup/.domains
	rsync -r --delete --exclude-from=".rsyncignore" public/ pages
	rm -rf pages/find-billy
	rm -rf pages/.domains
	cp -r backup/find-billy pages/find-billy
	cp -r backup/.domains pages/.domains
	# Deploy with git
	cd pages
	git add -A
	git commit -m "Generate website - based on commit ${CI_COMMIT_SHA}"
	git push origin main

