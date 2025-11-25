#!/usr/local/bin/condarun updatescripts2

from pathlib import Path
import urllib.request as urlr
import tempfile
import gzip
import tarfile
import zipfile
import bz2
import datetime
import xarray as xr
import numpy as np


DIR_MODE = 0o775
FILE_MODE = 0o664


def cf_ds(ds, format=None):
    """Updates a dataset CF metadata conventions.

    Applies necessary changes to CF metadata.

    Parameters
    ----------
    ds: xarray.Dataset
        read from `xarray.open_dataset`
    format: str, optional
        triggers changes to datasets specificly needed for `format` files
        currently supports changes to HDF-EOS
        Default is None which will trigger changes needed for any `format`
    
    Returns
    -------
    updated Dataset.

    See Also
    --------
    xarray.open_dataset

    Notes
    -----
    Currently is triggered only against HDF-EOS specific format by:
    * Keeping only first value of `_FillValue` from `encoding` dictionary attribute
      if multiple.
    * Sets variables with attribute `_CoordinateAxisType` as coordinate.
    """
    if format == "HDF-EOS" :
        for var in ds.variables:
            encoding = ds[var].encoding
            if "_FillValue" in encoding :
                if isinstance(encoding["_FillValue"], np.ndarray):
                    encoding["_FillValue"] = encoding["_FillValue"][0]
        ds = ds.set_coords([
            v for v in ds.variables if "_CoordinateAxisType" in ds[v].attrs
        ])
    return ds


def open_and_split_to(
    file_path,
    file_name,
    from_format=None,
    group=None,
    drop_variables=None,
    to_suffix=None,
    unlink=False,
):
    """Splits a file with multiple variables into multiple files in the designated
    format with one variable and their coordinate-variables.

    Splits all the variables in `file_name` found in `file_path`
    into individual files written in `file_path` of which name stem is extended with
    the variable name. `group` may need to be indicated as default one read
    might not be the one of interest.
    List variables you don't want to be included in the process in `drop_variables` .
    Identified coordinate-variables are included in each file
    and won't have their own file.
    A True `unlink` will delete original `file_name` if all the variable files
    have been written up and no variables were dropped.

    Parameters
    ----------
    file_path : pathlib's Path
        directory where `file_name` to be split is,
        and where individual files will be written.
    file_name : str
        name of the file to split
    from_format : str, optional
        specifies format for metadata handling by `cf_ds`
        Default is None and default metadata formating is applied.
    group : str, optional
        sub-/group to be read. See `xarray.open_dataset` .
        Use default None for non-grouped files or to read default group.
    drop_variables : str or iterable of str, optional
        A variable or list of variables to exclude from being parsed
        from the dataset. Default is None.
    to_suffix : str, optional
        a string indicating the format in which to write the split files.
        Default is None in which case uses `file_name` 's format and extension.
        Currently covered is only ".nc"
    unlink : bool, optional
        if True, no variables intentionally dropped by `drop_variables`
        and all successfully written up: will delete `file_name` .
    
    Returns
    -------
    None

    See Also
    --------
    xarray.open_dataset, xarray.to_netcdf, cf_ds

    Examples
    --------
    in mydatafiles/, replace VNP13C1.A2012017.002.2023201200603.h5
    with individual files for each variable in the file but variables named
    "CMG 0.05 Deg 16 days #1km pix +-30deg VZ" and
    "CMG 0.05 Deg 16 days red reflectance".
    >>> open_and_split_to(
    >>>    Path("mydatafiles/"),
    >>>    "VNP13C1.A2012017.002.2023201200603.h5",
    >>>    group="/HDFEOS/GRIDS/VIIRS_Grid_16Day_VI_CMG/Data Fields",
    >>>    from_format="HDF-EOS",
    >>>    to_suffix=".nc"
    >>>    unlink=True,
    >>>    drop_variables=[
    >>>        "CMG 0.05 Deg 16 days #1km pix +-30deg VZ",
    >>>        "CMG 0.05 Deg 16 days red reflectance",
    >>>    )
    """
    if not (file_path / file_name).is_file():
        raise Exception(f'{file_path / file_name} does not exist')
    ds = cf_ds(xr.open_dataset(
        file_path / file_name,
        group=group,
        drop_variables=drop_variables,
    ), format=from_format)
    if to_suffix == None :
        to_suffix = Path(file_name).suffix
    count_files = 0
    for data_var in ds.data_vars:
        new_file_name = (
            f'{Path(file_name).stem}_{data_var.replace(" ", "_")}{to_suffix}'
        )
        new_file = file_path / new_file_name
        if new_file.is_file():
            print(f'Already have {new_file}')
            count_files = count_files + 1
        else:
            print(f'writing {new_file_name}')
            ds_split = ds.drop_vars([
                other_var for other_var in ds.data_vars if other_var != data_var
            ])
            if to_suffix == ".nc":
                ds_split.to_netcdf(new_file)
            else:
                raise Exception(f'{to_suffix} is not a supported format to write to')
            add_to_dataset(new_file)
            count_files = count_files + 1
    if (count_files == len(ds.data_vars)) and unlink and (drop_variables == None):
        (file_path / file_name).unlink()
        print(
            f'All variables written as files and {file_path / file_name} removed'
        )
    return None


