#' @importFrom hclustext get_terms
#' @export
#' @examples
#' library(dplyr)
#'
#' myterms <- presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     kmeans_cluster(k = 55) %>%
#'     assign_cluster() %>%
#'     get_terms()
