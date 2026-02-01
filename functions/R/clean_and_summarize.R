# functions/R/clean_and_summarize.R
# Pure functions for iris analysis

#' Clean and filter iris data
#' @param data data.frame (expected: iris)
#' @param species character vector of species to keep (default: all)
#' @return cleaned data.frame
clean_iris <- function(data, species = unique(data$Species)) {
  stopifnot(is.data.frame(data), "Species" %in% names(data))
  
  data |>
    dplyr::filter(Species %in% species) |>
    dplyr::mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))
}

#' Summarize measurements by species
#' @param data cleaned data.frame
#' @return summary tibble
summarize_by_species <- function(data) {
  stopifnot(is.data.frame(data), "Species" %in% names(data))
  
  data |>
    dplyr::group_by(Species) |>
    dplyr::summarise(
      across(where(is.numeric),
             list(mean = ~mean(., na.rm = TRUE),
                  sd   = ~sd(.,   na.rm = TRUE))),
      n = dplyr::n(),
      .groups = "drop"
    )
}

#' Plot boxplots faceted by measurement (pure ggplot)
#' @param data cleaned data.frame
#' @return ggplot object
plot_iris_boxplots <- function(data) {
  stopifnot(is.data.frame(data))
  
  data_long <- data |>
    tidyr::pivot_longer(
      cols = where(is.numeric),
      names_to = "measurement",
      values_to = "value"
    )
  
  ggplot2::ggplot(data_long, ggplot2::aes(x = Species, y = value, fill = Species)) +
    ggplot2::geom_boxplot() +
    ggplot2::facet_wrap(~ measurement, scales = "free_y") +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "Iris Measurements by Species",
                  subtitle = "Boxplots of Sepal/Petal dimensions")
}