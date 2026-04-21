# Base Class for creating download models.  Some stuff is the same everywhere...
#
# Jeff Turmelle - Jan 2023
# Reconfiguration of Jing Yuan's work to make it more modular.
#

from S2S_config import S2S_ecmwf_toplevel_directory, DIR_MODE
import datetime
import logging
import os
from check_file_size import process_file_by_size

class ECMWFModelTaskBase:
    """
    Base model for building tasks to download data from the ECMWF Data Server
    https://ecds.ecmwf.int/datasets/s2s-forecasts?tab=overview
    """

    # Default number of days to go back in time to download data
    goback = 60
    s2s_class = "s2s"
    dataset = "s2s-forecasts"

    def __init__(self, start=None, end=None, weekdays=None, goback=goback, data_access_delay=0):
        """
        :param start: start day to get data
        :param end: end day to get data
        :param weekdays: a list of weekdays to download data for.
            Possible values are:
                ["odd", "even"]
                ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                ["1", "2", "3", "4", "5", "6", "7" ... "31"] for the actual dates
        :param goback: number of days to go past the end date.
        """
        if start is None and end is not None:
            raise ValueError("If end is specified, start must also be specified")
        if weekdays is None:
            raise ValueError("Weekdays are required")

        self.first_date = start
        self.end = end
        self.weekdays = weekdays
        self.goback = goback if goback is not None else ECMWFModelTaskBase.goback
        self.data_access_delay = data_access_delay

        # Where is the S2S Toplevel
        self.S2S_toplevel = S2S_ecmwf_toplevel_directory()
        self.today = datetime.datetime.now()

        # Actual dates we'll be downloading data for
        self.dates = self.get_date_list()

        # all_models is to be defined in the subclass
        self.all_models = {}

    def check_date(self, d):
        d_string = d.strftime("%a")

        # make sure we're not trying to get data beyond its availability.
        if self.data_access_delay is not None:
            if d >= self.today - datetime.timedelta(days=self.data_access_delay):
                return False

        if self.weekdays is None:
            return True

        # if day is in the weekdays list return True, else return False
        if "odd" in self.weekdays and d.day % 2 == 1:
            return True
        elif "even" in self.weekdays and d.day % 2 == 0:
            return True
        elif self.weekdays[0].isnumeric():
            if f"{d.day}" in self.weekdays:
                return True
            else:
                return False
        elif d_string in self.weekdays:
            return True
        else:
            return False

    def get_date_list(self):
        date_list = []

        # Compute a list of dates to download data for.
        if self.weekdays is None:
            raise ValueError("Weekdays are required")
        if self.goback < 1:
            raise ValueError("goback must be >= 1")

        if self.first_date is None:
            # in this case, start is today-goback to start-access_delay
            day = self.today - datetime.timedelta(days=self.goback+self.data_access_delay)
            end = self.today - datetime.timedelta(days=self.data_access_delay)

            while day <= end:
                if self.check_date(day):
                    date_list.append(day)
                day = day + datetime.timedelta(days=1)
        elif self.end is not None:
            # this routine will update self.end to the actual end date.
            day = self.first_date
            end = self.end
            while day <= end:
                if self.check_date(day):
                    date_list.append(day)
                day = day + datetime.timedelta(days=1)
        else:
            # Only start is defined, just download that specific day
            if self.check_date(self.first_date):
                date_list.append(self.first_date)

        return date_list

    def get_model_list(self):
        return list(self.all_models.keys())


    def get_tasks(self, prune=True, dryrun=False):
        """
        get a list of all the tasks necessary from the model. Don't process files that
        exist and are the correct size. If prune is true, remove files that are the wrong size.
        """
        tasks = []
        for m in self.get_model_list():
            if not prune:
                tasks.extend(self.all_models[m])
            else:
                for task in self.all_models[m]:

                    if "min_size" in task:
                        min_size = task["min_size"]
                    else:
                        min_size = 1000
                    if "actual_size" in task:
                        actual_size = task["actual_size"]
                    else:
                        actual_size = 0
                    size = process_file_by_size(task["target"], min_size, actual_size, dryrun=dryrun)
                    if size == 0:
                        tasks.append(task)
        return tasks

    def get_target_folders(self):
        """
        Check that the directories exist for all models.
        """
        folders = []
        for m in self.get_model_list():
            for task in self.all_models[m]:
                folders.append(os.path.dirname(task["target"]))
        return folders

    def make_target_folders(self, dryrun=False):
        """
        Check that the directories exist for all models.
        """
        for f in self.get_target_folders():
            if not os.path.exists(f):
                logging.debug(f"Creating folder {f}")
                if not dryrun:
                    os.makedirs(f, DIR_MODE, exist_ok=True)
