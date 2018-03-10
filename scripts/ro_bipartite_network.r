#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Create bipartite web and network 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# Load packages -----------------------------------------------------------

library(bipartite)

# Load customized bipartite plotting functions.
# These functions have some additional flexibility to adjust graphical parameters.
source("https://raw.githubusercontent.com/valentinitnelav/bipartite/master/R/plotweb.R")
source("https://raw.githubusercontent.com/valentinitnelav/bipartite/master/R/visweb.R")


# Read & prepare data -----------------------------------------------------

network <- read.csv("data/Rom_Trans.csv")

network2 <- network[, -1]
rownames(network2) <- network[, 1]


# visweb ------------------------------------------------------------------

# Open a PDF graphic device with desired parameters
pdf(file = "output/web_1.pdf",
    width = 12/2.54, 
    height = 8/2.54, 
    pointsize = 8)

par(oma = c(bottom = 0, left = 0, top = 0, right = 0),
    mar = c(bottom = 0, left = 0, top = 0, right = 0),
    lwd = 0.01)

visweb(
  web = network2,
  type = "nested",
  labsize = 1.65,
  square = "black",
  xlabel = "Pollinators",
  ylabel = "Plants",
  # Adjust axis labels side
  pred.axis.side = 3, 
  # Adjust position of axis labels:
  pred.axis.pos = -7.6, 
  prey.axis.pos = -2.2,
  # Adjust position of axis titles:
  pred.axis.title.line = -3.5, 
  prey.axis.title.line = -0.8,
  # increase axis title size if needed:
  axis.title.cex = 1, 
  # Adjusts the matrix left-right:
  x.lim = c(-4, ncol(network2)-5) 
)

# close the device
dev.off()


# plotweb -----------------------------------------------------------------

# Open a PDF graphic device with desired parameters
pdf(file = "output/network_1.pdf",
    width = 12/2.54, 
    height = 7/2.54, 
    pointsize = 8)

par(oma = c(bottom = 0, left = 0, top = 0, right = 0),
    mar = c(bottom = 0, left = 0, top = 0, right = 0),
    lwd = 0.01)

plotweb(
  web = network2,
  labsize.low = 0.6,
  labsize.high = 0.3,
  y.lim = c(0.33, 1.71), # y.lim = c(0.285, 2.12),
  x.lim = c(0.075, 2.52),
  ybig = 0.1, # vertical distance between upper and lower boxes
  y.width.low  = 0.05, # width of lower boxes
  y.width.high = 0.05, # width of upper boxes
  text.rot.low = 90,
  text.rot.high = 90
)

# close the device
dev.off()
