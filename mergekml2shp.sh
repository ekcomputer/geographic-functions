#!/bin/bash
# downloaded from https://www.northrivergeographic.com/ogr2ogr-merge-shapefiles

# first input is input Directory
# second input is output
# script_dir=$(pwd)
dir_in=$1
output_file=$2/combined.shp

cd $dir_in
echo dir: $(pwd)

for i in $(ls *.kmz)
do
      echo file: $i
      if [ -f “$output_file” ] # this part never executed...
      then
           echo “creating final/merge.shp”
           ogr2ogr -f "ESRI Shapefile" -update -append $output_file $i -nln merge
      else
           echo “merging……”
      ogr2ogr -nln `basename $i` -update -append -f "ESRI Shapefile"  $output_file $i
fi
done
