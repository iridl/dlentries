import os
import logging


def process_file_by_size(filename, min_size, actual_size, dryrun=False, mylogger=None):
    # Check file size and remove if it doesn't match the expected size
    size = 0
    if os.path.exists(filename):
        size = os.path.getsize(filename)
        # if actual_size == 0, we don't know the exact size, so don't check it.
        if actual_size is not None and 0 < actual_size != size:
            # Give or take 5% of the actual size
            actual_size_offset = int(actual_size * .05)
            if actual_size-actual_size_offset < size < actual_size+actual_size_offset:
                return size
            else:
                if mylogger:
                    mylogger.error(f"{filename} is wrong size ({size}), should be {actual_size}")
                if not dryrun:
                    if mylogger:
                        mylogger.warning(f"removing wrong size file {filename}")
                    os.unlink(filename)
                return 0
        elif min_size is not None and size < min_size:
            if mylogger:
                mylogger.error(f"{filename} too small ({size}), should be a minimum of {min_size}")
            if not dryrun:
                if mylogger:
                    mylogger.warning(f"removing too small file {filename}")
                os.unlink(filename)
            return 0
    else:
        if mylogger:
            mylogger.error(f"{filename} does not exist.")
    return size
