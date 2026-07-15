#!/usr/local/bin/condarun updatescripts3
# This code is used to download ECMWF Data Server data in parallel.
#
# This script should be called from ecmwf_get_data.py, otherwise it won't
# work if you don't have an ECMWF Key already.  Additionally, it won't create the
# proper subdirectories if they don't exist.  ecmwf_get_data will do this.
#
# Jeff Turmelle - Jan 2023
#
import multiprocessing as mp
import logging
import logging.handlers
import argparse
from typing import TypedDict
import os
import cdsapi
import datetime
import tempfile
import sys
from ecmwf_get_data import available_models
from check_file_size import process_file_by_size
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))
from get_cdsapi_credentials import get_cdsapi_credential

CDS_Client = None

class DownloadResult(TypedDict):
    start_time: datetime.datetime
    end_time: datetime.datetime
    size: int
    target: str
    error: str | None


def initializer(t, debug, credential, log_queue):
    global CDS_Client
    global tmpdir
    tmpdir = t

    # Wire this worker's logger to send records to the main process queue.
    # On platforms using fork, the worker inherits the main process's already-attached
    # QueueHandler via copy-on-write, so clear it first or every record gets logged twice.
    queue_handler = logging.handlers.QueueHandler(log_queue)
    app_logger = logging.getLogger("ecmwf_downloader")
    app_logger.handlers.clear()
    app_logger.addHandler(queue_handler)
    app_logger.setLevel(logging.DEBUG if debug else logging.INFO)

    # app_logger.info(f"Initializing cdsapi with {credential['url']} and {credential['key']}")

    try:
        CDS_Client = cdsapi.Client(url=credential['url'], key=credential['key'],
                                   quiet=(not debug))
    except Exception as e:
        app_logger.error(f"Failed to initialize cdsapi: {e}")
        raise
    else:
        app_logger.info("cdsapi initialized")


def receive_file_task(task):
    """
    Single task to download a model file from ECMWF.
    """
    global CDS_Client
    result: DownloadResult = {
        "start_time": datetime.datetime.now(),
        "size": 0,
        "target": task.pop("target"),
        "end_time": datetime.datetime.now(),
        "error": None,
    }
    app_logger = logging.getLogger("ecmwf_downloader")

    dataset = task.pop("dataset")
    if result['target'] is None or dataset is None:
        result["error"] = "Missing target or dataset for task"
    else:
        tmpfile = f"{tmpdir}/{os.path.basename(result['target'])}"

        min_size = task.pop("min_size", None)
        actual_size = task.pop("actual_size", None)

        try:
            app_logger.info(f"Retrieving {result['target']}")
            CDS_Client.retrieve(dataset, task, tmpfile)
        except Exception as e:
            result['error'] = f"ECMWF_Server.retrieve {tmpfile} error {e}"
            if os.path.exists(tmpfile):
                try:
                    os.unlink(tmpfile)
                except Exception as e:
                    result['error'] += f"\nFailure to remove failed download temp file: {tmpfile}: {e}"
            raise
        else:
            result['size'] = process_file_by_size(tmpfile, min_size, actual_size, dryrun=False, mylogger=app_logger)
            if result['size'] != 0:
                try:
                    os.makedirs(os.path.dirname(result['target']), mode=0o775, exist_ok=True)
                    os.rename(tmpfile, result['target'])
                except Exception as exception:
                    result['error'] = f"Error moving {tmpfile} to {result['target']}: {exception}"
            else:
                result['error'] = f"File size is incorrect for {result['target']}"

    result["end_time"] = datetime.datetime.now()
    delta = result["end_time"] - result["start_time"]
    app_logger.info(f"Completed {result['target']}, Time: {delta.total_seconds()}, Size: {result['size']}, "
                     f"error: {result['error'] if result['error'] else 'None'}")
    return result


if __name__ == '__main__':
    CDS_Client = None
    start = None
    end = None
    debug = False

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
    parser.add_argument('--key', type=str,
                        help=f"use the key as the cdsapi key")

    args = parser.parse_args()

    if args.debug:
        debug = True
    if args.tmpdir:
        tmpdir = args.tmpdir
    else:
        tmpdir = tempfile.gettempdir()

    if args.key:
        credential = {'url': 'https://ecds.ecmwf.int/api', 'key': args.key}
    else:
        credential = get_cdsapi_credential('S2S/ecmwf_get_pooled.py')

    if credential is None:
        raise ValueError("CDS API credentials not found for 'ecmwf_get_pooled.py'")

    # Force 'spawn' regardless of platform default so workers never inherit the main
    # process's logging handlers or open sockets via fork. The queue must be created
    # from the same context as the Pool below, since Queue binds its internal locks
    # to whichever context constructed it.
    mp_ctx = mp.get_context("spawn")

    # Set up the logging queue and listener in the main process
    log_queue = mp_ctx.Queue()

    handler = logging.FileHandler(args.logfile, encoding="utf-8")
    handler.setFormatter(logging.Formatter("%(levelname)s: %(asctime)s - %(process)s - %(message)s"))

    listener = logging.handlers.QueueListener(log_queue, handler)
    listener.start()

    # Set up the main process logger to also use the queue
    app_logger = logging.getLogger("ecmwf_downloader")
    app_logger.setLevel(logging.DEBUG if debug else logging.INFO)
    app_logger.addHandler(logging.handlers.QueueHandler(log_queue))

    # Convert start and end into datetime objects
    if args.start is not None:
        try:
            start = datetime.datetime.strptime(args.start, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in start: {e}")
            parser.print_usage()
            listener.stop()
            exit(-1)

    if args.end is not None:
        try:
            end = datetime.datetime.strptime(args.end, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in end: {e}")
            parser.print_usage()
            listener.stop()
            exit(-1)

    all_tasks = []

    # Build the tasks for each model specified
    for model in args.models:
        model_class = available_models[model](start=start, end=end, weekdays=args.days, goback=args.goback)
        all_tasks = model_class.get_tasks(prune=True)
        app_logger.info(f"downloading {len(all_tasks)} files for {model} from {start} to {end}")

        results = []
        pool = None
        try:
            pool = mp_ctx.Pool(processes=args.max_downloads, initializer=initializer,
                               initargs=(tmpdir, debug, credential, log_queue))
            results = pool.map(receive_file_task, all_tasks)
            pool.close()
            pool.join()
        except Exception as e:
            app_logger.error(f"Pool Error: {e}")
            if pool:
                pool.terminate()
                pool.join()

        app_logger.info(f"completed {len(results)} tasks")

    listener.stop()

    exit(0)
