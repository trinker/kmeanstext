#' Get a \code{\link[tm]{DocumentTermMatrix}} Stored in a \code{kmeans_cluster} Object
#'
#' Extract the \code{\link[tm]{DocumentTermMatrix}} supplied to/produced by a
#' \code{\link[hclustext]{kmeans_cluster}} object.
#'
#' @param x A \code{\link[hclustext]{kmeans_cluster}} object.
#' @param \ldots ignored.
#' @return Returns a \code{\link[tm]{DocumentTermMatrix}}.
#' @export
#' @rdname get_dtm
#' @examples
#' library(dplyr)
#'
# presidential_debates_2012 %>%
#     with(data_store(dialogue)) %>%
#     kmeans_cluster() %>%
#     get_dtm()
get_dtm <- function(x, ...){
    UseMethod("get_dtm")
}

#' @export
#' @rdname get_dtm
#' @method get_dtm default
get_dtm.default <- function(x, ...){
    hclustext::get_dtm(x, ...)
}


#' @export
#' @rdname get_dtm
#' @method get_dtm kmeans_cluster
get_dtm.kmeans_cluster <- function(x, ...){
    get_dtm(attributes(x)[["text_data_store"]][["data"]])
}




