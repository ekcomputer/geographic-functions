## Script to run the raster domain extraction

## export gdal cache
export GDAL_CACHEMAX=6000

## Add paths to use parallel_cat_run.sh
PATH=$PATH:/mnt/d/Dropbox/Matlab/ABoVE/UAVSAR/polsar_pro

## I/O
inputs=/mnt/f/PAD2019/classification_training/PixelClassifier/DAAC-footprints/files.txt
# inputs=/mnt/f/PAD2019/classification_training/PixelClassifier/DAAC-footprints/test_files.txt # uncomment for testing

## cd (this changes output folder)
cd "/mnt/d/GoogleDrive/ABoVE top level folder/Kyzivat_ORNL_DAAC_2020/lake-wetland-maps/13-classes"

## function call
bash serial_cat_run.sh extract_raster_domain.sh $inputs # serial, uncomment for testing
# bash parallel_cat_run.sh extract_raster_domain.sh $inputs 4 #uncomment for parallel