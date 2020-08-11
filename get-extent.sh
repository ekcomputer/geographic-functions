#!/bin/bash

# MODIFIED FROM https://github.com/clhenrick/shell_scripts/blob/master/get-extent.sh

RASTER=$1
# BASE=`basename $SHPFILE .shp`
MINS=`gdalinfo $RASTER | grep "Lower Left" | sed 's/Lower Left  //g' | sed 's/(//g' | sed 's/)//g' | sed 's/,//g' | tr -s ' ' | cut -d' ' -f "1 2"`
MAXS=`gdalinfo $RASTER | grep "Upper Right" | sed 's/Upper Right //g' | sed 's/(//g' | sed 's/)//g' | sed 's/,//g' | tr -s ' ' | cut -d' ' -f "1 2"`

# NOTE: can change order of commands, but output spacing is diff:
# gdalinfo padelE_36000_18047_000_180821_L090HHHH_CX_01.grd | grep "Upper Right" | sed 's/Upper Right//g' | tr -s ' '| sed 's/Upper Right //g' | sed 's/(//g' | sed 's/)//g' | sed 's/,//g' | cut -d' ' -f "1 2"

EXTENT=`echo $MINS $MAXS`
echo $EXTENT