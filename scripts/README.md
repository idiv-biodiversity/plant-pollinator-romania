## Workflow for the web plot

The scripts concerning map plotting are `network_check_double_naming.r` and `ro_bipartite_network.r`. Order of running the scripts matters: 

1. `network_check_double_naming.r` - checks and fixes the duplicates in species naming
2. `ro_bipartite_network.r` - creates the bipartite web plot


## Workflow for maps

The scripts concerning map plotting are `get_country_pl_data.r` and `maps_pollen_lim.r`. Order of running the scripts matters: 

1. `get_country_pl_data.r` - gets country information (country ISO2 and ISO3 codes) using study coordinates
2. `maps_pollen_lim.r` - makes heatmaps of counts

For Pollen Limitation data I spatially intersected the long-lat coordinates with the accurate *GADM shapefile* (downloaded from http://www.gadm.org/). For each point I got a country code and for the few that I didn't (because they fall in the water, near the coasts) I checked in the dataset the column *Location_Author* to see what country/location is declared. Once I had a country code for each row in the dataset, I counted unique values of the column *unique_study_number* by country code (see `get_country_pl_data.r`). Then this info was used for plotting (see `maps_pollen_lim.r`).

For network data, A.T. already gave me counts of networks per each country and I plotted that info (see `maps_pollen_lim.r`).