def unpack(
    packed_file,
    type=None,
    destination_dir=None,
    destination_name=None,
    keep_packed_file=True,
):
    """Unpacks a file.

    Parameters
    ----------
    packed_file : pathlib's Path(file)
        path of file to be unpacked
    type : str, optional
        type of packaging. Currently supporting ".gz", ".tar" and ".zip"
        Default is None in which case is `packed_file` suffix
    destination_dir : pathlib's Path(dir), optional
        path where to unpack `packed_file`
        Default is None in which case is `packed_file` parent
    destination_name : str, optional
        file or directory name to give unpacked `packed_file`
        in `destination_dir`
        Default is None in which case is `packed_file` stem
    keep_packed_file : boolean, optional
        Whether to keep the original `packed_file`
        Default is True by security even though it mose use cases will be False

    Returns
    -------
    unpacked_path, message : tuple(Path, str)
        `unpacked_path` is the Path of the resulting unpacked directory or file
        `message` indicates success or exception raised
    """
    if type == None :
        type = packed_file.suffix
    if destination_dir == None:
        destination_dir = packed_file.parent
    if destination_name == None:
        destination_name = packed_file.stem
    if type == ".gz" :
        try:
            with gzip.open(packed_file) as of:
                with tempfile.NamedTemporaryFile(dir=destination_dir) as tmp:
                    tmp.write(of.read())
                    message = add_to_dataset(
                        Path(tmp.name),
                        new_path=(destination_dir / destination_name),
                    )
            if not keep_packed_file:
                packed_file.unlink()
        except Exception as e:
            message = f'failed to unpack {packed_file} with exception {e}'
    elif type == ".tar" :
        try:
            with tarfile.open(packed_file) as of:
                with tempfile.TemporaryDirectory(dir=destination_dir) as tmp:
                    of.extractall(path=tmp, filter="data")
                    message = add_to_dataset(
                        Path(tmp),
                        new_path=(destination_dir / destination_name),
                    )
            if not keep_packed_file:
                packed_file.unlink()
        except Exception as e:
            message = f'failed to unpack {packed_file} with exception {e}'
    elif type == ".zip" :
        try:
            with zipfile.ZipFile(packed_file, 'r') as of:
                with tempfile.TemporaryDirectory(dir=destination_dir) as tmp:
                    of.extractall(tmp)
                    message = add_to_dataset(
                        Path(tmp),
                        new_path=(destination_dir / destination_name),
                    )
            if not keep_packed_file:
                packed_file.unlink()
        except Exception as e:
            message = f'failed to unpack {packed_file} with exception {e}'
    elif type == ".bz2" :
        try:
            with bz2.open(packed_file) as of:
                with tempfile.NamedTemporaryFile(dir=destination_dir) as tmp:
                    tmp.write(of.read())
                    message = add_to_dataset(
                        Path(tmp.name),
                        new_path=(destination_dir / destination_name),
                    )
            if not keep_packed_file:
                packed_file.unlink()
        except Exception as e:
            message = f'failed to unpack {packed_file} with exception {e}'
    else:
        message = f'I do not know how to unpack {type} file'
    return (destination_dir / destination_name), message


