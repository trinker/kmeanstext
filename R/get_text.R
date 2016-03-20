#' @importFrom hclustext get_text
#' @export
#' @examples
#' library(dplyr)
#'
#' presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     hierarchical_cluster(k=55) %>%
#'     get_text() %>%
#'     head()


#' @export
#' @rdname get_text
#' @method get_text hierarchical_cluster
get_text.kmeans_cluster <- function(x, ...){
    get_text(attributes(x)[["text_data_store"]][["data"]])
}

