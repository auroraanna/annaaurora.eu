#!/bin/sh
set -eu

# Put Lettuce Synthetic composited images into place.
start_dir=$PWD
cd content/art/Lettuce\ Synthetic/
mkdir -v images
pwd
cp -v "$1"/composited/* images/
# Create Lettuce Synthetic HTML and lossy images
for variant in images/*; do
	basename=$(basename $variant)
	echo basename: $basename
	index=${basename%.*}
	echo index: $index
	suffix=${basename#$index.}
	echo suffix: $suffix
	mkdir -v images/"$index"
	file=images/"$index"/lossless."$suffix"
	mv -v images/"$basename" "$file"

	title=$(exiftool -Title -b "$file")
	alt=$(exiftool -Description -b "$file")

	cat <<- EOF >> index.md
	<figure>
		<picture>
			<source srcset="images/$index/lossy.avif" type="image/avif"/>
			<source srcset="images/$index/lossy.webp" type="image/webp"/>
			<img src="images/$index/lossy.jpeg" alt="$alt">
		</picture>
		<figcaption>$title</figcaption>
		<a href="images/$index/lossless.$suffix">
			Lossless image
		</a>
	</figure>
	EOF
done
cd $start_dir
