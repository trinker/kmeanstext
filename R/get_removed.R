#' @importFrom hclustext get_removed
#' @export

#' @export
#' @rdname get_removed
#' @method get_removedkmeans_cluster
get_removed.kmeans_cluster <- function(x, ...){
    get_removed(attributes(x)[["text_data_store"]][["data"]])
}




