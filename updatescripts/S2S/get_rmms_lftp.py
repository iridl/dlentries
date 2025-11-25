#!/usr/local/bin/condarun updatescripts
#
# Use LFTP to mirror the remote location to the local location
#
# 9/1/22    Jeff Turmelle
#           modified from Jing Yuan's scripts to use lftp mirror
#           also see S2S_config.py
#           depends on ~/.netrc for the lftp login
#
import os.path
import subprocess

from datetime import datetime, timedelta
import argparse
from S2S_config import S2S_ecmwf_toplevel_directory, S2S_FTP_folders1, lftp_binary, \
    S2S_ftp_server1, S2S_logs_directory, S2S_AVAILABLE_MODELS

debug = False
verbose = False


def get_locations(folder, year, month, model):
    """
    Get the locations from where to get the remote file and where to put the local file
    :param folder: str: dictionary structure from config.py
    :param year: year to sync (0 means sync all years)
    :param month: month to sync (0 means sync all the months)
    :param model: dictionary of model we're syncing; i.e. from config.py {'remote': 'eccc/reforecasts',
                                                                          'local': 'ECCC/REF'},
    :return: full pathnames of remote_folder and local_folder to mirror

    Remote Folder structure looks like this:
    toplevel/
       modelname/
           real-time/
           reforecasts/
               years/ [4-digit]
                   /months [2-digit]

    Local folder structure looks like this
    toplevel/
        MODELNAME/
            REF/
            REL/
                RMMS/
                SSW/
                    /years/ [4-digit]
                    /months [2-digit]

    """
    local_toplevel = S2S_ecmwf_toplevel_directory()
    if year == 0:
        remote_dir = f"{folder['toplevel']}/{model['remote']}"
        local_dir = f"{local_toplevel}/{model['local']}"
    elif month == 0:
        remote_dir = f"{folder['toplevel']}/{model['remote']}/{year}"
        local_dir = f"{local_toplevel}/{model['local']}/{year}"
    else:
        remote_dir = f"{folder['toplevel']}/{model['remote']}/{year}/{month:02d}"
        local_dir = f"{local_toplevel}/{model['local']}/{year}/{month:02d}"

    return remote_dir, local_dir


def run_lftp(ftp_server, remote, local, lo_file=None, timeout=3600):
    """
    Run the lftp mirror process as a python subprocess
    :param ftp_server: parameters used in the FTP Server
        Dictionary: {'host': 'ftp-hostname', 'options': [list of ftp option commands]}
    :param remote: full path of remote ftp folder to mirror
    :param local: full path of local ftp folder to mirror
    :param lo_file: base filename used for logging and locking. Will crash if not set.
    :param timeout: number of seconds to run subprocess before exiting
    :return: output of command.
    """
    return_string = ""
    p = None
    try:
        options = ""
        dryrun = ""
        verbose_string = ""

        if debug:
            dryrun = '--dry-run'
        if verbose:
            verbose_string = "--verbose=3"
        logfile = f'{S2S_logs_directory()}/{lo_file}.log'

        lftp_mirror_command = f'mirror {verbose_string} {dryrun} --no-empty-dirs {remote} {local}'

        for option in ftp_server['options']:
            # get options from S2S_config.py
            options += option + '; '
        if not debug:
            # don't log if we're debugging
            options += f'set xfer:log-file \"{logfile}\"; '

        lftp_args = [lftp_binary, "-e", f"{options} {lftp_mirror_command}; bye", ftp_server['host']]

        lftp_command = f"{lftp_binary} -e \"{options} {lftp_mirror_command}; bye\" {ftp_server['host']}"

        if debug or verbose:
            print(lftp_command)

        p = subprocess.run(lftp_args, capture_output=True, text=True, timeout=timeout)
        p.check_returncode()

        if debug or verbose:
            return_string = f'Output of {lftp_command}\n\trun at {datetime.now().ctime()}:\n\
            stdout: {p.stdout}\nstderr: {p.stderr}'
        else:
            if os.path.exists(logfile):
                with open(logfile, 'r') as f:
                    data = f.read()
                    return_string = data

    except (ValueError, subprocess.CalledProcessError) as e:
        if p:
            return_string = p.stderr
            if debug:
                print(e)

    return return_string



if __name__ == '__main__':
    """
        --year year-to-sync
            default is the previous month's year
        --month month-to-sync
            default is the previous month
            0-12 where 0 is to sync all the months
    """
    # set up the argument parser
    parser = argparse.ArgumentParser()
    now = datetime.now()

    # The default_month and year is the previous month
    last_month = now - timedelta(now.day+1)
    default_year = last_month.year
    default_month = last_month.month


    parser.add_argument('-y', '--year', type=int, default=default_year,
                        help='specific year [YYYY] to mirror, default is current; use 0 to mirror every year')
    parser.add_argument('-m', '--month', type=int, default=default_month,
                        help='specific month [1-12] to mirror, default is previous month; use 0 to mirror the entire year')
    parser.add_argument('-p', '--previous', type=int,
                        help='number of previous months to download. Overwrites the year and month flags when used.')
    parser.add_argument('-d', '--debug', action='store_true',
                        help='dry-run: only reports, doesnt copy; and provides additional print statements')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='provides additional output showing what\'s going on at each stage.')
    parser.add_argument('--timeout', type=int, default=3600,
                        help='set a timeout in seconds for the ftp command, defaults to 1 hour')
    parser.add_argument('--reforecast_only', action='store_true', help='only process reforecasts')
    parser.add_argument('--realtime_only', action='store_true', help='only process realtime forecasts')
    parser.add_argument('--models', type=str, required=False, nargs='+',
                        help=f'only process the given models: {",".join(S2S_AVAILABLE_MODELS)}')

    args = parser.parse_args()

    debug = args.debug
    verbose = args.verbose
    previous = None
    reforecast_only = args.reforecast_only
    realtime_only = args.realtime_only
    only_models = S2S_AVAILABLE_MODELS
    year = int(args.year)
    month = int(args.month)

    if args.previous:
        previous = int(args.previous)

    if args.models:
        only_models = args.models
        for m in only_models:
            if m not in S2S_AVAILABLE_MODELS:
                print(f'model {m} is not a valid model')
                exit()

    output_log = []

    def get_ftp_data(f, y, m, current_model, ftp_timeout):
        remote, local = get_locations(f, y, m, current_model)
        lo_file = local.replace('/', '_')  # use this as a base for a log/lock file
        output_log.append(f"Syncing model from {remote} to {local} for {y}/{m:02d}")
        try:
            o = run_lftp(ftp_server=S2S_ftp_server1, remote=remote, local=local, lo_file=lo_file,
                         timeout=int(ftp_timeout))
            output_log.append(o)
        except (ValueError, subprocess.CalledProcessError) as e:
            output_log.append(e)

    for folder in S2S_FTP_folders1:
        for model_type in folder['model_types']:

            if reforecast_only and model_type['name'] != "reforecasts":
                continue
            if realtime_only and model_type['name'] != 'realtime':
                continue

            for model in model_type['models']:
                for m in only_models:
                    if m in model['remote']:
                        if previous:
                            previous_date = now
                            for x in range(0, previous, 1):
                                # get the previous month
                                previous_date = previous_date - timedelta(days=previous_date.day)
                                get_ftp_data(folder, previous_date.year, previous_date.month, model, args.timeout)
                        else:
                            get_ftp_data(folder, year, month, model, args.timeout)

    print("Output of RMMS/SSW Mirror from acquisition.ecmwf.int", "\n".join(output_log))
    if debug:
        print("\n".join(output_log))
