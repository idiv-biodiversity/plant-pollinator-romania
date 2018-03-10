#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Extract country information for mapping from pollen limitation dataset
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# Load packages -----------------------------------------------------------
library(sp)
library(rgdal)
library(data.table)


# Load data ---------------------------------------------------------------

# pollen limitation dataset
dt_pl <- fread("data/PL_ANALYSIS_02_02_2018.csv",
               select = c("unique_study_number", 
                          "lon_decimal_PTL_JMB", "lat_decimal_PTL_JMB",
                          "Location_Author", "Continent_JMB"))
# Check if long-lat are within expected intervals
range(dt_pl[,lon_decimal_PTL_JMB]) %between% c(-180, 180)
range(dt_pl[,lat_decimal_PTL_JMB]) %between% c(-90, 90)


# Get country info --------------------------------------------------------

dt_pl_europe <- dt_pl[Continent_JMB == "Europe"]

# Attempt to extract country info from Location_Author column.
# I used finally the spatial intersection between points and the accurate GADM shapefile.

# unique(dt_pl_europe$Location_Author)
# str_countries <- dt_pl_europe[,
#                               .(Location_Author,
#                                 tstrsplit(Location_Author, split = ',|\\s|_'))]


# Load GADM country shapefile:
# GADM database at http://www.gadm.org/
# Takes some time to load (1-2 min)
gadm28_adm0 <- rgdal::readOGR(dsn   = "I:/sie/_data_VS/Admin_borders/gadm28_levels.shp",
                              layer = "gadm28_adm0",
                              stringsAsFactors = FALSE)

# Prepare spatial object from study coordinates 
pl_sp <- 
  sp::SpatialPoints(coords = dt_pl_europe[, c("lon_decimal_PTL_JMB",
                                              "lat_decimal_PTL_JMB")], # order matters
                    proj4string = gadm28_adm0@proj4string)

# Run spatial overlay between study locations and GADM shapefile
system.time(
  idx_poly <- sp::over(x = pl_sp, 
                       y = as(gadm28_adm0, "SpatialPolygons"))
)
# 25 sec (is faster if the RAM is not that full)
# save(idx_poly, file = "output/idx_poly.rda")
# load(file = "output/idx_poly.rda")

# Update pl data by reference using the vector of indices from spatial overlay 
dt_pl_europe[, ':=' (country_gadm_ISO2 = gadm28_adm0@data[idx_poly, "ISO2"],
                     country_gadm_ISO  = gadm28_adm0@data[idx_poly, "ISO"],
                     country_gadm_name = gadm28_adm0@data[idx_poly, "NAME_ENGLI"])]


# Clean some country data -------------------------------------------------

# Fix some NA cases (coordinates fell outside of GADM coverage)
# but information about country can be extracted from Location_Author country
dt_pl_europe[is.na(country_gadm_name)]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Vasilikon",
             country_gadm_ISO := "GRC"]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Denmark",
             country_gadm_ISO := "DNK"]
dt_pl_europe[is.na(country_gadm_name) & Location_Author %like% "Sweden",
             country_gadm_ISO := "SWE"]

save(dt_pl_europe, file = "output/dt_pl_europe.rda")
rm(gadm28_adm0)


# Test plot ---------------------------------------------------------------

library(tmap)
# load map of Europe that comes with tmap package
data(Europe) 

pl_sp_projected <- spTransform(pl_sp, CRSobj = as.character(Europe@proj4string))

test_map_pl <-
tm_shape(shp = Europe) +
  tm_polygons() +
  tm_shape(shp = pl_sp_projected) +
  tm_dots(size = 0.1, alpha = 0.5, col = "red")

save_tmap(test_map_pl, "output/test_map_pl.png",
          units = "cm", width = 8, height = 7, dpi = 300)