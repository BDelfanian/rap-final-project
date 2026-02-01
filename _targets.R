# _targets.R

library(targets)
library(tarchetypes)

# IMPORTANT: Prepend user library so irisrap is found in non-interactive targets
.libPaths(c(Sys.getenv("R_LIBS_USER"), .libPaths()))

# Set packages for all targets
tar_option_set(packages = c("irisrap", "tidyverse", "ggplot2"))

# Define pipeline
list(
  tar_target(
    raw_iris,
    iris
  ),
  
  tar_target(
    cleaned_iris,
    clean_iris(raw_iris)
  ),
  
  tar_target(
    summary_table,
    summarize_by_species(cleaned_iris)
  ),
  
  tar_target(
    boxplot_obj,
    plot_iris_boxplots(cleaned_iris)
  ),
  
  tar_quarto(
    report,
    path = "quarto/iris-analysis-report.qmd",
    quiet = FALSE
  )
)