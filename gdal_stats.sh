# for quickly outputting stats from gdalinfo for lists of files
# Files match Regular expression *SR.tif
for file in *SR.tif; do gdalinfo -stats $file | grep STATISTICS_MAXIMUM >> ../scene-lists/order-1-stats-maxt.txt; done

# sort by those download greater than 2 days ago
for file in `find . -maxdepth 1 -mtime +2 -name "*SR.tif"`; do gdalinfo -stats $file | grep STATISTICS_MAXIMUM; done