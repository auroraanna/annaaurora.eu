#!/usr/bin/env just --justfile
NAME:='papojari.codeberg.page'
BUILD_DIR:='public'
ALPINE_DEPS:='git just zola imagemagick rsync'
NIXPKGS_DEPS:='git just zola imagemagick rsync'

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
	set -euxo pipefail
	# Let Zola compile the website
	zola build
	# Copy license file into top directory
	cp content/License.md public/LICENSE.md
	# Art section generate lossy images
	for art_name in $(ls -1 public/art | awk '! /.html/'); do
		convert {{BUILD_DIR}}/art/$art_name/lossless.webp -quality 90% {{BUILD_DIR}}/art/$art_name/lossy.webp
	done

deploy: build
	#!/bin/sh
	set -euxo pipefail
	# Configure git identity
	git config --global user.email "mail@ci.codeberg.org"
	git config --global user.name "Codeberg CI"
	# Clone deploy repository
	git clone https://"$CODEBERG_ACCESS_TOKEN"@codeberg.org/papojari/pages.git pages
	# Preserve find-billy folder while copying build to pages
	cp -r pages/find-billy find-billy-backup
	rsync -r --delete --exclude-from=".rsyncignore" public/ pages
	rm -rf pages/find-billy
	cp -r find-billy-backup pages/find-billy
	# Deploy with git
	cd pages
	git add -A
	git commit -m "Generate website - based on commit ${CI_COMMIT_SHA}"
	git push origin main

