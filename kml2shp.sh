#!/bin/bash
# inputs: dir in, dir out
# downloaded from stack exchange - modified, then broken, then fixed.
# TODO: allow for if statement to load from file, not dir
# Purpose: Converts KM L files in a directory to SHP

# startdir="$(pwd)"
# cd $1

# prelim
echo "start dir: " $1
echo "out dir: " $2
# path_in="$($1/*.shp)"

# for FILE in $(ls "$1"/*.shp) # cycles through all files in directory (case-sensitive!) # note "" quotes in case spaces in path name
list="$(echo "$1"/*.kml)" # printf %q
for FILE in "$list"
do
    echo "converting file: $FILE..."
    FILENEW=`basename $FILE | sed "s/.kml//g"` # replaces old filename
    # FILENEW=`dirname $FILE/basename $FILE .kml & echo .shp`
    # echo $FILE
    # echo $FILENEW
    ogr2ogr \
    -f "ESRI Shapefile" \
    "$2"/"$FILENEW" "$FILE"
done
exit
# cd $startdir
