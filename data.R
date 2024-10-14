## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)

mkdir("data")

source.taf("data_fisheries.R")
source.taf("data_aquaculture.R")

