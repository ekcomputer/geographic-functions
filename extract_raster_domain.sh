## Script to perform faulty ArcGIS Raster Domain Tool
# One input is file name
# output is shapefile of extent (not including nodata) in same directory with same filename[.shp]
# Final result uses seive filter and polygon simplification 1000 map units, but intermediate results without these modifications are in the 'out' folder.
# creates intermediate output directory "out" and output shape directory "shp"
# loosely based on https://gis.stackexchange.com/questions/120994/getting-a-raster-extent-excluding-nodata-area?noredirect=1&lq=1

## make output dirs
rm -r out # clear folder every time
mkdir -p out
mkdir -p shp

echo
echo
echo Input: $1
out_shp=`basename $1 .tif`.shp 
out_kml=`basename $1 .tif`.kml

## create datamask
echo Mask...
gdal_calc.py -A $1 --outfile out/mask.tif --NoDataValue 0 --calc="1*(A>0)" --overwrite > /dev/null

## sieve filter, threshold 100,000 px
echo Sieve...
gdal_sieve.py -st 100000 -4 out/mask.tif -nomask out/mask_sieve.tif 
gdal_edit.py -a_nodata 0 out/mask_sieve.tif 

## polygonize 
echo Polygonize...
gdal_polygonize.py -f "ESRI Shapefile" out/mask_sieve.tif  out/polygon.shp raster_domain DN

## and simplify
echo Simplify...
echo "(Final output: shp/$out_shp)"
ogr2ogr -simplify 1000 -overwrite shp/$out_shp out/polygon.shp # for testing: writes indiv file

## Append
# echo Append...
# ogr2ogr -append out/domains.shp shp/$out_shp

## remove inputs