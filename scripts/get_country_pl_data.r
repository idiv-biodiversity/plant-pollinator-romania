# /////////////////////////////////////////////////////////////////////////
#
# Extract country information (ISO2 and ISO3 codes) for mapping from pollen
# limitation dataset.
# This script prepares data for the script maps_pollen_lim.r
#
# ...............................................
# Pollen limitation study counts per country:
#
# The long-lat coordinates from the Pollen Limitation dataset were spatially
# intersected with the accurate GADM shapefile (see links for data in the Load
# data section). For the locations that fell outside the GADM polygones, the
# country information was taken from the Location_Author column of the Pollen
# Limitation dataset. Once the records had a harmonized country code, it was
# possible to aggregate and count studies per countries. The table was saved in
# "output/pollen_limitation_study_counts_per_country_eu.csv"
#
# ...............................................
# Plant-pollinator networks study counts per country:
#
# A table already exists in "data/Supporting_Information_S4.csv"
#
# /////////////////////////////////////////////////////////////////////////


# Load packages -----------------------------------------------------------

library(sp)
library(rgdal)
library(data.table)
library(tmap)

rm(list = ls(all.names = TRUE))


# Load data ---------------------------------------------------------------

# Pollen limitation dataset 
# Bennett, J. M., Steets, J. A., Burns, J. H., Durka, W., Vamosi, J. C.,
# Arceo-Gómez, G., Burd, M., Burkle, L. A., Ellis, A. G. Freitas, L., Li, J.,
# Rodger, J. G., Wolowski, M., Xia, J., Ashman, T-L., Knight T. M. Dryad Digital
# Repository http://datadryad.org, doi:10.5061/dryad.dt437 (2018)
dt_pl <- fread("data/PL_ANALYSIS_02_02_2018.csv",
               select = c("unique_study_number", 
                          "lon_decimal_PTL_JMB", "lat_decimal_PTL_JMB",
                          "Location_Author", "Continent_JMB"))
# NOTE - file and columns names might be different in the data from the dryad
# platform.

# Check if long-lat are within expected intervals
range(dt_pl[,lon_decimal_PTL_JMB]) %between% c(-180, 180)
range(dt_pl[,lat_decimal_PTL_JMB]) %between% c(-90, 90)

# Load GADM country shapefile:
# GADM database at http://www.gadm.org/; downloaded on 31 jul 2017; Version 2.8
# at https://gadm.org/old_versions.html
# Takes some time to load (1-2 min)
gadm28_adm0 <- rgdal::readOGR(dsn   = "I:/sie/_data_VS/Admin_borders/gadm28_levels.shp",
                              layer = "gadm28_adm0",
                              stringsAsFactors = FALSE)


# Get country info --------------------------------------------------------

# Extract country information by running a spatial intersection between study
# locations and the accurate GADM shapefile.

dt_pl_europe <- dt_pl[Continent_JMB == "Europe"]

# Prepare spatial object from study coordinates 
pl_sp <-  sp::SpatialPoints(coords = dt_pl_europe[, c("lon_decimal_PTL_JMB", # order matters
                                                      "lat_decimal_PTL_JMB")],
                            proj4string = gadm28_adm0@proj4string)
# +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
save(pl_sp, file = "output/cache/pl_sp.rda")

# Run spatial overlay between study locations and GADM shapefile
system.time(
  idx_poly <- sp::over(x = pl_sp, 
                       y = as(gadm28_adm0, "SpatialPolygons"))
)
# ~ 25 sec
save(idx_poly, file = "output/cache/idx_poly.rda")
# load(file = "output/cache/idx_poly.rda")

# Update pl data by reference using the vector of indices from spatial overlay 
dt_pl_europe[, ':=' (country_gadm_ISO2 = gadm28_adm0@data[idx_poly, "ISO2"],
                     country_gadm_ISO  = gadm28_adm0@data[idx_poly, "ISO"],
                     country_gadm_name = gadm28_adm0@data[idx_poly, "NAME_ENGLI"])]


# Clean country data ------------------------------------------------------

# Fix some NA cases (coordinates fell outside of GADM coverage)
# but information about country can be extracted from Location_Author country
dt_pl_europe[is.na(country_gadm_name)]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Vasilikon",
             country_gadm_ISO := "GRC"]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Denmark",
             country_gadm_ISO := "DNK"]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Sweden",
             country_gadm_ISO := "SWE"]


# Save results for map making ---------------------------------------------

# Aggregate and count pollen limitation studies per country
dt_pl_europe_agg <- dt_pl_europe[,  .(pl_counts = uniqueN(unique_study_number)), 
                                 by = country_gadm_ISO ]

write.csv(x = dt_pl_europe_agg, 
          file = "output/pollen_limitation_study_counts_per_country_eu.csv",
          row.names = FALSE)

save(dt_pl_europe, file = "output/cache/dt_pl_europe.rda")
rm(gadm28_adm0)
