''' From James Ford on the Spatial Community Slack'''

import os

from osgeo import gdal
from pathlib import Path

gdal.UseExceptions()

################################################################################


def ecw2tiff(ecw: os.pathlike, tiff: os.pathlike) -> bool:
    """Translate an ECW file to a GeoTiff using preset parameters."""

    # gdal.Translate doesn't like Path objects
    if type(ecw) == Path:
        ecw = ecw.as_posix()

    if type(tiff) == Path:
        tiff = tiff.as_posix()
	
    # Validate input file exists
    if not os.path.exists(ecw):
        raise ValueError(f"ECW {ecw} cannot be found or does not exist.")

    # Validate output file does not exist
    if os.path.exists(tiff):
        raise ValueError(
            f"GeoTIFF {tiff} already exists, please delete before running ecw2tiff."
        )

    # Gdal confinguration options
    config_ops = {
        "GDAL_CACHEMAX": "512",
    }

    # Arguments to pass to -co flag in gdal_translate
    creation_options = [
        "TILED=YES",
        "PREDICTOR=2",
        "BIGTIFF=TRUE",
        "COMPRESS=DELFATE",
    ]

    # Set configuration options
    for k, v in config_ops.items():
        gdal.SetConfigOption(k, v)

    # Translate files
    result = gdal.Translate(tiff, ecw)

    # Return translate result
    return result


################################################################################


def main():
    pass


################################################################################

if __name__ == "__main__":
    main()
