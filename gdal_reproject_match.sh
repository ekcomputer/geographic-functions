#!/bin/bash
# MODIFIED FROM https://github.com/nemac/sample_docker_gdalconvert/blob/b8b87510766767bdd09df51421aa45aef3652f1b/scripts/convert_imagery.sh

# EXAMPLE: gdal_reproject_match.sh /att/nobackup/ekyzivat/landcover/ABoVE_LandCover.vrt /att/nobackup/ekyzivat/tmp/rtc/padelE_36000_18047_000_180821_L090_CX_01/raw/landcover_auto.tif  /att/nobackup/ekyzivat/tmp/rtc/padelE_36000_18047_000_180821_L090_CX_01/raw/padelE_36000_18047_000_180821_L090HHHH_CX_01.grd

# TODO error handling if not enough args
scripts_location='/usr/local/scripts'
data_location='/usr/local/data'
INPUT=$1 # input raster
OUTPUT=$2 # output raster
MATCH=$3 # output will have same proj and extent as $MATCH


#######################
#convert
#######################

#get a clip extent of an existing dataset you want to base projection and grid on (suburban image)
# gdaltindex $data_location/clipper.shp $data_location/Suburban200m_270m.tif
EXTENT=`get-extent.sh $MATCH`
DIMS=`get-dims.sh $MATCH`
echo Matching extent: $EXTENT
echo Matching raster dimensions: $DIMS
#Get the projection file for the suburban image
gdalsrsinfo -o wkt  $MATCH > $MATCH.proj.tmp

# In following change in the source and output to match you image

# gdal warp the image to the new projection, clip it., resample it using an average of the pixels to a 270m grid (this may take awhile)
#gdalwarp -tr 270 270  -cutline clipper.shp -crop_to_cutline -r average -srcnodata 255 -dstnodata 255 -overwrite source.tif output_270_gdal.tif  -t_srs wkt.txt

#example road_noise
gdalwarp -t_srs $MATCH.proj.tmp -te_srs $MATCH.proj.tmp -te $EXTENT -ts $DIMS $INPUT $OUTPUT

# then generate statistics
#gdalinfo -mm -stats -hist -checksum  output_gdal.tif
# gdalinfo -mm -stats -hist -checksum  $data_location/road_noise_270_gdal.tif

# For some datasets due to the pixel size we may have to do another warp to get the data to line to the clip box. This “might” cause the data to shift.  This happens when the clip shape and the rast pixels intersect each other.  The first warp uses the full pixel that intersects the clip shape.   The second warp moves the output to the corner - “shifting” the data.  I want to make sure the data is not truly shifted and instead is rea calculating values based on average. We may have to make more pixels and do in multiples of 270 maybe try 90 first and see if the shift is less.
#
# do this after all process to get the raster to align to the  grid
# gdalwarp  -cutline clipper.shp -crop_to_cutline -overwrite  input_270_gdal.tif output_270_gdal_cut.tif

rm $MATCH.proj.tmp # remove temp file