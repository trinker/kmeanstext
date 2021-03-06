% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_dtm.R
\name{get_dtm}
\alias{get_dtm}
\alias{get_dtm.default}
\alias{get_dtm.kmeans_cluster}
\title{Get a \code{\link[tm]{DocumentTermMatrix}} Stored in a \code{kmeans_cluster} Object}
\usage{
get_dtm(x, ...)

\method{get_dtm}{default}(x, ...)

\method{get_dtm}{kmeans_cluster}(x, ...)
}
\arguments{
\item{x}{A \code{\link[kmeanstext]{kmeans_cluster}} object.}

\item{\ldots}{ignored.}
}
\value{
Returns a \code{\link[tm]{DocumentTermMatrix}}.
}
\description{
Extract the \code{\link[tm]{DocumentTermMatrix}} supplied to/produced by a
\code{\link[kmeanstext]{kmeans_cluster}} object.
}
\examples{
library(dplyr)

}

