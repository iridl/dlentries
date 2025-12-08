_entries_ is the main folder in the Data Catalog. Its content controls the 
representation of the Catalog in the Data Library website under <ins>SOURCES</ins>. 
Sub-/folders in the Catalog are represented as sub-/datasets in the DL website. The 
sub-/folders / sub-/datasets organization eventually ends up in **index.tex** files 
that define datasets' variables in Ingrid representation. **index.tex** files define 
the independent variables (or grids), the variables reading from one or a set of 
data files, and all the desired metadata. Variables can also be Ingrid calculations 
derived from other existing DL variables, as opposed to reading from data file(s). 
They can also include documentation, links to sources, references, and other 
information of interest. Sub-datasets can also be created within an **index.tex** 
file in place of creating sub-folders.  
_entries_ can also contain **.html** files for documentation, readme, etc.  

_updatescripts_ contains the scripts used or having been used to fetch new data 
files for a dataset that increments, typically in time (daily, weekly, monthly, 
etc.). Older ones are written in Perl while more recent ones were written in Python. 
Most of the scripts no longer used operationally by the scheduled _crontabs_ are 
moved to the _unused_ folder. This practice facilitated retrieving information or 
processes used in older scripts without having to travel back into git history, for 
those that have been git-removed.  

_one-time-scripts_ contains scripts typically used to get an initial whole set of 
files when setting up a new dataset for the first time. They often resemble their 
_updatescritps_ counterpart (for those who have one -- not all datasets update). 
Some update scripts are actually written to cover both cases (get all files or get 
new increments).  

**dlhomes.tex** defines <ins>home</ins> Catalog entries in the DL website, listing 
their name in the DL website Catalog and the path to the Catalog entries in the file 
system. Then the content under those paths must be identical in nature to the 
_entries_. <ins>home</ins> Catalog entries are typically used as sandbox for DL 
developers, or "private" DL spaces for personel at the Institution hosting the DL. 
Their access remains public (unless restrictions are set against its entries). They 
are just not ostensibly shown to the public.  

_descriptions_ and _documentation_ are another mean to keep respectively **.html** 
and **.pdf** files that Catalog's **index.tex** files can refer to, instead of 
keeping them where they are desired at the dataset level in _entries_, as explained 
above.  
