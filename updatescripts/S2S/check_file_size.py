import os

def process_file_by_size(filename, min_size, actual_size, dryrun=False, logging=None):
    # Check file size and remove if it doesn't match the expected size
    size = 0
    if os.path.exists(filename):
        size = os.path.getsize(filename)
        # if actual_size == 0, we don't know the exact size, so don't check it.
        if actual_size is not None and 0 < actual_size != size:
            if logging is not None:
                logging.warning(f"target is wrong size ({size}), should be {actual_size}; removing {filename}")
            if not dryrun:
                os.unlink(filename)
            return 0
        elif min_size is not None and size < min_size:
            if logging is not None:
                logging.warning(f"target too small ({size}), should be a minimum of {min_size}; removing {filename}")
            if not dryrun:
                os.unlink(filename)
            return 0
    return size

