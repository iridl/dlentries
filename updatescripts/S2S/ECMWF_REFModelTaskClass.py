# Base Class for creating download models.  Some stuff is the same everywhere...
#
# Jeff Turmelle - Jan 2023
# Reconfiguration of Jing Yuan's work to make it more modular.
#

from S2S_config import S2S_ecmwf_toplevel_directory
import datetime
import logging
import os
import update_utilities as uu


class ECMWF_REFModelTaskBase:
    """
    Base model for building tasks to download data from the ECMWF Data Server
    """
    hindcast_years = 20

    def __init__(self, start=None, delay=0, version_inc=0):
        """
        :param start:
            Reforecast real time date to get data from, if provided, otherwise use today - delay.
        :param version_inc:
            Amount to increment for the model version date.
        """

        # Where is the S2S Toplevel
        self.S2S_toplevel = S2S_ecmwf_toplevel_directory()
        self.today = datetime.datetime.now(datetime.UTC)
        self.last = self.today - datetime.timedelta(days=delay) + datetime.timedelta(days=version_inc)
        self.realtime_dt = self.today - datetime.timedelta(days=delay)
        self.version_dt = self.realtime_dt + datetime.timedelta(days=version_inc)

        # Keep track of the day we are downloading data from.
        if start is not None:
            self.start = start + datetime.timedelta(days=version_inc)
        else:
            self.start = self.version_dt

        # all_models is to be defined in the subclass
        self.all_models = {}

    def get_model_list(self):
        return list(self.all_models.keys())

    def get_start(self):
        return self.start

    def get_last(self):
        return self.last

    def get_tasks(self):
        """
        get a list of all the tasks from all the models., never trying to access models
        greater than the last day.
        """
        tasks = []
        if self.start <= self.last:
            for m in self.get_model_list():
                tasks.extend(self.all_models[m])
        return tasks

    def make_target_folders(self):
        """
        Check that the directories exist for all models.
        
        """
        for m in self.get_model_list():
            for task in self.all_models[m]:
                folder = os.path.dirname(task["target"])
                if not os.path.exists(folder):
                    logging.info(f"Creating folder {folder}")
                    os.makedirs(folder, uu.DIR_MODE, exist_ok=True)
