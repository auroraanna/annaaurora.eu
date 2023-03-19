#!/bin/sh
set -eu

start_dir=$PWD
escaped_start_dir=$(printf $start_dir | sed -r 's/\//\\\//g')
cd public/art
for file in $(find -regex ".+\.html"); do
	basename=$(basename $file)
	dir=${file%$basename}
	cd $dir

	grep -Eo 'src(set)?="[^"]+"' $basename | while IFS= read -r line; do
		url=$(printf $line | grep -Eo '".+"' | grep -Eo '[^"].+[^"]')
		echo url: $url
		escaped_url=$(printf $url | sed -r 's/\//\\\//g')

		xxhsum_url=$(printf $url | sed -r "s/^\//$escaped_start_dir\/public\//g")
		checksum=$(xxhsum $xxhsum_url | cut -d " " -f 1)
		echo checksum: $checksum

		sed -i "s/\($escaped_url\)/\1?h=$checksum/g" $basename
	done
	cd $start_dir/public/art
done
cd $start_dir
