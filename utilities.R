library(glue)

# clean up stage 1 tables
cleanup <- function(x) {
  cols <- 2:(ncol(x) - 2)
  rows <- 2:(nrow(x) - 2)

  rownames <- unname(unlist(x[rows, 1]))
  colnames <- unname(unlist(x[1, cols]))

  values <- unname(as.matrix(x[rows, cols]))

  values[] <- values %in% c("x", "X")
  mode(values) <- "logical"
  values[is.na(values)] <- FALSE

  fix <- function(y) {
    gsub("Introduction of non-indigenous species [(]NIS[)]", "Invasive species", y)
  }

  list(values = values, x = fix(rownames), y = fix(colnames))
}


process_tab <- function(x, col_names) {
  out <- cbind.data.frame(rep(x$x, length(x$y)), rep(x$y, each = length(x$x)))[c(x$values), ]
  names(out) <- col_names
  out
}

make_stage_2 <- function(secPress, pressEcoChar) {

  full_filtered <-
    right_join(
      process_tab(secPress, col_names = c("sector", "pressure")),
      process_tab(pressEcoChar, col_names = c("pressure", "ecoChar")),
      relationship = "many-to-many",
      by = join_by(pressure)
    )

  if (!all(complete.cases(full_filtered))) {
    warning("Some sectors not linked to a pressure - ecoChar combination")
  }

  stage_2 <- full_filtered[complete.cases(full_filtered),]

  stage_2$overlap <- character(nrow(stage_2))
  stage_2$frequency <- character(nrow(stage_2))
  stage_2$DoI <- character(nrow(stage_2))
  stage_2$confidence <- character(nrow(stage_2))
  stage_2$comments <- character(nrow(stage_2))

  # formulas
  i <- 1 + seq_along(stage_2$overlap)
  stage_2$Overlap.Score <-
      glue(
        '=@IF(ISBLANK(D{i}), 0, IF(D{i}="NO", 0, IF(D{i}="WE", 1, IF(D{i}="WP", 0.67, IF(D{i}="L", 0.33, IF(D{i}="S", 0.03, IF(D{i}="E", 0.01, "HELP")))))))'
      )

  stage_2$Frequency.Score <-
    glue(
        '=@IF(ISBLANK(E{i}), 0, IF(E{i}="R", 0.08, IF(E{i}="O", 0.33, IF(E{i}="C", 0.67, IF(E{i}="P", 1, "HELP")))))'
      )

  stage_2$DoI.Score <-
      glue(
        '=@IF(ISBLANK(F{i}), 0, IF(F{i}="L", 0.05, IF(F{i}="C", 0.2, IF(F{i}="A", 1, "HELP"))))'
      )

  stage_2$Impact.Risk.Score <-
      glue(
        "=PRODUCT(I{i}:K{i})"
      )

  stage_2$IR.relative.contribution <-
      glue(
        "=(L{i}/SUM(L{2}:L{nrow(stage_2)+1}))*100"
      )

  stage_2
}