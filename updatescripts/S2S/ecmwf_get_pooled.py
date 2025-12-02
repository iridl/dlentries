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

# Globals
filecount = []
debug = False
dryrun = False
myplatform = platform.system()


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
    size = 0

    # if min_size exists in task, set the minimum size, or default to 1KB.
    min_size = task.pop("min_size", 1000)

    # Download the target file, unless it already exists.
    if os.path.exists(task["target"]):
        size = os.path.getsize(task["target"])
        logging.warning(f"checking {task['target']} size: {size} bytes, exists")
        if size < min_size:
            if not dryrun:
                os.unlink(task["target"])
            logging.warning(f"target too small, removing and redownloading {task['target']}")

    if size < min_size:
        logging.info(f"Process {task['target']} started")
        try:
            if dryrun:
                print(task)
            else:
                ECMWF_server.retrieve(task)
        except Exception as e:
            logging.error(f"Process {task['target']} error {e}, continuing.")
        else:
            logging.info(f"Process {task['target']} finished")

        if os.path.exists(task['target']):
            size = os.path.getsize(task['target'])
            logging.info(f"checking {task['target']} size: {size} bytes")
            if size == 0:
                logging.info(f"removing zero-size {task['target']}")
                if not dryrun:
                    os.unlink(task["target"])
            elif size < min_size:
                logging.info(f"removing under-sized {task['target']}")
                if not dryrun:
                    os.unlink(task["target"])
            else:
                filecount.append({"filename": task["target"], "size": size})
        else:
            filecount.append({"filename": task["target"], "size": -1})

    return task['target']


if __name__ == '__main__':
    ECMWF_server = None

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
    parser.add_argument('--max_downloads', type=int,
                        help="configure the maximum parallel downloads")
    args = parser.parse_args()

    debug = args.debug
    dryrun = args.dryrun
    max_downloads = args.max_downloads

    # Convert start and end into datetime objects
    start = None
    end = None
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
        model_start = start
        # model_class is the specific class, i.e. KMAModel, ECMFModel, ...
        if model_start is not None and end is not None and end >= model_start:
            while model_start <= end:
                model_class = available_models[model](start=model_start)
                model_class.make_target_folders()
                all_tasks.extend(model_class.get_tasks())
                model_start = model_start + datetime.timedelta(days=1)
        else:
            model_class = available_models[model](start=model_start)
            model_class.make_target_folders()
            all_tasks.extend(model_class.get_tasks())

    logging.basicConfig(filename=args.logfile, encoding="utf-8",
                        format="%(levelname)s: %(asctime)s - %(process)s - %(message)s",
                        level=logging.DEBUG)
    install_mp_handler()

    try:
        pool = mp.Pool(max_downloads, initializer=initializer)
        logging.info(f"submitting {len(all_tasks)} tasks to the Pool")
        pool.map(receive_file_task, all_tasks)

        pool.close()
        pool.join()
    except Exception as e:
        logging.info(f"Pool Error: {e}")
    else:
        logging.debug(f"completed all tasks: ")
        for file in filecount:
            if "filename" in file:
                logging.debug(f"file: {file['file']} | size: {file['size']}")

    exit(0)
