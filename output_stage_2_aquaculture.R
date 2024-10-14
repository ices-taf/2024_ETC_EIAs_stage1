library(icesTAF)
library(readxl)
library(dplyr)

mkdir("output")

source("utilities.R")

# read in data
secPress <- readRDS("data/aquaculture_secPress.RDS")
pressEcoChar <- readRDS("data/aquaculture_pressEcoChar.RDS")

# make stage 2 table
stage_2_aquaculture <- make_stage_2(secPress, pressEcoChar)

write.taf(stage_2_aquaculture, dir = "output", quote = TRUE)
