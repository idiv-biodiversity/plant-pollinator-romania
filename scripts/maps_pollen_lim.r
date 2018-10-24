# /////////////////////////////////////////////////////////////////////////
#
# Makes heatmaps with counts of ... 
# A) - pollen limitation papers 
# B) - pollinator-plants networks papers
# per country.
#
# /////////////////////////////////////////////////////////////////////////


# Load packages -----------------------------------------------------------

library(data.table)
library(sp)
library(rgdal)
library(classInt) # for univariate class intervals - important for legend categ
library(tmap)
library(RColorBrewer)
library(scales)

rm(list = ls(all.names = TRUE))


# Load data ---------------------------------------------------------------

# Pollinator-plants networks dataset
dt_net <- fread("data/Supporting_Information_S4.csv", check.names = TRUE)

# Pollen limitation study counts per country in Euope 
# (see get_country_pl_data.r script)
dt_pl_europe_agg <- fread("output/pollen_limitation_study_counts_per_country_eu.csv")

# Load map of Europe that comes with the tmap package. 
# NOTE - this is an options for older versions of tmap, so be sure you run the
# 01_checkpoint.r script that installs all older versions of the packages and
# adjusts the path to the library where the packages were installed.
data(Europe, package = "tmap")


# A - Pollinator-plants networks dataset ----------------------------------

# A.1 -- Prepare data -----------------------------------------------------

dt_net[, is_name_in_Europe_data := European.countries %in% unique(Europe@data$name)]
# What country names do not match?
dt_net[!(is_name_in_Europe_data)]
# Get a common country naming
dt_net[, name := European.countries]
dt_net[name == "Swizterland", name := "Switzerland"]
dt_net[name == "Bosnia and Herzegovina", name := "Bosnia and Herz."]
dt_net[name == "Czech Republic", name := "Czech Rep."]
dt_net[name == "Leichtenstein", name := "Liechtenstein"]

# Used defensively, in case some aggregation needs to be done 
# (e.g in a past version counts for Azores goes to Portugal)
dt_net <- dt_net[, .(network_counts = sum(Study.count)), by = name]

# Spatial left join (merge) by country names.
# This bring the network_counts column into the Europe country polygons.
Europe_merged <- sp::merge(x  = Europe,
                           y  = dt_net,
                           by = "name",
                           all.x = TRUE)

# Check values
test <- Europe_merged@data
test[is.na(test$network_counts), c("name", "sovereignt", "continent")]

# Add zero to European polygons without data.
# This is needed to distinguish them from Non-European ones.
Europe_merged$network_counts <- 
  ifelse(is.na(Europe_merged$network_counts) & Europe_merged$continent == "Europe",
         yes = 0,
         no = Europe_merged$network_counts)

# Check values again
test <- Europe_merged@data
test[is.na(test$network_counts), c("name", "sovereignt", "continent")]


# A.2 -- Make map ---------------------------------------------------------

# A.2.1 --- Base map elements ---------------------------------------------

# Define a series of layers and graphical elements that are common for the two maps.
map_base_elements <-
  tm_text(text = "iso_a3", 
          size = "AREA", 
          root = 4, 
          shadow = TRUE, 
          scale  = 0.7, 
          size.lowerbound = .4) +
  tm_layout(legend.text.size  = 0.5,
            legend.title.size = 0.8,
            # legend.position = c("RIGHT","TOP"), 
            # This does not draw the right edge frame border for whatever reason
            legend.just = c(1, 1),
            legend.position = c(0.990, 0.999),
            legend.frame = TRUE,
            # legend.format = list(scientific = TRUE),
            # legend.frame.lwd = 0.25, # this is not available on CRAN tmap yet
            frame.lwd = 1,
            inner.margins = c(0, 0, 0, 0),
            outer.margins = c(0, 0, 0, 0)) +
  tm_style_grey()

# A.2.2 --- Networks map --------------------------------------------------

# Check counts to get an idea about legend breaks.
# NOTE: Choosing the type of breaks has a significant impact on the map.

hist(Europe_merged$network_counts)
summary(unique(Europe_merged$network_counts))
table(Europe_merged$network_counts)

# Choose univariate class intervals. 
# Check ?classIntervals, Details for various styles
cls <- classIntervals(var = Europe_merged$network_counts,
                      n = 4,
                      style = "jenks") # change style if needed
cls
cls$brks

# Create a variable with desired legend labels
# https://stackoverflow.com/a/49190033/5193830
Europe_merged$network_counts_label <-
  cut(Europe_merged$network_counts, 
      breaks = c(0,1,5,10,18),
      labels = c("0", "1-5", "5-10", "10-18"),
      include.lowest = TRUE,
      right = FALSE)

# makes color palettes
my_cols <- RColorBrewer::brewer.pal(n = 4, name = "YlGnBu") # "YlGnBu" , "BuGn"
# check the colors
scales::show_col(my_cols)

# Do the map
map_net <-
  tm_shape(shp = Europe_merged) +
  tm_polygons(col = "network_counts_label", 
              textNA = "Non-European", 
              title  = "Network studies",
              lwd = 0.5,
              palette = my_cols) +
  map_base_elements # add the previously defined base elements/layers

save_tmap(map_net, "output/map_pollination_network.tiff", 
          units = "cm", width = 8, height = 7, dpi = 1000)


# B - Pollen limitation dataset -------------------------------------------

# B.1 -- Prepare data -----------------------------------------------------

# Spatial left join (merge) by country names.
# This bring the pl_counts column into the Europe country polygons.
Europe_merged <- sp::merge(x  = Europe_merged,
                           y  = dt_pl_europe_agg,
                           by.x = "iso_a3",
                           by.y = "country_gadm_ISO",
                           all.x = TRUE)

# Add zero to European polygons without data.
# This is needed to distinguish them from Non-European ones.
Europe_merged$pl_counts <- 
  ifelse(is.na(Europe_merged$pl_counts) & Europe_merged$continent == "Europe",
         yes = 0,
         no = Europe_merged$pl_counts)

# B.2 -- PL map -----------------------------------------------------------

hist(Europe_merged$pl_counts)
summary(unique(Europe_merged$pl_counts))
table(Europe_merged$pl_counts)

# Choose univariate class intervals. 
# Check ?classIntervals, Details for various styles
cls <- classIntervals(var = Europe_merged$pl_counts,
                      n = 4,
                      style = "jenks") # change style if needed
cls
cls$brks

# Create a variable with desired legend labels
# https://stackoverflow.com/a/49190033/5193830
Europe_merged$pl_counts_label <-
  cut(Europe_merged$pl_counts, 
      breaks = c(0,1,2,10,30,41),
      labels = c("0", "1-2", "2-10", "10-30", "30-41"),
      include.lowest = TRUE,
      right = FALSE)

# makes color palettes
my_cols <- RColorBrewer::brewer.pal(n = 5, name = "YlGnBu") # "YlGnBu" , "BuGn"
# check your colors
scales::show_col(my_cols)


map_pl <- 
  tm_shape(shp = Europe_merged) +
  tm_polygons(col = "pl_counts_label", 
              textNA = "Non-European", 
              title  = "Pollen limitation studies",
              lwd = 0.5,
              palette = my_cols) +
  map_base_elements

save_tmap(map_pl, "output/map_pollen_limitation.tiff", 
          units = "cm", width = 8, height = 7, dpi = 1000)
