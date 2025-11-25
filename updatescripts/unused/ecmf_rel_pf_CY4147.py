### This code is used to download s2s ECMWF model 
##   real-time forecast perturbed files
##
##   Jing Yuan
##  12 May 2017
##  Jan 28 2020
##  Apr 30 2020 add ocean data and seperate into 3 files
##  Nov 19 2020 subdirectory

#!/usr/bin/env python
import numpy as np
import datetime
from ecmwfapi import ECMWFDataServer
import multiprocessing as mp
import os
import sys
import time

import s2stools as s2s

ocenter = "ecmf"
origion = "ecmf"
step = "0/to/1104/by/24"
step1 = "24/to/1104/by/24"
step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104"
number = "1/to/50"
time0 = "00:00:00"
ftype = "pf"


sdate = '2018-11-01'

for i in np.arange(0,7,7):
    server = ECMWFDataServer()
    mdate = datetime.datetime.strptime(sdate,'%Y-%m-%d') + datetime.timedelta(days= i )
    mdateymdstr = mdate.strftime('%Y%m%d')
    mdatestr = mdate.strftime('%Y-%m-%d')
    mdatemdstr =  mdate.strftime('-%m-%d')
    print "modelversion date: ", mdatestr,mdateymdstr
    year_fcst=mdate.strftime('%Y')


    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter+"_rel_" + ftype + "_pl_zuvt" + mdateymdstr + mdateymdstr + ".grb"
 
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "130/131/132/156",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #1
    s2s.getfile(argvv, targetfile, server.retrieve)       

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pl_z" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "156",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #1
    s2s.getfile(argvv, targetfile, server.retrieve)

       
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pl_t" + mdateymdstr + mdateymdstr + ".grb"

    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "130",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #1
    s2s.getfile(argvv, targetfile, server.retrieve)
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pl_u" + mdateymdstr + mdateymdstr + ".grb"

    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "131",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #1
    s2s.getfile(argvv, targetfile, server.retrieve)
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pl_v" + mdateymdstr + mdateymdstr + ".grb"

    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "132",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #1
    s2s.getfile(argvv, targetfile, server.retrieve)
    
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_"+ftype + "_pl_q" + mdateymdstr+mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": "ecmf",
        "param": "133",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    }#2
    s2s.getfile(argvv, targetfile, server.retrieve)
        
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pl_w" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "10/50/100/200/300/500/700/850/925/1000",
        "levtype": "pl",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "135",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile, 
        "expect" : "any",
    }#3
    s2s.getfile(argvv, targetfile, server.retrieve)
        
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_sfc_sfc" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "sfc",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "43/121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/174008/228143/228144/228205/228228",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    } #4
    s2s.getfile(argvv, targetfile, server.retrieve)

  
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_sfc_sfc3_" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "sfc",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "180/181/174008/228205/228228",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : 11750,
    } #4
    s2s.getfile(argvv, targetfile, server.retrieve)

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_sfc_sfc2_" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "sfc",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/228143/228144",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : 35150,
    } #4
    s2s.getfile(argvv, targetfile, server.retrieve)
      
    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_"+ ftype + "_da_sfc" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "sfc",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
        "step": step_da_sfc,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile,
        "expect" : "any",
    }#5
    s2s.getfile(argvv, targetfile, server.retrieve)

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_pt_pv" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levelist": "320",
        "levtype": "pt",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "60",
        "step": step,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "target": targetfile, 
        "expect" : "any",
    }#6
    s2s.getfile(argvv, targetfile, server.retrieve)

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_o2d" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "o2d",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
        "step": step_da_sfc,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "grid"  : "1.0/1.0",
        "target": targetfile, 
        "expect" : "any",
    }#7
    s2s.getfile(argvv, targetfile, server.retrieve)

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_o2d1_" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "o2d",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "151163",
        "step": step_da_sfc,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "grid"  : "1.0/1.0",
        "target": targetfile, 
        "expect" : "any",
    }#8 depth of 20C isotherm
    s2s.getfile(argvv, targetfile, server.retrieve)

    targetfile = "/volume1/DataLibrary/ECMWF/S2S/ECMF/REL/PF/" + year_fcst + "/" + ocenter + "_rel_" + ftype + "_o2d2_" + mdateymdstr + mdateymdstr + ".grb"
    
    argvv = {
        "class": "s2",
        "dataset": "s2s",
        "date": mdatestr,
        "expver": "prod",
        "levtype": "o2d",
        "model": "glob",
        "number": number,
        "origin": origion,
        "param": "151225",
        "step": step_da_sfc,
        "stream": "enfo",
        "time": "00:00:00",
        "type": ftype,
        "grid"  : "1.0/1.0",
        "target": targetfile, 
        "expect" : "any",
    }#9 mixed layer thickness
    s2s.getfile(argvv, targetfile, server.retrieve)
