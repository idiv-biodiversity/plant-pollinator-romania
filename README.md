# Overview

This repository contains the code and data needed to develop the figures from

> Joanne Bennett, Amibeth Thompson, Irina Goia, Reinart Feldmann, Valentin Stefan, Ana Bogdan, Demetra Rakosy, Mirela Beloiu, Beatrice Biro, Simon Bluemel, Milena Filip, Anna-Maria Madaj, Alina Martin, Kalisch Denisa Paula, Gwydion Scherer, Tiffany M. Knight, 2018. A review of European studies on pollination networks and pollen limitation, and a case study designed to fill in a gap

[Download][1] or clone the repository then run the scripts using the `plant-pollinator-romania.Rproj` file ([R][2] and [R Studio][3] are needed)

[1]: https://github.com/idiv-biodiversity/plant-pollinator-romania/archive/master.zip
[2]: https://www.r-project.org/
[3]: https://www.rstudio.com/products/rstudio/download/


## Scripts

### R package versions

For installing older version of packages, run the script `01_checkpoint.r` - it creates a local library into which it installs a copy of the packages required in the project as they existed on CRAN at the specified snapshot date ("2018-02-13"). Also, further details about the package versions can be found in the folder `session-info`.

### Figure 1 - Choropleth maps

Choropleth maps of studies done in Europe on:

- pollen limitation
- plant-pollinator networks

The scripts concerning map plotting are `get_country_pl_data.r` and `maps_pollen_lim.r`. 

1. `get_country_pl_data.r` - prepares counts of pollen limitation studies per country to be further used for making the choropleth maps with the following script.
2. `maps_pollen_lim.r` - makes Choropleth maps of counts; data is already in place: *output/pollen_limitation_study_counts_per_country_eu.csv* and *data/Supporting_Information_S4.csv*

#### Workflow details

**Pollen limitation study counts per country** (computed with `get_country_pl_data.r`)

The long-lat coordinates from the Pollen Limitation dataset were spatially intersected with the accurate GADM shapefile (see links for data in the *Load data* section of `get_country_pl_data.r`). For the locations that fell outside the GADM polygones, the country information was taken from the Location_Author column of the Pollen Limitation dataset. Once the records had a harmonized country code, it was possible to aggregate and count studies per countries. The table was saved in *output/pollen_limitation_study_counts_per_country_eu.csv*

**Plant-pollinator networks study counts per country**

A table already exists in *data/Supporting_Information_S4.csv*


### Figure 2 - Plant-pollinator network

The plant-pollinator network figure was created with the script `ro_bipartite_network.r`. Data for the figure can be found in *data/Supporting_Information_S5.csv*
