from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class ECMF_ALL_Model(ECMWFModelTaskBase):
    """
    Model used to download the ECMWF models from the ECMWFDataServer cdsapi()
    """
    first_date = datetime.datetime(2023, 6, 30)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    origin = "ecmf"

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = ECMF_ALL_Model.weekdays

        super().__init__(start, end, weekdays, goback, ECMF_ALL_Model.data_access_delay)

        self.all_models["ECMF_REL_PF"] = []
        self.all_models["ECMF_REL_CF"] = []

        for d in self.dates:
            pf_toplevel = f"{self.S2S_toplevel}/ECMF/CY48/REL/PF/{d.year}/{d.month:02d}"
            cf_toplevel = f"{self.S2S_toplevel}/ECMF/CY48/REL/CF/{d.year}/{d.month:02d}"

            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["ECMF_REL_PF"].extend([
                {
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_tuqvwz_ALL{ymd}{ymd}.grb",
                    "class": ECMF_ALL_Model.s2s_class,
                    "dataset": ECMF_ALL_Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/100",
                    "origin": ECMF_ALL_Model.origin,
                    "param": "130/131/132/133/134/135/156",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                }
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from ECMWF All LevelsModel.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = ECMF_ALL_Model.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = ECMF_ALL_Model(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")