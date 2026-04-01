#!/usr/local/bin/condarun updatescripts
# This code is used to download ECMWF Data Server data in parallel.
#
# This script should be called from ecmwf_get_data.py, otherwise it won't
# work if you don't have an ECMWF Key already.  Additionally, it won't create the
# proper subdirectories if they don't exist.  ecmwf_get_data will do this.
#
# Jeff Turmelle - Jan 2023
#
#
import multiprocessing as mp
import argparse
import logging
from multiprocessing_logging import install_mp_handler
import os
from ecmwfapi import ECMWFDataServer
import datetime
from ecmwf_get_data import available_models
import platform
import tempfile
from check_file_size import process_file_by_size

# Globals
filecount = []
debug = False
dryrun = False
myplatform = platform.system()
tmpdir = tempfile.gettempdir()

def my_logger(msg):
    if debug:
        if myplatform == "Darwin":
            print(msg)
        else:
            logging.info(msg)


def initializer():
    global ECMWF_server
    if not dryrun:
        ECMWF_server = ECMWFDataServer(log=my_logger)

def receive_file_task(task):
    """
    Single task to download a model file from ECMWF.
    """
    result = {"start_time": datetime.datetime.now()}

    real_file = task.pop("target", None)
    if real_file is None:
        logging.error("No target specified for task")
        return None

    task["target"] = f"{tmpdir}/{os.path.basename(real_file)}"
    logging.info(f"tempfile is {task['target']}")

    min_size = task.pop("min_size", None)
    actual_size = task.pop("actual_size", None)

    try:
        # if debugging is on then messages from this process will be logged to the logfile.
        if debug:
            logging.debug(f"Retrieving {task['target']}")
        ECMWF_server.retrieve(task)
    except Exception as e:
        logging.error(f"Process {task['target']} error {e}, continuing.")
        if os.path.exists(task['target']):
            if not dryrun:
                os.unlink(task["target"])
    else:
        logging.info(f"Process {real_file} finished")

    # Check if the retrieved file exists, and if the size is incorrect, remove it.
    logging.debug(f"Checking {task['target']} size")
    size = process_file_by_size(task['target'], min_size, actual_size, dryrun)
    logging.debug(f"File {task['target']} size is {size}")
    if size != 0:
        try:
            logging.debug(f"Moving {task['target']} to {real_file}")
            os.rename(task["target"], real_file)
        except Exception as exception:
            logging.error(f"Error renaming {task['target']} to {real_file}: {exception}")
            os.unlink(task["target"])

    result["target"] = real_file
    result["size"] = size
    result["end_time"] = datetime.datetime.now()

    return result

if __name__ == '__main__':
    ECMWF_server = None
    start = None
    end = None

    parser = argparse.ArgumentParser(description="use multiprocessing to download a set of models from ECMWF")
    parser.add_argument('--models', type=str, required=True, nargs="+",
                        help=f"select at least one model types: {available_models.keys()}")
    parser.add_argument('--logfile', type=str, required=True,
                        help="full path to log filename")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD")
    parser.add_argument('--debug', action="store_true",
                        help="Turn on ECMWFDataserver logging")
    parser.add_argument('--dryrun', action="store_true",
                        help="Don't actually download anything, just report")
    parser.add_argument('--max_downloads', type=int, default=1,
                        help="configure the maximum parallel downloads")
    parser.add_argument('--goback', type=int,
                        help="number of days to go back in time.  Default is defined by the model.")
    parser.add_argument('--days', type=str, nargs="+",
                        help='List of days to download:\nPossible values are:\n["odd", "even"]\n\
                        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]\n\
                        ["1", "2", "3", "4", "5", "6", "7" ... "31"] for the actual dates.')
    parser.add_argument('--tmpdir', type=str,
                        help=f"modify default TMPDIR from {tmpdir}")
    args = parser.parse_args()

    if args.debug:
        debug = args.debug
    if args.dryrun:
        dryrun = args.dryrun
    if args.tmpdir:
        tmpdir = args.tmpdir

    # initialize logging
    logging.basicConfig(filename=args.logfile, encoding="utf-8",
                        format="%(levelname)s: %(asctime)s - %(process)s - %(message)s",
                        level=logging.DEBUG)

    # Convert start and end into datetime objects
    if args.start is not None:
        try:
            start = datetime.datetime.strptime(args.start, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in start: {e}")
            parser.print_usage()
            exit(-1)

    if args.end is not None:
        try:
            end = datetime.datetime.strptime(args.end, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in end: {e}")
            parser.print_usage()
            exit(-1)

    all_tasks = []

    # Build the tasks for each model specified
    for model in args.models:
        model_class = available_models[model](start=start, end=end, weekdays=args.days, goback=args.goback)
        all_tasks.extend(model_class.get_tasks(prune=True, dryrun=dryrun))
        logging.info(f"downloading {len(all_tasks)} files for {model} from {start} to {end}")

    install_mp_handler()

    try:
        pool = mp.Pool(args.max_downloads, initializer=initializer)
        results = pool.map(receive_file_task, all_tasks)
        pool.close()
        pool.join()
    except Exception as e:
        logging.warning(f"Pool Error: {e}")
    else:
        logging.info(f"completed all {len(results)} tasks:")
        rows = []
        for r in results:
            delta = r['end_time'] - r['start_time']
            rows.append([delta.total_seconds(), r['size'], r['target']])
        col_widths = [max(len(str(row[i])) for row in [headers] + rows) for i in range(len(headers))]
        def print_row(row):
            print("  ".join(str(val).ljust(col_widths[i]) for i, val in enumerate(row)))
        headers = ["Time", "Size", "Target"]
        print_row(headers)
        print("  ".join("-" * w for w in col_widths))
        for row in rows:
            print_row(row)

    exit(0)
