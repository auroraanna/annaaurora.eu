#!/bin/sh
set -eu

# Art section generate lossy images and generate audio
start_dir=$PWD
cd public/art
for file in $(find . -regex ".+\..+" | awk '! /.html/'); do
	file_without_suffix=${file%.*}
	suffix=${file#$file_without_suffix.}
	file_name=$(basename $file)
	dir=$(printf ${file%$file_name} | head -c -1)
	art_name=$(echo ${dir#./} | awk -F '/' '{print $1}')
	echo art_name: $art_name
	if [ $suffix = "webp" ] || [ $suffix = "png" ]; then
		quality="80%"
		for format in avif webp jpeg; do
			if [ $art_name != "lettuce-synthetic" ]; then
				convert -verbose "$file" -quality $quality "$dir"/lossy.$format
			else
				convert -verbose "$file" -quality 60% -resize 50% "$dir"/lossy.$format
			fi
		done
	elif [ $suffix = "mmpz" ]; then
		if [ $art_name != "lyrically-vantage" ]; then
			lmms render "$dir"/source.mmpz --allowroot -i sincbest -a --format wav --loop --output "$dir"/lossless.wav
			ffmpeg -v 1 -i "$dir"/lossless.wav "$dir"/lossless.flac
			rm -f "$dir"/lossless.wav
		fi
		ffmpeg -v 1 -i "$dir"/lossless.flac -b:a 160k "$dir"/lossy.opus
	fi
done
cd $start_dir
