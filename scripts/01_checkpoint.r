# /////////////////////////////////////////////////////////////////////////
#
# Create a checkpoint at "2018-02-13".
#
# This should guarantee the same versions of the packages as they existed at the
# specified point in time.
# 
# Scans for packages in the project folder and its subfolder. It scans all R code
# (.R, .Rmd, and .Rpres files) for `library()` and `require()` statements. Then
# creates a local library into which it installs a copy of the packages required
# in the project as they existed on CRAN at the specified snapshot date. See
# details with ?checkpoint after you load library(checkpoint), or here:
# https://cran.r-project.org/web/packages/checkpoint/vignettes/checkpoint.html
#
# Warning: Installing older versions of the packages in the .checkpoint local
# library, may take up to 600 MB of space.
#
# /////////////////////////////////////////////////////////////////////////

library(checkpoint) # checkpoint, version 0.4.3

checkpoint(snapshotDate = "2018-02-13")

# Check that library path is set to ~/.checkpoint/2018-02-13/ ...
.libPaths()
grepl(pattern = "\\.checkpoint/2018-02-13/", x = .libPaths()[1]) # should be TRUE


# Optional checks ---------------------------------------------------------

# Check that CRAN mirror is set to MRAN snapshot
getOption("repos")
# At first run, after installing the packages, should see something like:
#                                                                            nowosaddrat 
# "https://mran.microsoft.com/snapshot/2018-02-13"     "https://nowosad.github.io/drat/" 

# Check which packages are installed in checkpoint library
installed.packages(.libPaths()[1])[, "Package"]

# Experimental - use unCheckpoint() to reset .libPaths to the default user library. 
# Note that this does not undo any of the other side-effects. Specifically, all
# loaded packages remain loaded, and the value of getOption("repos") remains
# unchanged. See details with ?unCheckpoint
