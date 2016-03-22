#' Cluster Assignment of Documents/Text Elements
#'
#' Cluster assignment of documents/text elements.
#'
#' @param x a \code{kmeans_cluster} object.
#' @param \ldots ignored.
#' @return Returns an \code{assign_cluster} object; a named vector of cluster
#' assignments with documents as names.  The object also contains the original
#' \code{data_storage} object and a \code{join} function.  \code{join} is a 
#' function (a closure) that captures information about the \code{assign_cluster}
#' that makes rejoining to the original data set simple.  The user simply 
#' supplies the original data set as an argument to \code{join} 
#' (\code{attributes(FROM_ASSIGN_CLUSTER)$join(ORIGINAL_DATA)}).
#' @rdname assign_cluster
#' @export
#' @examples
#' library(dplyr)
#'
#' x <- with(
#'     presidential_debates_2012,
#'     data_store(dialogue, paste(person, time, sep = "_"))
#' )
#'
#' kmeans_cluster(x, k=6) %>%
#'     assign_cluster()
#'
#' x2 <- presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     kmeans_cluster(k = 55)
#'
#' ca <- assign_cluster(x2)
#' summary(ca)
#' 
#' ## add to original data
#' attributes(ca)$join(presidential_debates_2012)
#' 
#' ## split text into clusters
#' get_text(ca)
assign_cluster <- function(x, ...){
     UseMethod("assign_cluster")
}

#' @export
#' @rdname assign_cluster
#' @method assign_cluster default
assign_cluster.default <- function(x, ...){

    hclustext::assign_cluster(x=x, ...)

}


#' @export
#' @rdname assign_cluster
#' @method assign_cluster kmeans_cluster
assign_cluster.kmeans_cluster <- function(x, ...){

    out <- x[['cluster']]

    orig <- attributes(x)[['text_data_store']][['data']]
    lens <- length(orig[['text']]) + length(orig[['removed']])    
    
    class(out) <- c("assign_cluster_kmeans","assign_cluster", class(out))

    attributes(out)[["data_store"]] <- attributes(x)[["text_data_store"]]
    attributes(out)[["model"]] <- x
    attributes(out)[["join"]] <- function(x) {
        
        if (nrow(x) != lens) warning(sprintf("original data had %s elements, `x` has %s", lens, nrow(x)))
        
        dplyr::select(
            dplyr::left_join(
                dplyr::mutate(x, id_temporary = as.character(1:n())),
                dplyr::tbl_df(textshape::bind_vector(out, 'id_temporary', 'cluster') )
            ), 
            -id_temporary
        )
    }      
    out

}


#' Prints an assign_cluster Object
#'
#' Prints an assign_cluster object
#'
#' @param x An assign_cluster object.
#' @param \ldots ignored.
#' @method print assign_cluster
#' @export
print.assign_cluster <- function(x, ...){
    print(stats::setNames(as.integer(x), names(x)))
}


#' Summary of an assign_cluster Object
#'
#' Summary of an assign_cluster object
#'
#' @param object An assign_cluster object.
#' @param plot logical.  If \code{TRUE} an accompanying bar plot is produced a
#' well.
#' @param \ldots ignored.
#' @method summary assign_cluster
#' @export
summary.assign_cluster <- function(object, plot = TRUE, ...){
    count <- NULL
    out <- textshape::bind_table(table(as.integer(object)), "cluster", "count")
    if (isTRUE(plot)) print(termco::plot_counts(as.integer(object), item.name = "Cluster"))
    dplyr::arrange(as.data.frame(out), dplyr::desc(count))
}





