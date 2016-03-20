#' Get a Text Stored in a \code{kmeans_cluster} Object
#'
#' Extract the text supplied to the
#' \code{\link[hclustext]{kmeans_cluster}} object.
#'
#' @param x A \code{\link[hclustext]{kmeans_cluster}} object.
#' @param \ldots ignored.
#' @return Returns a vector of text strings.
#' @export
#' @rdname get_removed
#' @examples
#' library(dplyr)
#'
#' presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     kmeans_cluster() %>%
#'     get_removed()
get_removed <- function(x, ...){
    UseMethod("get_removed")
}

#' @export
#' @rdname get_removed
#' @method get_removed default
get_removed.default <- function(x, ...){
    hclustext::get_removed(x, ...)
}

#' @export
#' @rdname get_removed
#' @method get_removed kmeans_cluster
get_removed.kmeans_cluster <- function(x, ...){
    get_removed(attributes(x)[["text_data_store"]][["data"]])
}




