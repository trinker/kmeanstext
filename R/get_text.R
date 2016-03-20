#' Get a Text Stored in Various Objects
#'
#' Extract the text supplied to the
#' \code{\link[kmeanstext]{kmeans_cluster}} object.
#'
#' @param x A \code{\link[kmeanstext]{kmeans_cluster}} object.
#' @param \ldots ignored.
#' @return Returns a vector or list of text strings.
#' @export
#' @rdname get_text
#' @examples
#' library(dplyr)
#'
# presidential_debates_2012 %>%
#     with(data_store(dialogue)) %>%
#     kmeans_cluster() %>%
#     get_text() %>%
#     head()
get_text <- function(x, ...){
    UseMethod("get_text")
}

#' @export
#' @rdname get_text
#' @method get_text kmeans_cluster
get_text.kmeans_cluster <- function(x, ...){
    get_text(attributes(x)[["text_data_store"]][["data"]])
}




#' @export
#' @rdname get_text
#' @method get_text default
get_text.default <- function(x, ...){
    hclustext::get_text(x, ...)
}

