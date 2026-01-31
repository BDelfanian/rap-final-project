# Pure functions for iris analysis

#' Clean and filter iris data
#' @param data data.frame (iris)
#' @param species_filter character vector of species to keep (default all)
#' @return cleaned data.frame
clean_iris <- function(data, species_filter = unique(data$Species)) {
  data |>
    dplyr::filter(Species %in% species_filter) |>
    dplyr::mutate(across(where(is.numeric), ~replace(., is.na(.), mean(., na.rm = TRUE))))  # simple NA imputation
}

#' Summarize by species
#' @param data cleaned data.frame
#' @return summary tibble with mean/sd/count
summarize_by_species <- function(data) {
  data |>
    dplyr::group_by(Species) |>
    dplyr::summarise(
      across(where(is.numeric),
             list(mean = ~mean(., na.rm = TRUE),
                  sd = ~sd(., na.rm = TRUE))),
      count = dplyr::n(),
      .groups = "drop"
    )
}

#' Create ggplot line plot (facet by measurement)
#' @param data cleaned data (long format if needed)
#' @return ggplot object
plot_measurements <- function(data) {
  data_long <- data |>
    tidyr::pivot_longer(cols = where(is.numeric), names_to = "measurement", values_to = "value")

  ggplot2::ggplot(data_long, ggplot2::aes(x = Species, y = value, fill = Species)) +
    ggplot2::geom_boxplot() +
    ggplot2::facet_wrap(~measurement, scales = "free_y") +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "Iris Measurements by Species")
}