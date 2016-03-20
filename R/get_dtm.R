#' @importFrom hclustext get_dtm
#' @export



#' @export
#' @rdname get_dtm
#' @method get_dtm kmeans_cluster
get_dtm.kmeans_cluster <- function(x, ...){
    get_dtm(attributes(x)[["text_data_store"]][["data"]])
}


