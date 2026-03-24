# Base Class for creating download models.  Some stuff is the same everywhere...
#
# Jeff Turmelle - Jan 2023
# Reconfiguration of Jing Yuan's work to make it more modular.
#

from S2S_config import S2S_ecmwf_toplevel_directory, DIR_MODE
import datetime
import logging
import os

from ECMWFModelTaskClass import ECMWFModelTaskBase


class ECMWF_REFModelTaskBase(ECMWFModelTaskBase):
    """
    This subclass is slightly different than the base due to the date checks.
    Reference example: https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-cwao/levtype=sfc/type=cf/
    This is a base model for building tasks to download reforecast data from the ECMWF Data Server
    Reforecasts are typically available on specific days of the week (realtime date).
    If a start date is specified, we assume they know that is the exact date they want to download for, so no
    modifications are made to the realtime date.
    If a start date and an end date are specified, we will download data from start to end on the specific weekdays.
    This class is meant to be subclassed.
    """
    goback = 60

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=0):
        if goback is None:
            goback = ECMWF_REFModelTaskBase.goback
        self.model_version_offset = model_version_offset

        super().__init__(start, end, weekdays, goback)

        self.dates = self.get_date_list()

    def get_date_list(self):
        date_list = []

        # Override get_date_list as we use model_version_offset instead of data_access_delay.
#        if self.weekdays is None:
#            raise ValueError("Weekdays are required")
        if self.goback < 1:
            raise ValueError("goback must be >= 1")

        if self.first_date is None:
            # in this case, we are going to download the previous goback days, up to the offset date,
            # only for the defined weekdays
            for i in range(0-self.goback, self.model_version_offset+1, 1):
                d = self.today + datetime.timedelta(days=i)
                if self.check_date(d):
                    date_list.append(d)
        elif self.end is not None:
            d = self.first_date
            while d <= self.end:
                if self.check_date(d):
                    date_list.append(d)
                d = d + datetime.timedelta(days=1)
        else:
            if self.check_date(self.first_date):
                date_list.append(self.first_date)

        return date_list
