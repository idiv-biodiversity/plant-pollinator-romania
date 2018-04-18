#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Create bipartite web plot
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# Load packages -----------------------------------------------------------

library(bipartite)

# Load customized web plotting function.
# It has some additional flexibility to adjust graphical parameters.
source("https://raw.githubusercontent.com/valentinitnelav/bipartite_webs/master/R/plot_grid.R")


# Read & prepare data -----------------------------------------------------

# Check first for duplicates in names using the script network_check_double_naming.r

network <- read.csv("data/Rom_Trans_cor_new.csv")

# Prepare matrix of interactions
network2 <- network[, -1]
rownames(network2) <- network[, 1]
# In column names (pollinators), substitute dot/multiple dots with space,
# so that the dots do not trickle down to the labels in the web graph.
colnames(network2) <- gsub(pattern = "\\.+",
                           replacement = " ",
                           x = colnames(network2))


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
  web = network2,
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
  x.lim = c(-3, ncol(network2)-4.7) 
)

# close the device
dev.off()
