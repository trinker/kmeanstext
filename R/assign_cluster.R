#' Cluster Assignment of Documents/Text Elements
#'
#' Cluster assignment of documents/text elements.
#'
#' @param x a \code{kmeans_cluster} object.
#' @param \ldots ignored.
#' @return Returns an \code{assign_cluster} object; a named vector of cluster
#' assignments with documents as names.  The object also contains the original
#' \code{data_storage} object.
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
# kmeans_cluster(x) %>%
#     plot(h=.7, lwd=2)
#
# kmeans_cluster(x) %>%
#     assign_cluster(h=.7)
#
# kmeans_cluster(x, method="complete") %>%
#     plot(k=6)
#
# kmeans_cluster(x) %>%
#     assign_cluster(k=6)
#
#
# x2 <- presidential_debates_2012 %>%
#     with(data_store(dialogue)) %>%
#     kmeans_cluster()
#
# ca <- assign_cluster(x2, k = 55)
# summary(ca)
#
# ## split text into clusters
# get_text(ca)
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

#content here

    class(out) <- c("assign_cluster", class(out))

    attributes(out)[["data_store"]] <- attributes(x)[["text_data_store"]]
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





