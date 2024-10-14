## Extract results of interest, write TAF output tables

## Before:
## After:

library(icesTAF)

mkdir("output")

sourceTAF("output_stage_2_fisheries.R")
sourceTAF("output_stage_2_aquaculture.R")
