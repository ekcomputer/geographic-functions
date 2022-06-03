''' From James Ford on the Spatial Community Slack'''
import sys

from multiprocessing import Pool, cpu_count
from pathlib import Path

from ecw2tiff import ecw2tiff

################################################################################


def get_input_files(top_dir, ext=".ecw", recursive=True):
    """Get input files"""

    # Get a list of Path objects of filepaths matching the input glob pattern
    if recursive:
        tifs = list(Path(top_dir).rglob(f"*{ext}"))
    else:
        tifs = list(Path(top_dir).glob(f"*{ext}"))

    return tifs


################################################################################


def create_args(file_list, output_folder):
    """Create list of args to pass to ecw2tiff"""

    output_folder_path = Path(output_folder)

    # Func to convert input filepath to output filepath
    output_file = lambda x: output_folder_path.joinpath(f"{x.stem}.tiff")

    # Create list of (input_filepath, output_filepath) tuples
    args = list(zip(file_list, map(output_file, file_list),))

    return args


################################################################################


def multiprocess_ecw2tiff(ecw2tiff_args, threads=7):
    """Using multiprocessing.Pool to process ecw2tiff func in parallel."""

    # Validate thread arg
    if threads > cpu_count():
        threads = cpu_count()

    pool = Pool(processes=threads)

    results = {}

    # Dictionary of arg tuples
    args = dict(enumerate(ecw2tiff_args))

    # Map args to Pool processes
    processes = {k: pool.apply_async(ecw2tiff, args=v) for k, v in args.items()}

    # Execute processes, progressbar, return results
    for i, item in enumerate(processes.items()):
        i += 1
        k, v = item
        results[k] = v.get()
        sys.stdout.write("\rdone {0:.2%}".format(i / len(processes.keys())))

    print("")

    return results


################################################################################


def main():

    # Your code here
    pass


################################################################################

if __name__ == "__main__":
    main()
