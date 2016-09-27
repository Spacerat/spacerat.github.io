#!/bin/sh
cp -r ./images/. ./thumbnails/
mogrify -resize 500x\> thumbnails/*.png
mogrify -resize 500x\> thumbnails/*.jpg
mogrify -resize 500x\> thumbnails/**/*.png
mogrify -resize 500x\> thumbnails/**/*.jpg


