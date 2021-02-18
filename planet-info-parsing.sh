## Script to print upper left coordinates for each image in the list of planet images. 
## Arguments:   1 Input CSV or TXT, with a scene id on each line
##              2 Output CSV file with coordinates (long, lat)

## Requirements: 
#       Porder (Python package for working with planet API)

# for testing, use arguments: planet-gan-list-2-in-progress.csv planet-gan-list-2-in-progress-coords.csv
#
#
# Example: planet-info-parsing.sh planet-gan-list-2-in-progress.csv output-test.csv


for line in `cat $1`; do planet data search --item-type PSScene4Band --asset-type analytic_sr --string-in id $line | jq '. | .features | .[0] | .geometry | .coordinates | .[0] | .[0]' -c | cut -b 2- | rev | cut -c 2- | rev >> $2; done