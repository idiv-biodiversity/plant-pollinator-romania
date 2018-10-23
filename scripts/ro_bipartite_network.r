# /////////////////////////////////////////////////////////////////////////
#
# Create bipartite web plot.
# The final graph was further edited in Inkscape (https://inkscape.org/).
#
# /////////////////////////////////////////////////////////////////////////


# Load packages -----------------------------------------------------------

library(bipartite)

# Clean global environment
rm(list = ls(all.names = TRUE))

# Load customized web plotting function.
# It has some additional flexibility to adjust graphical parameters.
source("https://raw.githubusercontent.com/valentinitnelav/bipartite_webs/master/R/plot_grid.R")


# Read & prepare data -----------------------------------------------------

network <- read.csv("data/Supporting_Information_S5.csv")

# ...............................................

# Defensively check for duplicates in species names.

# Check for duplicates in Plants.
which(table(network$Plants) != 1)
# integer(0) indicates no duplicates

# Check for duplicates in column names (Pollinators)
# First, substitute dot/multiple dots with space. This is also useful further as
# labels in the network graph.
colnames(network) <- gsub(pattern = "\\.+", replacement = " ", x = colnames(network))
# which name appears more than once?
which(table(colnames(network)) != 1)
# integer(0) indicates no duplicates

# ...............................................

# Prepare matrix of interactions
network4graph <- network[, -1]
rownames(network4graph) <- network[, 1]


# visweb ------------------------------------------------------------------

# Open a PDF graphic device with desired parameters
pdf(file = paste0("Output/web_graph_", format(Sys.time(), "%Y-%m-%d-%Hh%Mm%Ss"), ".pdf"),
    width = 20/2.54, 
    height = 10/2.54, 
    pointsize = 8)

par(oma = c(bottom = 0, left = 0, top = 0, right = 0),
    mar = c(bottom = 0, left = 0, top = 0, right = 0),
    lwd = 0.1)

# Note that:
# pred - Pollinators
# prey - Plants
plot_grid(
  web = network4graph,
  type = "nested",
  labsize = 2.7,
  square = "black",
  xlabel = "Pollinators",
  ylabel = "Plants",
  # Adjust axis labels side
  pred.axis.side = 3, 
  # Adjust position of axis labels:
  pred.axis.pos = -7.9,
  prey.axis.pos = -3.3,
  # Adjust position of axis titles:
  pred.axis.title.line = -2.5, 
  prey.axis.title.line = -0.8,
  # increase axis title size if needed:
  axis.title.cex = 1, 
  # Adjusts the matrix left-right:
  x.lim = c(-3, ncol(network4graph)-4.7) 
)

# close the device
dev.off()
