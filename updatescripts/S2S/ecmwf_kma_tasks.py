from ECMWFModelTaskClass import ECMWFModelTaskBase


class KMAModel(ECMWFModelTaskBase):
    """
    Model used to download the KMA model data from the ECMWFDataServer()
    """

    # Can only download data from 20 days prior without additional ECMWF privileges.
    DefaultDelay = 2

    def __init__(self, start=None):
        """
        :param start: datetime day to get data. Will be Today-DefaultDelay if not set
        """
        super().__init__(KMAModel.DefaultDelay, start)

        pf_toplevel = f"{self.S2S_toplevel}/KMA/REL/PF/"
        cf_toplevel = f"{self.S2S_toplevel}/KMA/REL/CF/"

        y_m_d = f"{self.start.year}-{self.start.month:02d}-{self.start.day:02d}"
        ymd = f"{self.start.year}{self.start.month:02d}{self.start.day:02d}"

        pf_1p5_toplevel = f"{self.S2S_toplevel}/KMA/REL_new/PF/{self.start.year}"
        cf_1p5_toplevel = f"{self.S2S_toplevel}/KMA/REL_new/CF/{self.start.year}"

        ### 1.5x1.5 new version
        self.all_models["KMA_REL_1p5_CF"] = [
            {
                "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "130/131/132/156",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },

            {
                "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_w{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "135",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },

            {
                "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_q{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "133",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },

            {
                "target": f"{cf_1p5_toplevel}/kma_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                # "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },

            {
                "target": f"{cf_1p5_toplevel}/kma_rel_cf_da_sfc{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                # "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                "param": "31/34/167/168/235/228164",
                "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            }
        ]

        self.all_models["KMA_REL_1p5_PF"] = [
            {
                "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "130/131/132/156",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_w{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "135",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },

            {
                "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_q{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                "param": "133",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },

            {
                "target": f"{pf_1p5_toplevel}/kma_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                # "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                "step": "0/to/1440/by/24",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "target": f"{pf_1p5_toplevel}/kma_rel_pf_da_sfc{ymd}{ymd}.grb",
                "class": "s2",
                "dataset": "s2s",
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/7",
                "origin": "rksl",
                # "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                "param": "31/34/167/168/235/228164",
                "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                "stream": "enfo",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            }
        ]
