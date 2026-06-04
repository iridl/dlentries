from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime


class ISACModel(ECMWFModelTaskBase):
    """
    Download ISAC forecast Data from ECMWF
    """
    first_date = datetime.datetime(2015, 1, 9)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Thu"]
    origin = "isac"
    
    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = ISACModel.weekdays

        super().__init__(start, end, weekdays, goback, ISACModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/ISAC/REL_new/PF"
        cf_toplevel = f"{self.S2S_toplevel}/ISAC/REL_new/CF"

        self.all_models["ISAC_REL_PF"] = []
        self.all_models["ISAC_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["ISAC_REL_PF"].extend([
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 768393120 if d < datetime.datetime(2017, 6, 8) else 792841520 if d < datetime.datetime(2024, 9, 5) else 866186720,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "121/122/151/165/166/179/228228",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_sfc_sfc6_{ymd}{ymd}.grb",
                    "actual_size": 2451851600,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "0/6/12/18/24/30/36/42/48/54/60/66/72/78/84/90/96/102/108/114/120/126/132/138/144/150/156/162/168/174/180/186/192/198/204/210/216/222/228/234/240/246/252/258/264/270/276/282/288/294/300/306/312/318/324/330/336/342/348/354/360/366/372/378/384/390/396/402/408/414/420/426/432/438/444/450/456/462/468/474/480/486/492/498/504/510/516/522/528/534/540/546/552/558/564/570/576/582/588/594/600/606/612/618/624/630/636/642/648/654/660/666/672/678/684/690/696/702/708/714/720/726/732/738/744/750/756/762/768/774/780/786/792/798/804/810/816/822/828/834/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 4469862400 if d < datetime.datetime(2017, 6, 8) \
                        else 4609545600 if d < datetime.datetime(2024, 9, 5) \
                        else 5028595200,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "130/131/132/156",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_z{ymd}{ymd}.grb",
                    "actual_size": 1257148800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "156",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_u{ymd}{ymd}.grb",
                    "actual_size": 1257148800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "131",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_v{ymd}{ymd}.grb",
                    "actual_size": 1257148800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "132",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_t{ymd}{ymd}.grb",
                    "actual_size": 1257148800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "130",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/isac_rel_pf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 1152386400 if d < datetime.datetime(2024, 8, 29) else 1257148800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "135",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },

                {
                    "target": f"{pf_toplevel}/isac_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 585468480 if d < datetime.datetime(2017, 6, 8) else 604354560 if d < datetime.datetime(2024, 9, 5) else 658618800,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/40",
                    "origin": ISACModel.origin,
                    "param": "31/34/167/168/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
            ])
            self.all_models["ISAC_REL_CF"].extend([
                {
                    "target": f"{cf_toplevel}/isac_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 24797156 if d < datetime.datetime(2017, 6, 8) else 25582970 if d < datetime.datetime(2024, 9, 5) else 27940412,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ISACModel.origin,
                    "param": "121/122/151/165/166/172/179/228002/228228",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/isac_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                    "actual_size": 61296290,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ISACModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "0/6/12/18/24/30/36/42/48/54/60/66/72/78/84/90/96/102/108/114/120/126/132/138/144/150/156/162/168/174/180/186/192/198/204/210/216/222/228/234/240/246/252/258/264/270/276/282/288/294/300/306/312/318/324/330/336/342/348/354/360/366/372/378/384/390/396/402/408/414/420/426/432/438/444/450/456/462/468/474/480/486/492/498/504/510/516/522/528/534/540/546/552/558/564/570/576/582/588/594/600/606/612/618/624/630/636/642/648/654/660/666/672/678/684/690/696/702/708/714/720/726/732/738/744/750/756/762/768/774/780/786/792/798/804/810/816/822/828/834/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/isac_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 111746560 if d < datetime.datetime(2017, 6, 8) else 115238640 if d < datetime.datetime(2024, 9, 5) else 125714880,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": ISACModel.origin,
                    "param": "130/131/132/156",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/isac_rel_cf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 28809660 if d < datetime.datetime(2024, 9, 5) else 31428720,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": ISACModel.origin,
                    "param": "135",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/isac_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 14636712 if d < datetime.datetime(2017, 6, 8) else 15108864 if d < datetime.datetime(2024, 9, 5) else 16465470,
                    "class": ISACModel.s2s_class,
                    "dataset": ISACModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ISACModel.origin,
                    "param": "31/34/167/168/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from ISAC Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = ISACModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = ISACModel(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")