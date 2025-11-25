# Not currently used.  Saved for possible future use.
#

def ecmwf_lock(name, username, description=""):
    """
    Create or reads a lockfile for a process so two processes can't run at the same time
    as the same user. An ECMWF process can run as different users, so we need to keep track
    of the username as well.

    :param name: the name of the process we want to lock/check for lock
    :username: the name of the user API key we're using
    :description: A good description of the process.  Commandline arguments is a good choice.
    :return:
        lockinfo[]
            pid, name, description, date, filename, hostname, username
        True - process is already locked by this username

    raises Exceptions:
        IOERROR if file can't be opened, or invalid data in file
        OSERROR if file can't be opened
        JSONDECODEERROR if file is not valid JSON
    """

    # Put the lock in a central location.
    lockdir = ECMWF_S2S_toplevel_directory()

    def createlockfile(lockfilename, name, username, description, current_lockinfo=None):
        now = datetime.now()
        lockinfo = []

        if current_lockinfo is not None:
            lockinfo.extend(current_lockinfo)

        thislock = {
            "pid": os.getpid(),
            "name": name,
            "description": description,
            "date": now.strftime("%c"),
            "filename": lockfilename,
            "hostname": socket.gethostname(),
            "username": username
        }
        lockinfo.append(thislock)

        with open(lockfilename, 'w') as f:
            json.dump(lockinfo, f, indent=4)

        return thislock

    # Make sure the lockdirectory exists
    if not os.path.exists(lockdir) or not os.path.isdir(lockdir):
        raise FileNotFoundError(f"{lockdir} not found")
    else:
        lockfilename = f"{lockdir}/{name}.lock"

        # check if file exists.  If it does, read the file and get the current locks.
        if os.path.exists(lockfilename) and os.path.isfile(lockfilename):
            with open(lockfilename, 'r') as f:
                locks = json.load(f)

            for l in locks:
                if l['username'] == username:
                    # the system is already locked by username
                    return True

            # if we get here, the user doesn't have it locked, so add this user
            lockinfo = createlockfile(lockfilename, name, username, description, locks)
        else:
            lockinfo = createlockfile(lockfilename, name, username, description)

        return lockinfo


def ecmwf_unlock(lockinfo):
    """
    Remove a user from a lockfile
    """
    newlocks = []
    lockfilename = lockinfo['filename']

    if os.path.exists(lockfilename) and os.path.isfile(lockfilename):
        with open(lockfilename, 'r') as f:
            locks = json.load(f)

    for l in locks:
        if l['username'] != lockinfo['username']:
            newlocks.append(l)
    if len(newlocks) == 0:
        os.unlink(lockinfo['filename'])
    else:
        with open(lockfilename, 'w') as f:
            json.dump(newlocks, f, indent=4)
