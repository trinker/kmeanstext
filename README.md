kmeanstext   [![Follow](https://img.shields.io/twitter/follow/tylerrinker.svg?style=social)](https://twitter.com/intent/follow?screen_name=tylerrinker)
============


[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
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
**hclustext** package framework to kmeans. One major difference between
the two techniques is that with hierchical clustering the number of
topics is specified after thte model has been fitted, whereas kmeans
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
    -   [Data Structure](#data-structure)
    -   [Fit the Model: kmeans Cluster](#fit-the-model-kmeans-cluster)
    -   [Assigning Clusters](#assigning-clusters)
        -   [Cluster Loading](#cluster-loading)
        -   [Cluster Text](#cluster-text)
        -   [Cluster Frequent Terms](#cluster-frequent-terms)
        -   [Clusters, Terms, and Docs Plot](#clusters-terms-and-docs-plot)
        -   [Cluster Documents](#cluster-documents)
    -   [Putting it Together](#putting-it-together)

Functions
============


The main functions, task category, & descriptions are summarized in the
table below:

<table style="width:162%;">
<colgroup>
<col width="34%" />
<col width="23%" />
<col width="104%" />
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
<td align="left">Extract clusters for document/text element</td>
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

    data(presidential_debates_2012)

Data Structure
--------------

The data structure for **kmeanstext** is very specific. The
`data_storage` produces a `DocumentTermMatrix` which maps to the
original text. The empty/removed documents are tracked within this data
structure, making subsequent calls to cluster the original documents and
produce weighted important terms more robust. Making the `data_storage`
object is the first step to analysis.

We can give the `DocumentTermMatrix` rownames via the `doc.names`
argument. If these names are not unique they will be combined into a
single document as seen below. Also, if you want to do stemming, minimum
character length, stopword removal or such this is when/where it's done.

    ds <- with(
        presidential_debates_2012,
        data_store(dialogue, doc.names = paste(person, time, sep = "_"))
    )

    ds

    ## Text Elements      : 10
    ## Elements Removed   : 0
    ## Documents          : 10
    ## Terms              : 3,369
    ## Non-/sparse entries: 7713/25977
    ## Sparsity           : 77%
    ## Maximal term length: 16

Fit the Model: kmeans Cluster
-----------------------------

Next we can fit a kmeans cluster model to the `data_store` object via
`kmeans_cluster`. Note that, unlike **hclustext**'s
`hierarchical_cluster`, we must provide the `k` (number of topics) to
the model.

By default `kmeans_cluster` uses an approximation of `k` based on Can &
Ozkarahan's (1990) formula (*m* \* *n*)/*t* where *m* and *n* are the
dimensions of the matrix and *t* is the length of the non-zero elements
in matrix *A*.

-   Can, F., Ozkarahan, E. A. (1990). Concepts and effectiveness of the
    cover-coefficient-based clustering methodology for text databases.
    *ACM Transactions on Database Systems 15* (4): 483.
    <doi:10.1145/99935.99938>

There are other means of determining `k` as well. See Ben Marwic's
[StackOverflow post](http://stackoverflow.com/a/15376462/1000343) for a
detailed exploration.

    set.seed(100)
    myfit <- kmeans_cluster(ds, k=6)

    str(myfit)

    ## List of 9
    ##  $ cluster     : Named int [1:10] 4 3 2 1 1 6 2 1 1 5
    ##   ..- attr(*, "names")= chr [1:10] "CROWLEY_time 2" "LEHRER_time 1" "OBAMA_time 1" "OBAMA_time 2" ...
    ##  $ centers     : num [1:6, 1:3369] 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:6] "1" "2" "3" "4" ...
    ##   .. ..$ : chr [1:3369] "good" "evening" "from" "hofstra" ...
    ##  $ totss       : num 0.00897
    ##  $ withinss    : num [1:6] 0.00097 0.000458 0 0 0 ...
    ##  $ tot.withinss: num 0.00143
    ##  $ betweenss   : num 0.00754
    ##  $ size        : int [1:6] 4 2 1 1 1 1
    ##  $ iter        : int 2
    ##  $ ifault      : int 0
    ##  - attr(*, "class")= chr [1:2] "kmeans_cluster" "kmeans"
    ##  - attr(*, "text_data_store")=<environment: 0x000000004ca2cb20>

Assigning Clusters
------------------

The `assign_cluster` function allows the user to extract the clusters
and the documents they are assigned to. Unlike **hclustext**'s
`assign_cluster`, the **kmeanstext** version as no `k` argument and is
merely extracting the cluster assignments from the model.

    ca <- assign_cluster(myfit)

    ca

    ##   CROWLEY_time 2    LEHRER_time 1     OBAMA_time 1     OBAMA_time 2 
    ##                4                3                2                1 
    ##     OBAMA_time 3  QUESTION_time 2    ROMNEY_time 1    ROMNEY_time 2 
    ##                1                6                2                1 
    ##    ROMNEY_time 3 SCHIEFFER_time 3 
    ##                1                5

### Cluster Loading

To check the number of documents loading on a cluster there is a
`summary` method for `assign_cluster` which provides a descending data
frame of clusters and counts. Additionally, a horizontal bar plot shows
the document loadings on each cluster.

    summary(ca)

![](inst/figure/unnamed-chunk-7-1.png)

    ##   cluster count
    ## 1       1     4
    ## 2       2     2
    ## 3       3     1
    ## 4       4     1
    ## 5       5     1
    ## 6       6     1

### Cluster Text

The user can grab the texts from the original documents grouped by
cluster using the `get_text` function. Here I demo a 40 character
substring of the document texts.

    get_text(ca) %>%
        lapply(substring, 1, 40)

    ## $`1`
    ## [1] "Jeremy, first of all, your future is bri"
    ## [2] "Well, my first job as commander in chief"
    ## [3] "Thank you, Jeremy. I appreciate your you"
    ## [4] "Thank you, Bob. And thank you for agreei"
    ## 
    ## $`2`
    ## [1] "Jim, if I if I can just respond very qui"
    ## [2] "What I support is no change for current "
    ## 
    ## $`3`
    ## [1] "We'll talk about specifically about heal"
    ## 
    ## $`4`
    ## [1] "Good evening from Hofstra University in "
    ## 
    ## $`5`
    ## [1] "Good evening from the campus of Lynn Uni"
    ## 
    ## $`6`
    ## [1] "Mister President, Governor Romney, as a "

### Cluster Frequent Terms

As with many topic clustering techniques, it is useful to get the to
salient terms from the model. The `get_terms` function uses the
`centers` from the `kmeans` output. Notice the absence of clusters 1 &
2. This is a result of only a single document included in each of the
clusters.

    get_terms(ca, .008)

    ## $`1`
    ## NULL
    ## 
    ## $`2`
    ## NULL
    ## 
    ## $`3`
    ##       term      weight
    ## 1  minutes 0.017257547
    ## 2   minute 0.015156189
    ## 3  segment 0.009093713
    ## 4 repealed 0.009093713
    ## 5    views 0.008673442
    ## 6  improve 0.008673442
    ## 
    ## $`4`
    ##     term      weight
    ## 1 mister 0.008925013
    ## 
    ## $`5`
    ##      term     weight
    ## 1 segment 0.01446184
    ## 
    ## $`6`
    ##            term     weight
    ## 1    department 0.01709397
    ## 2           chu 0.01139598
    ## 3        stated 0.01139598
    ## 4             w 0.01139598
    ## 5 misperception 0.01139598

The `min.weight` hyperparmeter sets the lower bound on the `centers`
value to accept. If you don't get any terms you may want to lower this.
Likewise, this parameter (and lowering `nrow`) can be raised to
eliminate noise.

    get_terms(ca, .002)

    ## $`1`
    ##   term      weight
    ## 1 sure 0.002350754
    ## 
    ## $`2`
    ##          term      weight
    ## 1   insurance 0.005614675
    ## 2      health 0.003503115
    ## 3    medicare 0.003142618
    ## 4  regulation 0.003033859
    ## 5        care 0.002762083
    ## 6       banks 0.002694781
    ## 7       costs 0.002114392
    ## 8        dodd 0.002007181
    ## 9       frank 0.002007181
    ## 10       they 0.002006281
    ## 
    ## $`3`
    ##            term      weight
    ## 1       minutes 0.017257547
    ## 2        minute 0.015156189
    ## 3       segment 0.009093713
    ## 4      repealed 0.009093713
    ## 5         views 0.008673442
    ## 6       improve 0.008673442
    ## 7       federal 0.007832898
    ## 8          yeah 0.006802737
    ## 9      specific 0.006062475
    ## 10      quality 0.006062475
    ## 11         left 0.006062475
    ## 12   statements 0.006062475
    ## 13         view 0.005177264
    ## 14         case 0.005177264
    ## 15      elected 0.005177264
    ## 16         care 0.004810480
    ## 17         role 0.004810480
    ## 18       mister 0.004702366
    ## 19    gentlemen 0.004535158
    ## 20         toss 0.004535158
    ## 21      quickly 0.004535158
    ## 22          sir 0.004535158
    ## 23     vouchers 0.004336721
    ## 24         wait 0.004336721
    ## 25      briefly 0.004336721
    ## 26     argument 0.004336721
    ## 27      explain 0.004336721
    ## 28  fundamental 0.004336721
    ## 29 government's 0.004336721
    ## 30          pod 0.004336721
    ## 31  legislative 0.004336721
    ## 32    functions 0.004336721
    ## 33    paralysis 0.004336721
    ## 34     gridlock 0.004336721
    ## 35           re 0.004336721
    ## 36           na 0.004336721
    ## 37     thursday 0.004336721
    ## 38      october 0.004336721
    ## 39     eleventh 0.004336721
    ## 40       centre 0.004336721
    ## 41     danville 0.004336721
    ## 42     kentucky 0.004336721
    ## 43       lehrer 0.004336721
    ## 44       health 0.003916449
    ## 45        clear 0.003916449
    ## 46      closing 0.003848384
    ## 47   difference 0.003848384
    ## 48          act 0.003451509
    ## 49       repeal 0.003451509
    ## 50         dodd 0.003451509
    ## 51        frank 0.003451509
    ## 52       public 0.003451509
    ## 53       excuse 0.003451509
    ## 54       voters 0.003031238
    ## 55      answers 0.003031238
    ## 56         coin 0.003031238
    ## 57 specifically 0.003031238
    ## 58    excessive 0.003031238
    ## 59     directly 0.003031238
    ## 60        segue 0.003031238
    ## 61    specifics 0.003031238
    ## 62       barely 0.003031238
    ## 63        grade 0.003031238
    ## 64    governing 0.003031238
    ## 65     remember 0.003031238
    ## 66       result 0.003031238
    ## 67     partisan 0.003031238
    ## 68       denver 0.003031238
    ## 69    obamacare 0.002886288
    ## 70       romney 0.002687066
    ## 71    education 0.002687066
    ## 72       choice 0.002610966
    ## 73   affordable 0.002610966
    ## 74       moment 0.002267579
    ## 75      voucher 0.002267579
    ## 76       finish 0.002267579
    ## 77   regulation 0.002267579
    ## 78          few 0.002267579
    ## 79      seconds 0.002267579
    ## 80     terrific 0.002267579
    ## 81         poor 0.002267579
    ## 82           oh 0.002267579
    ## 83        total 0.002267579
    ## 84       brings 0.002267579
    ## 85        event 0.002267579
    ## 86          jim 0.002267579
    ## 87        right 0.002182812
    ## 88      between 0.002015300
    ## 
    ## $`4`
    ##          term      weight
    ## 1      mister 0.008925013
    ## 2       along 0.006325015
    ## 3        sort 0.005960397
    ## 4  unemployed 0.005554852
    ## 5      thanks 0.005194275
    ## 6      romney 0.004924145
    ## 7        town 0.004166139
    ## 8        hall 0.004166139
    ## 9       short 0.004166139
    ## 10  questions 0.004155420
    ## 11    quickly 0.004155420
    ## 12       move 0.004000868
    ## 13  hempstead 0.003973598
    ## 14    tonight 0.003973598
    ## 15     plenty 0.003973598
    ## 16     normal 0.003973598
    ## 17    address 0.003973598
    ## 18    follano 0.003973598
    ## 19  introduce 0.003973598
    ## 20    minutes 0.003162507
    ## 21    hofstra 0.002777426
    ## 22 commission 0.002777426
    ## 23 candidates 0.002777426
    ## 24      ahead 0.002777426
    ## 25    subject 0.002777426
    ## 26      gotta 0.002777426
    ## 27       here 0.002545506
    ## 28    waiting 0.002371881
    ## 29      quite 0.002371881
    ## 30     please 0.002371881
    ## 31      don't 0.002117948
    ## 32       york 0.002077710
    ## 33     jeremy 0.002077710
    ## 34      price 0.002077710
    ## 35     gallon 0.002077710
    ## 36      weeks 0.002077710
    ## 37      stand 0.002077710
    ## 38       guns 0.002077710
    ## 39     forget 0.002077710
    ## 40       want 0.002000041
    ## 
    ## $`5`
    ##              term      weight
    ## 1         segment 0.014461836
    ## 2        pakistan 0.007212314
    ## 3        segments 0.004597824
    ## 4          soviet 0.004597824
    ## 5         declare 0.004597824
    ## 6         minutes 0.003659317
    ## 7            iran 0.003659317
    ## 8       questions 0.003606157
    ## 9       gentlemen 0.003606157
    ## 10            war 0.003460208
    ## 11          union 0.003213741
    ## 12       response 0.003213741
    ## 13          catch 0.003213741
    ## 14    declaration 0.003213741
    ## 15        perhaps 0.003213741
    ## 16        mubarak 0.003213741
    ## 17         mister 0.003204954
    ## 18         romney 0.002848848
    ## 19        debates 0.002768166
    ## 20    afghanistan 0.002768166
    ## 21        nuclear 0.002744487
    ## 22          syria 0.002744487
    ## 23         israel 0.002744487
    ## 24           made 0.002550054
    ## 25         agreed 0.002404105
    ## 26          begin 0.002404105
    ## 27            sir 0.002404105
    ## 28           dead 0.002404105
    ## 29         bigger 0.002404105
    ## 30         threat 0.002404105
    ## 31        general 0.002404105
    ## 32        failure 0.002404105
    ## 33           bomb 0.002404105
    ## 34         campus 0.002298912
    ## 35          one's 0.002298912
    ## 36      schieffer 0.002298912
    ## 37            cbs 0.002298912
    ## 38         shared 0.002298912
    ## 39          aides 0.002298912
    ## 40            vow 0.002298912
    ## 41        silence 0.002298912
    ## 42       applause 0.002298912
    ## 43         divide 0.002298912
    ## 44      tonight's 0.002298912
    ## 45        fiftyth 0.002298912
    ## 46    anniversary 0.002298912
    ## 47           cuba 0.002298912
    ## 48       sobering 0.002298912
    ## 49       reminder 0.002298912
    ## 50     unexpected 0.002298912
    ## 51       concerns 0.002298912
    ## 52    controversy 0.002298912
    ## 53         caused 0.002298912
    ## 54        attempt 0.002298912
    ## 55       thoughts 0.002298912
    ## 56      interject 0.002298912
    ## 57        alluded 0.002298912
    ## 58        spilled 0.002298912
    ## 59 demonstrations 0.002298912
    ## 60           died 0.002298912
    ## 61       refugees 0.002298912
    ## 62       reassess 0.002298912
    ## 63            fly 0.002298912
    ## 64          zones 0.002298912
    ## 65         waited 0.002298912
    ## 66        regrets 0.002298912
    ## 67          shift 0.002298912
    ## 68        driving 0.002298912
    ## 69          japan 0.002298912
    ## 70          deter 0.002298912
    ## 71       deterred 0.002298912
    ## 72          leads 0.002298912
    ## 73        longest 0.002298912
    ## 74      scheduled 0.002298912
    ## 75       withdraw 0.002298912
    ## 76       purposes 0.002298912
    ## 77       deadline 0.002298912
    ## 78        arrives 0.002298912
    ## 79        obvious 0.002298912
    ## 80         unable 0.002298912
    ## 81         handle 0.002298912
    ## 82          allen 0.002298912
    ## 83       arrested 0.002298912
    ## 84       provides 0.002298912
    ## 85          haven 0.002298912
    ## 86        obama's 0.002298912
    ## 87           rise 0.002298912
    ## 88       vigorous 0.002298912
    ## 89         year's 0.002298912
    ## 90         policy 0.002136636
    ## 91          leave 0.002076125
    ## 92           east 0.002076125
    ## 93           each 0.002040043
    ## 
    ## $`6`
    ##               term      weight
    ## 1       department 0.017093970
    ## 2              chu 0.011395980
    ## 3           stated 0.011395980
    ## 4                w 0.011395980
    ## 5    misperception 0.011395980
    ## 6         graduate 0.007965448
    ## 7             bush 0.006861063
    ## 8               oh 0.005958716
    ## 9             earn 0.005958716
    ## 10          george 0.005958716
    ## 11      professors 0.005697990
    ## 12       neighbors 0.005697990
    ## 13        reassure 0.005697990
    ## 14    sufficiently 0.005697990
    ## 15          steven 0.005697990
    ## 16         stating 0.005697990
    ## 17        brackets 0.005697990
    ## 18            loss 0.005697990
    ## 19      concerning 0.005697990
    ## 20      charitable 0.005697990
    ## 21          forgot 0.005697990
    ## 22         rectify 0.005697990
    ## 23    inequalities 0.005697990
    ## 24       regarding 0.005697990
    ## 25         females 0.005697990
    ## 26            male 0.005697990
    ## 27    counterparts 0.005697990
    ## 28       undecided 0.005697990
    ## 29    disappointed 0.005697990
    ## 30       attribute 0.005697990
    ## 31        failings 0.005697990
    ## 32        missteps 0.005697990
    ## 33            fear 0.005697990
    ## 34          return 0.005697990
    ## 35   differentiate 0.005697990
    ## 36    accomplished 0.005697990
    ## 37        everyday 0.005697990
    ## 38      productive 0.005697990
    ## 39          global 0.005697990
    ## 40         telecom 0.005697990
    ## 41          supply 0.005697990
    ## 42        minneola 0.005697990
    ## 43       yesterday 0.005697990
    ## 44         reading 0.005697990
    ## 45          became 0.005697990
    ## 46         refused 0.005697990
    ## 47           extra 0.005697990
    ## 48           prior 0.005697990
    ## 49         attacks 0.005697990
    ## 50          denied 0.005697990
    ## 51        enhanced 0.005697990
    ## 52    availability 0.005697990
    ## 53            toll 0.005697990
    ## 54        examples 0.005697990
    ## 55          debunk 0.005697990
    ## 56      deductions 0.005056368
    ## 57        lorraine 0.004534916
    ## 58           kerry 0.004534916
    ## 59          living 0.004534916
    ## 60           voter 0.003982724
    ## 61         revenue 0.003982724
    ## 62           aware 0.003982724
    ## 63           ladka 0.003982724
    ## 64    specifically 0.003982724
    ## 65        specific 0.003982724
    ## 66        remember 0.003982724
    ## 67           using 0.003982724
    ## 68             win 0.003982724
    ## 69         planned 0.003982724
    ## 70       workplace 0.003982724
    ## 71       eliminate 0.003982724
    ## 72     outsourcing 0.003982724
    ## 73            lack 0.003982724
    ## 74       criminals 0.003982724
    ## 75         embassy 0.003982724
    ## 76           brain 0.003982724
    ## 77         however 0.003982724
    ## 78       expensive 0.003982724
    ## 79           cards 0.003982724
    ## 80         society 0.003982724
    ## 81           trust 0.003982724
    ## 82      convention 0.003982724
    ## 83        straight 0.003982724
    ## 84          romney 0.003530519
    ## 85          mister 0.003530519
    ## 86          credit 0.003430532
    ## 87         biggest 0.003430532
    ## 88          twelve 0.003430532
    ## 89      optimistic 0.002979358
    ## 90         sitting 0.002979358
    ## 91         assault 0.002979358
    ## 92              ak 0.002979358
    ## 93          sevens 0.002979358
    ## 94           limit 0.002979358
    ## 95      democratic 0.002979358
    ## 96          intend 0.002979358
    ## 97      employment 0.002979358
    ## 98     importantly 0.002979358
    ## 99         credits 0.002979358
    ## 100      currently 0.002979358
    ## 101     immigrants 0.002979358
    ## 102             hi 0.002979358
    ## 103        friends 0.002979358
    ## 104  international 0.002979358
    ## 105        seventy 0.002979358
    ## 106          voted 0.002979358
    ## 107        reports 0.002979358
    ## 108         others 0.002979358
    ## 109        various 0.002979358
    ## 110       mortgage 0.002979358
    ## 111       children 0.002979358
    ## 112       thousand 0.002760961
    ## 113            tax 0.002647889
    ## 114 administration 0.002528184
    ## 115          libya 0.002528184
    ## 116        elected 0.002267458
    ## 117            old 0.002267458
    ## 118       problems 0.002267458
    ## 119            man 0.002267458
    ## 120       yourself 0.002267458
    ## 121          child 0.002267458
    ## 122        members 0.002267458

### Clusters, Terms, and Docs Plot

Here I plot the clusters, terms, and documents (grouping variables)
together as a combined heatmap. This can be useful for viewing &
comparing what documents are clustering together in the context of the
cluster's salient terms. This example also shows how to use the cluster
terms as a lookup key to extract probable salient terms for a given
document.

    key <- data_frame(
        cluster = 1:6,
        labs = get_terms(ca, .002) %>%
            bind_list("cluster") %>%
            select(-weight) %>%
            group_by(cluster) %>%
            slice(1:10) %>%
            na.omit() %>%
            group_by(cluster) %>%
            summarize(term=paste(term, collapse=", ")) %>%
            apply(., 1, paste, collapse=": ") 
    )

    ca %>%
        bind_vector("id", "cluster") %>%
        separate(id, c("person", "time"), sep="_") %>%
        tbl_df() %>%
        left_join(key) %>%
        mutate(n = 1) %>%
        mutate(labs = factor(labs, levels=rev(key[["labs"]]))) %>%
        unite("time_person", time, person, sep="\n") %>%
        select(-cluster) %>%
        complete(time_person, labs) %>%  
        mutate(n = factor(ifelse(is.na(n), FALSE, TRUE))) %>%
        ggplot(aes(time_person, labs, fill = n)) +
            geom_tile() +
            scale_fill_manual(values=c("grey90", "red"), guide=FALSE) +
            labs(x=NULL, y=NULL) 

    ## Joining by: "cluster"

![](inst/figure/unnamed-chunk-11-1.png)

### Cluster Documents

The `get_documents` function grabs the documents associated with a
particular cluster. This is most useful in cases where the number of
documents is small and they have been given names.

    get_documents(ca)

    ## $`1`
    ## [1] "OBAMA_time 2"  "OBAMA_time 3"  "ROMNEY_time 2" "ROMNEY_time 3"
    ## 
    ## $`2`
    ## [1] "OBAMA_time 1"  "ROMNEY_time 1"
    ## 
    ## $`3`
    ## [1] "LEHRER_time 1"
    ## 
    ## $`4`
    ## [1] "CROWLEY_time 2"
    ## 
    ## $`5`
    ## [1] "SCHIEFFER_time 3"
    ## 
    ## $`6`
    ## [1] "QUESTION_time 2"

Putting it Together
-------------------

I like working in a chain. In the setup below we work within a
**magrittr** pipeline to fit a model, select clusters, and examine the
results. In this example I do not condense the 2012 Presidential Debates
data by speaker and time, rather leaving every sentence as a separate
document. On my machine the initial `data_store` and model fit take ~1
minute to run. Note that I do restrict the number of clusters (for texts
and terms) to a random 5 clusters for the sake of space.

    .tic <- Sys.time()

    myfit2 <- presidential_debates_2012 %>%
        with(data_store(dialogue)) %>%
        kmeans_cluster(k=100)

    difftime(Sys.time(), .tic)

    ## Time difference of 33.77592 secs

    ## View Document Loadings
    ca2 <- assign_cluster(myfit2)
    summary(ca2) %>% 
        head(12)

![](inst/figure/unnamed-chunk-13-1.png)

    ##    cluster count
    ## 1        4  1520
    ## 2       15   134
    ## 3       97   124
    ## 4       74    87
    ## 5       92    82
    ## 6       89    73
    ## 7       11    71
    ## 8       43    51
    ## 9       70    47
    ## 10      90    42
    ## 11      30    34
    ## 12      81    32

    ## Split Text into Clusters
    set.seed(3); inds <- sort(sample.int(100, 5))

    get_text(ca2)[inds] %>%
        lapply(head, 10)

    ## $`17`
    ## [1] "Questions remain."
    ## 
    ## $`32`
    ##  [1] "That's not going to happen."                                   
    ##  [2] "Many will lose it."                                            
    ##  [3] "I will not cut our commitment to our military."                
    ##  [4] "Their questions will drive the night."                         
    ##  [5] "Will will you certainly will have lots of time here coming up."
    ##  [6] "I will never know."                                            
    ##  [7] "I will not let that happen."                                   
    ##  [8] "I know how to make that happen."                               
    ##  [9] "I know how to make that happen."                               
    ## [10] "I will."                                                       
    ## 
    ## $`38`
    ## [1] "Is there too much?"                  
    ## [2] "Our party has been focused too long."
    ## [3] "And I suspect he'll keep those too." 
    ## [4] "He said, Me too."                    
    ## [5] "He said, Me too."                    
    ## [6] "He said, Me too."                    
    ## [7] "It's too high."                      
    ## 
    ## $`58`
    ##  [1] "Can we can we stay on Medicare?"                                                                       
    ##  [2] "Let's get back to Medicare."                                                                           
    ##  [3] "Let's get back to Medicare."                                                                           
    ##  [4] "of you on Medicare?"                                                                                   
    ##  [5] "We didn't cut Medicare."                                                                               
    ##  [6] "Of course, we don't have Medicare, but we didn't cut Medicare by dollar seven hundred sixteen billion."
    ##  [7] "You'll see chronic unemployment."                                                                      
    ##  [8] "You'll have four million people who will lose Medicare Advantage."                                     
    ##  [9] "You'll have hospital and providers that'll no longer accept Medicare patients."                        
    ## [10] "I'll restore that dollar seven hundred sixteen billion to Medicare."                                   
    ## 
    ## $`80`
    ## [1] "Candy, Candy|" "Candy?"        "Candy?"        "Candy, I'm|"

    ## Get Associated Terms
    get_terms(ca2, term.cutoff = .07)[inds]

    ## $`17`
    ##        term   weight
    ## 1    remain 4.753402
    ## 2 questions 4.253402
    ## 
    ## $`32`
    ##     term    weight
    ## 1 happen 0.6435874
    ## 2   will 0.5188045
    ## 3    not 0.3571543
    ## 4      i 0.1601698
    ## 5   that 0.1290930
    ## 6   know 0.1279324
    ## 7   help 0.1268966
    ## 8  needs 0.1035649
    ## 
    ## $`38`
    ##       term    weight
    ## 1      too 1.6618079
    ## 2       me 0.5322476
    ## 3       he 0.5077092
    ## 4     said 0.4417606
    ## 5     high 0.3772305
    ## 6     much 0.2277686
    ## 7  suspect 0.2144246
    ## 8     it's 0.2104448
    ## 9    he'll 0.2024865
    ## 10 focused 0.1874464
    ## 11   party 0.1820784
    ## 12   there 0.1625931
    ## 13    long 0.1346921
    ## 14    keep 0.1285173
    ## 15   those 0.1010656
    ## 
    ## $`58`
    ##            term    weight
    ## 1      medicare 0.8723376
    ## 2         sales 0.2918557
    ## 3        you'll 0.2910676
    ## 4          lose 0.2860665
    ## 5       chronic 0.2397251
    ## 6        didn't 0.2151903
    ## 7         let's 0.1944793
    ## 8            we 0.1944361
    ## 9          back 0.1792507
    ## 10          cut 0.1564845
    ## 11 unemployment 0.1545696
    ## 12          get 0.1340996
    ## 13          see 0.1215495
    ## 14           on 0.1178543
    ## 15      billion 0.1083292
    ## 16      turning 0.1065445
    ## 17      sixteen 0.1065093
    ## 18          can 0.1059886
    ## 
    ## $`80`
    ##    term    weight
    ## 1 candy 6.5684530
    ## 2   i'm 0.6042973