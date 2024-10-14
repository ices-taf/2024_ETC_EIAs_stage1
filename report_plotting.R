library(icesTAF)
library(igraph)

mkdir("report")

# read data
secPress <- readRDS("data/fisheries_secPress.RDS")
pressEcoChar <- readRDS("data/fisheries_pressEcoChar.RDS")

# make a graph
d1 <- process_tab(secPress, col_names = c("sector", "pressure"))
d2 <- process_tab(pressEcoChar, col_names = c("pressure", "ecoChar"))

names(d1) <- c("from", "to")
names(d2) <- c("from", "to")


g <- graph_from_data_frame(rbind(d1, d2), directed = TRUE, vertices = NULL)

library(ggplot2)
library(ggraph)
ggraph(g)


plot(g)
