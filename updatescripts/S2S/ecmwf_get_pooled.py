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
from typing import TypedDict
import os
import cdsapi
import datetime
import platform
import tempfile
import sys
from pathlib import Path

sys.path.append('..')
from get_cdsapi_credentials import get_cdsapi_credential

from ecmwf_get_data import available_models
from check_file_size import process_file_by_size

class DownloadResult(TypedDict):
    start_time: datetime.datetime
    end_time: datetime.datetime
    size: int
    target: Path
    error: str | None

def my_logger(msg):
    if debug:
        if myplatform == "Darwin":
            print(msg)
        else:
            logging.info(msg)

def initializer(t, log_level, credential):
    global CDS_Client
    global tmpdir
    tmpdir = t

    logging.getLogger("cdsapi").setLevel(logging.WARN)
    logging.getLogger("ecmwf_downloader").setLevel(log_level)

    CDS_Client = cdsapi.Client(url=credential['url'], key=credential['key'], quiet=True)

def receive_file_task(task):
    """
    Single task to download a model file from ECMWF.
    """
    result: DownloadResult = {
        "start_time": datetime.datetime.now(),
        "size": 0,
        "target": Path(task.pop("target", "")),
        "end_time": datetime.datetime.now(),
        "error": None,
    }

    app_logger = logging.getLogger("ecmwf_downloader")

    if result['target'] == Path(""):
        result["error"] = "No target specified for task"
    else:
        result['target'] = Path(result['target'])
        task['target'] = f"{tmpdir}/{result['target'].name}"

        min_size = task.pop("min_size", None)
        actual_size = task.pop("actual_size", None)

        try:
            # if debugging is on then messages from this process will be logged to the logfile.
            if debug:
                logging.debug(f"Retrieving {task['target']}")
            ECMWF_server.retrieve(task)
        except Exception as e:
            if os.path.exists(task['target']):
                try:
                    os.unlink(task['target'])
                except Exception as e:
                    logging.debug(f"Failure to remove failed download temp file: {task['target']}")
            result['error'] = f"ECMWF_Server.retrieve {task['target']} error {e}"
        else:
            # Check if the retrieved file exists, and if the size is incorrect, remove it.
            result['size'] = process_file_by_size(task['target'], min_size, actual_size)
            if result['size'] != 0:
                try:
                    result['target'].parent.mkdir(parents=True, exist_ok=True)
                    os.rename(task["target"], str(result['target']))
                except Exception as exception:
                    try:
                        os.unlink(task["target"])
                    except Exception as e:
                        logging.debug(f"Failure to remove downloaded temp file: {task['target']}")
                    result['error'] = f"Error moving {task['target']} to {str(result['target'])}: {exception}"
            else:
                result['error'] = f"File size is incorrect for {task['target']}"

    logging.debug(f"Completed {task['target']}, error: {result['error'] if result['error'] else 'None'}")
    result["end_time"] = datetime.datetime.now()
    return result

def safe_receive_file_task(task):
    # This prevents unknown exceptions in the receive_file_task from returning nothing.
    target = task.get("target")
    try:
        return receive_file_task(task)
    except Exception as e:
        return {
            'target': target,
            'error': f"Unhandled exception: {e}",
            'size': 0,
            'start_time': datetime.datetime.now(),
            'end_time': datetime.datetime.now()
        }


if __name__ == '__main__':
    CDS_Client = None
    start = None
    end = None
    credential = get_cdsapi_credential('ecmwf_get_pooled.py')
    if credential is None:
        raise ValueError("CDS API credentials not found for 'ecmwf_get_pooled.py'")

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
                        help="Turn on extra logging")
    parser.add_argument('--max_downloads', type=int, default=2,
                        help="configure the maximum parallel downloads")
    parser.add_argument('--goback', type=int,
                        help="number of days to go back in time.  Default is defined by the model.")
    parser.add_argument('--days', type=str, nargs="+",
                        help='List of days to download:\nPossible values are:\n["odd", "even"]\n\
                        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]\n\
                        ["1", "2", "3", "4", "5", "6", "7" ... "31"] for the actual dates.')
    parser.add_argument('--tmpdir', type=str,
                        help=f"modify default TMPDIR from default")
    args = parser.parse_args()

    if args.debug:
        debug = args.debug
    if args.tmpdir:
        tmpdir = args.tmpdir
    else:
        tmpdir = tempfile.gettempdir()

    # initialize logging
    app_logger = logging.getLogger("ecmwf_downloader")
    app_logger.setLevel(logging.DEBUG if args.debug else logging.INFO)

    handler = logging.FileHandler(args.logfile, encoding="utf-8")
    handler.setFormatter(logging.Formatter("%(levelname)s: %(asctime)s - %(process)s - %(message)s"))
    app_logger.addHandler(handler)

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
        all_tasks.extend(model_class.get_tasks(prune=True))
        logging.info(f"downloading {len(all_tasks)} files for {model} from {start} to {end}")

    install_mp_handler()

    results = []
    pool = None
    try:
        pool = mp.Pool(processes=args.max_downloads, initializer=initializer,
                       initargs=(tmpdir, logging.DEBUG if args.debug else logging.INFO, credential))
        results = pool.map(safe_receive_file_task, all_tasks)
        pool.close()
        pool.join()
    except Exception as e:
        logging.error(f"Pool Error: {e}")
        if pool:
            pool.terminate()
            pool.join()

    logging.info(f"completed {len(results)} tasks:")
    for r in results:
        delta = r['end_time'] - r['start_time']
        logging.info(f"Time: {delta.total_seconds()}, Size: {r['size']}, File: {r['target']}, Error: {r['error'] if r['error'] else 'None'}")

    exit(0)
