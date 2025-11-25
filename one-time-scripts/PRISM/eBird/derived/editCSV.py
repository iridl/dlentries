import pandas as pd
import glob

# file path to where original csv files are on our server
list_files = glob.glob(
    "/Data/PRISM/eBird/derived/detectionProbability/originalCSV/*.csv"
)
# path to the gid file downloaded from DL which connects gid to towns to use for sorting data
# gids come from the MA towns geometry ds set up in the DL (these are arbitrary values)
# http://iridl.ldeo.columbia.edu/SOURCES/.Features/.Political/.UnitedStates/.MA/.town/.city/index.html
sorter = pd.read_csv("/Data/PRISM/eBird/derived/detectionProbability/sorter.csv")

for file in list_files:
    df = pd.read_csv(file)
    df = df.drop_duplicates(subset=("city", "date"))  # duplicates in the original file
    mergedDF = pd.merge(df, sorter, on="city")
    sortedDF = mergedDF.sort_values(
        ["gid", "date"], ascending=(True, True)
    ).reset_index()
    #selecting only the columns we need
    df_new = sortedDF[['city', 'TOWN_ID', 'date', 'eBird.DP.RF', 'eBird.DP.RF.SE', 'gid']]
    fileNameTSV = file.replace(".csv", ".tsv")
    df_new.to_csv(fileNameTSV, index=False, sep="\t")  # readible format by ingrid
