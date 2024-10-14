library(icesTAF)
library(readxl)
library(dplyr)

mkdir("output")

source("utilities.R")

# read in data
secPress <- readRDS("data/fisheries_secPress.RDS")
pressEcoChar <- readRDS("data/fisheries_pressEcoChar.RDS")

# make stage 2 table
stage_2_fisheries <- make_stage_2(secPress, pressEcoChar)

write.taf(stage_2_fisheries, dir = "output", quote = TRUE)

# now make two files - one for North Sea and suroundings, one for mediterranean
