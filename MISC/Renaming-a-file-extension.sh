#!/bin/bash 
#
# Renaming a file extension
# Renaming all * png into jpg

for f in *.png;
do 
    mv -- "$f" "${f%.png}.jpg
done
