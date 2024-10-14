library(icesTAF)
library(readxl)
library(dplyr)

mkdir("data")

source("utilities.R")

# read in data
file <- taf.data.path("Linkage_Framework_Stage_1-aquaculture.xlsx")
secPress_raw <- read_xlsx(file, sheet = "SecPress", col_names = FALSE)
pressEcoChar_raw <- read_xlsx(file, sheet = "PressEcoChar", col_names = FALSE)

# clean up
secPress <- cleanup(secPress_raw[-c(1, 3, nrow(secPress_raw) - 3:0), -2])
pressEcoChar <- cleanup(pressEcoChar_raw[-2, -c(1, 3)])

# check names
all(secPress$y == pressEcoChar$x)

saveRDS(secPress, "data/aquaculture_secPress.RDS")
saveRDS(pressEcoChar, "data/aquaculture_pressEcoChar.RDS")
