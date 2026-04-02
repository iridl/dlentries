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

    def check_date(self, d):
        d_string = d.strftime("%a")

        # make sure we're not trying to get data beyond its availability.
        if self.model_version_offset is not None:
            if d >= self.today + datetime.timedelta(days=self.model_version_offset):
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

        # Override get_date_list as we use model_version_offset instead of data_access_delay.
        if self.goback < 1:
            raise ValueError("goback must be >= 1")

        if self.first_date is None:
            # in this case, we are going to download the previous goback days, up to the offset date,
            # only for the defined weekdays
            day = self.today - datetime.timedelta(days=self.goback)
            end = self.today + datetime.timedelta(days=self.model_version_offset+1)
            while day <= end:
                if self.check_date(day):
                    date_list.append(day)
                day = day + datetime.timedelta(days=1)
        elif self.end is not None:
            day = self.first_date
            while day <= self.end:
                if self.check_date(day):
                    date_list.append(day)
                day = day + datetime.timedelta(days=1)
        else:
            if self.check_date(self.first_date):
                date_list.append(self.first_date)

        return date_list