def download_file(
        destination_dir,
        file_name,
        file_url,
        expected_file_size=None,
        chunk_size=16*1024,
    ):
    """Downloads a file from URL.

    Downloads file in chunks of `chunk_size` from `file_url`
    in `destination_dir` as `file_name` .
    If an expected `expected_file_size` size is given, checks that downloaded is such size.
    If not such size, downloads a temporary file named tmp_file in `destination_dir` .
    Returns boolean and confirmation or helpful error message.

    Parameters
    ----------
    destination_dir : pathlib's Path
        directory where to download the file
    file_name : str
        name of the file to download as
    file_url : str
        URL to download file from
    expected_file_size : int, optional
        expected file size to check download success,
        if None (default), no such check is made
    chunk_size : int, optional
        size of chunks of file to download one after the other,
        default is 16*1024
    Returns
    -------
        is_downloaded, message : tuple
            `is_downloaded` returns True if download successful, otherwise false
            `message` confirms doanload or returns helpful error message
    """
    is_downloaded = False
    destination_file = destination_dir / file_name
    if destination_file.is_file() or destination_file.is_dir():
        message = f'Already got {destination_file} as file or directory'
    else:
        try:
            with urlr.urlopen(file_url) as r:
                destination_dir.mkdir(parents=True, exist_ok=True)
                with tempfile.NamedTemporaryFile(dir=destination_dir) as f:
                    chunk = None
                    while chunk != b'':
                        chunk = r.read(chunk_size)
                        assert isinstance(chunk, bytes)
                        f.write(chunk)
                    if (
                        expected_file_size is None
                        or f.tell() == expected_file_size
                    ) :
                        message = add_to_dataset(
                            Path(f.name), new_path=destination_file
                        )
                        print(message)
                    else:
                        message = f'Temporary file in {destination_dir} is not expected size'
                if not destination_file.is_file():
                    message = f'Renaming temporary file to {destination_file} failed'
                else:
                    is_downloaded = True
                    message = f'{destination_file} downloaded successfully from {file_url}'
        except Exception as e:
            message = f'Something went wrong with exception {e} on {file_url}'
    return is_downloaded, message


def add_to_dataset(path, new_path=None):
    """Changes permissions of file or directory and its children
    appropriate to DL file system. Optionally rename file or top directory

    Parameters
    ----------
    path : pathlib's Path
        path of file or directory of which to change permissions
    new_path : pathlib's Path, optional
        new name for `path`

    Returns
    -------
    message : str
        message indicating success or exception raised

    Notes
    -----
    Most appropriate to run right after download
    or other file/directory transformation such as unpacking
    """
    try:
        if path.is_dir():
            path.chmod(DIR_MODE)
            for dirpath, dirnames, filenames in path.walk():
                for d in dirnames:
                    (dirpath / d).chmod(DIR_MODE)
                for f in filenames:
                    (dirpath / f).chmod(FILE_MODE)
        elif path.is_file():
            path.chmod(FILE_MODE)
        else:
            raise ValueError(f'{path} is neither a directory nor a file')
        message = f'Successfully changed {path} permissions'
        if new_path != None:
            path.rename(new_path)
            message = f'{message} and renamed to {new_path}'
    except Exception as e:
        message = f'Changing permissions on {path} or renaming it raised {e}'
    return message


def previous_month(date=None, iter=0):
    """Returns 1st of `iter` -th previous month from `date` .

    Parameters
    ----------
    date : datetime.datetime, optional
        date from which to find previous month. Default is None,
        in which case datetime.datetime.today() is used.
    iter : int
        how many months to go back from `date` .
        Default is 0 which returns the 1st of `date` 's month.

    Returns
    -------
    date : datetime.datetime
        date set at the 1st of `iter` -th previous month from `date` .
    """
    if date == None :
        date = datetime.datetime.today()
    date = date.replace(day=1)
    for i in range(iter):
        date = (date - datetime.timedelta(days=1)).replace(day=1)
    return date


def next_month(date=None, iter=0):
    """Returns 1st of `iter` -th next month from `date` .

    Parameters
    ----------
    date : datetime.datetime, optional
        date from which to find next month. Default is None,
        in which case datetime.datetime.today() is used.
    iter : int
        how many months to go further from `date` .
        Default is 0 which returns the 1st of `date` 's month.

    Returns
    -------
    date : datetime.datetime
        date set at the 1st of `iter` -th next month from `date` .
    """
    if date == None :
        date = datetime.datetime.today()
    date = date.replace(day=1)
    for i in range(iter):
        date = (date + datetime.timedelta(days=31)).replace(day=1)
    return date
