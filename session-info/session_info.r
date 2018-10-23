# /////////////////////////////////////////////////////////////////////////
#
# (OPTIONAL) Store R packages information.
# This shows how the files: "/session-info/packages.csv" & 
# "session-info/sessionInfo.txt" were created
# This script was run after all needed packages were loaded/attached.
#
# /////////////////////////////////////////////////////////////////////////


# Store R session information in "/packages/sessionInfo.txt'
sink(file = "session-info/sessionInfo.txt")
sessionInfo()
sink()


# Store R package information in "/session-info/packages.csv"
# Store as table with three columns: package name, version, and type.
r_session <- sessionInfo()

pk   <- c(r_session$basePkgs,
          names(r_session$otherPkgs),
          names(r_session$loadedOnly))
ver  <- sapply(pk, getNamespaceVersion)
type <- rep(x = c("base_package", 
                  "attached_package", 
                  "loaded_not_attached"),
            times = c(length(r_session$basePkgs),
                      length(r_session$otherPkgs),
                      length(r_session$loadedOnly)))

df <- data.frame(package = pk, 
                 version = ver,
                 type = type)

write.csv(df, file = "session-info/packages.csv", row.names = FALSE)