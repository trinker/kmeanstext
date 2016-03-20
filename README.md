kmeanstext   [![Follow](https://img.shields.io/twitter/follow/tylerrinker.svg?style=social)](https://twitter.com/intent/follow?screen_name=tylerrinker)
============


[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build
Status](https://travis-ci.org/trinker/kmeanstext.svg?branch=master)](https://travis-ci.org/trinker/kmeanstext)
[![Coverage
Status](https://coveralls.io/repos/trinker/kmeanstext/badge.svg?branch=master)](https://coveralls.io/r/trinker/kmeanstext?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/kmeanstext_logo/r_kmeanstext.png" width="150" alt="readability Logo">

**kmeanstext** is a collection of optimized tools for clustering text
data via kmeans clustering. There are many great R [clustering
tools](https://cran.r-project.org/web/views/Cluster.html) to locate
topics within documents. Kmeans clustering is a popular method for topic
extraction. This package builds upon my
[hclustext](https://github.com/trinker/hclustext) package to extend the
**hclustext** package framework to kmeans. One major difference
between the two techniques is that with hierchical clustering the number
of topics is specified after thte model has been fitted, whereas kmeans
requires the k topics to be specified before the model is fit.
Additionally, kmeans uses a random start seed, the results may vary each
time a model is fit. Additionally, Euclidian distance is typically used
in a kmeans algorithm, where as any distance metric may be passed to a
hierachical clustering fit.

The general idea is that we turn the documents into a matrix of words.
After this we weight the terms by importance using
[tf-idf](http://nlp.stanford.edu/IR-book/html/htmledition/tf-idf-weighting-1.html).
This helps the more salient words to rise to the top. The user then
selects k clusters (topics) and runs the model. The model iteratively
shuffels centers and assigns documents to the clusters based on minimal
dsitance of a document to center. Each run uses the recalculated mean
centroid of the prior clusters as a starting point for the current
iteration's centroids. Once the centroids have stabalized the model has
converged at k topics. The user then may extract the clusters from the
fit, providing a grouping for documents with similar important text
features.


Table of Contents
============

-   [Functions](#functions)
-   [Installation](#installation)
-   [Contact](#contact)
-   [Demonstration](#demonstration)
    -   [Load Packages and Data](#load-packages-and-data)

Functions
============


The main functions, task category, & descriptions are summarized in the
table below:

<table style="width:161%;">
<colgroup>
<col width="34%" />
<col width="23%" />
<col width="102%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Category</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>data_store</code></td>
<td align="left">data structure</td>
<td align="left"><strong>kmeanstext</strong>'s data structure (list of dtm + text)</td>
</tr>
<tr class="even">
<td align="left"><code>kmeans_cluster</code></td>
<td align="left">cluster fit</td>
<td align="left">Fits a kmeans cluster model</td>
</tr>
<tr class="odd">
<td align="left"><code>assign_cluster</code></td>
<td align="left">assignment</td>
<td align="left">Assigns cluster to document/text element</td>
</tr>
<tr class="even">
<td align="left"><code>get_text</code></td>
<td align="left">extraction</td>
<td align="left">Get text from various <strong>kmeanstext</strong> objects</td>
</tr>
<tr class="odd">
<td align="left"><code>get_dtm</code></td>
<td align="left">extraction</td>
<td align="left">Get <code>tm::DocumentTermMatrix</code> from various <strong>kmeanstext</strong> objects</td>
</tr>
<tr class="even">
<td align="left"><code>get_removed</code></td>
<td align="left">extraction</td>
<td align="left">Get removed text elements from various <strong>kmeanstext</strong> objects</td>
</tr>
<tr class="odd">
<td align="left"><code>get_terms</code></td>
<td align="left">extraction</td>
<td align="left">Get clustered weighted important terms from an <strong>assign_cluster</strong> object</td>
</tr>
<tr class="even">
<td align="left"><code>get_documents</code></td>
<td align="left">extraction</td>
<td align="left">Get clustered documents from an <strong>assign_cluster</strong> object</td>
</tr>
</tbody>
</table>

Installation
============

To download the development version of **kmeanstext**:

Download the [zip
ball](https://github.com/trinker/kmeanstext/zipball/master) or [tar
ball](https://github.com/trinker/kmeanstext/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh(
        "trinker/textshape", 
        "trinker/gofastr", 
        "trinker/termco",    
        "trinker/hclusttext",    
        "trinker/kmeanstext"
    )

Contact
=======

You are welcome to:    
- submit suggestions and bug-reports at: <https://github.com/trinker/kmeanstext/issues>    
- send a pull request on: <https://github.com/trinker/kmeanstext/>    
- compose a friendly e-mail to: <tyler.rinker@gmail.com>    

Demonstration
=============

Load Packages and Data
----------------------

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(kmeanstext, dplyr, textshape, ggplot2, tidyr)

    ## Warning in p_install(package, character.only = TRUE, ...): kmeanstext

    ## Warning in library(package, lib.loc = lib.loc, character.only = TRUE,
    ## logical.return = TRUE, : there is no package called 'kmeanstext'

    ## Warning in pacman::p_load(kmeanstext, dplyr, textshape, ggplot2, tidyr): Failed to install/load:
    ## kmeanstext

    data(presidential_debates_2012)
