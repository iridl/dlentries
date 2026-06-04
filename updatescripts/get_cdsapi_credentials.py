import logging
from pathlib import Path
import json

credentials_file = Path("/usr/local/datalib/updatescript_credentials/cdsapi_credentials.json")

def get_cdsapi_credential(program, file=credentials_file):
    """Retrieve CDS API credentials for a given program.

    Args:
        program (str): The name of the program for which credentials are needed.
        file (Path, optional): The path to the JSON file containing credentials. Defaults to credentials_file.

    Returns:
        dict: A dictionary containing the CDS API credentials. (url, key)
    """
    cred = None
    credentials = None

    try:
        with open(file, "r") as f:
            credentials = json.load(f)
    except (FileNotFoundError, PermissionError, OSError) as e:
        logging.DEBUG(f"Error reading credentials file: {e}")
    except json.JSONDecodeError as e:
        logging.DEBUG(f"Error decoding JSON credentials file: {e}")

    if credentials:
        for c in credentials:
            if c['program'] == program:
                cred = c

    return cred