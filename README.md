Ganetto
================
*Galatasaray Network Toolbox*

* Copyright 2009-10 Vincent Labatut & Günce K. Orman.
* Copyright 2011-13 Vincent Labatut, Günce K. Orman & Burcu Kantarci. 
* Copyright 2014-16 Vincent Labatut.

Ganetto is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation. For source availability and license information see `licence.txt`

* Lab site: http://bit.gsu.edu.tr/
* GitHub repo: https://github.com/CompNet/Ganetto
* Contact: Vincent Labatut <vlabatut@gsu.edu.tr>

If you use this source code, please cite reference [L'15].

-----------------------------------------------------------------------


# Description
These scripts implement several measures allowing to compare two community structures, i.e. two partitions of the
node set of a given graph. They are based on popular measures defined in the field of cluster analysis, namely 
(see the source code for original bibliographic references):  

* Purity (also known under many other names in the literature, such as percent correct, accuracy, etc.)
* Rand index and its adjusted version.
* Normalized mutual information.

The scripts provided here implement (or show how to use existing implementations of) these classic measures,
and also some modified versions. Those allow to take into account some weight defined for each one of the considered elements
(in our case: nodes). The goal here is to be able to factor the network topology in these measures, which otherwise 
completely ignore this essential aspect of community detection (which is natural, since they were originally developped
to assess cluster analysis results).

The measures were originally implemented in 2012 and the corresponding paper was published in 2015 [L'15].
I did not publish the source code at this time, because I thought it was quite trivial to implement the measures I had proposed.
However, in 2016 I realized a few authors cited my work and pointed at the absence of publicly available source code, 
so I decided to clean it up and put it online. Hopefully, someone will use it! 


# Organization
The organization is very simple, all the source code is in folder `src`:

* `CommonFunctions.R`: contains some functions used to process some of the measures.
* `NormalizedMutualInformation.R`, `PurityMeasure.R` and `RandIndex.R`: process the measures listed above, as well as their modified versions. 
* `Example.R`: illustrates how to process the different measures, by applying them to
			   several data, including the example from my paper. The `Example-out-xxxxx.txt` files correspond to the results you should obtain
			   when executing this script. 


# Installation
You just need to install `R` and the required packages:

1. Install the [`R` language](https://www.r-project.org/)
2. Install the following R packages:
   * [`igraph`](http://igraph.org/r/)
3. Download this project from GitHub and unzip.
4. Launch `R`, setup the working directory with `setwd` so that it points at the root of this project. 


# Use
In order to process the measures:

1. Open the `R` console.
2. Set the project root as the working directory, using `setwd("<my directory>")`.
3. Launch the `Example.R` script, or just include one of the measure scripts (`NormalizedMutualInformation.R`, 
   `PurityMeasure.R` and `RandIndex.R`) to use in your own source code.


# Extension
The example shows how to use the measures with the three types of weights proposed in the paper [L'15].
However, the functions allow using any other scheme: you just need to process these topological weights
first, then pass them to the selected function using its `topo.measure` parameter. 


# Dependencies
* [`igraph`](http://igraph.org/r/) package: used to build and handle graphs.


# Disclaimer
This is not the exact version used in the paper [L'15], it is a reworked, cleaned and commented one.
For instance, some of the functions I had originally implemented are now available in certain libraries, 
so I decided to remove them from my scripts and use these libraries instead. 
I was careful when updating my source code, and I tested it. But of course, because of these changes, 
it is always possible that I introduced some bugs. Please, if you find one, contact me at the above
email address or post an issue on the GitHub page. 


# References
 * **[L'15]** V. Labatut, *Generalised measures for the evaluation of community detection methods*, International Journal of Social Network Mining (IJSNM), 2(1):44-63, 2015. [doi: 10.1504/IJSNM.2015.069776](https://doi.org/10.1504/IJSNM.2015.069776) - [⟨hal-00802923⟩](https://hal.archives-ouvertes.fr/hal-00802923)
 * **[OLC'13]** G. K. Orman, V. Labatut & H. Cherifi, *Towards realistic artificial benchmark for community detection algorithms evaluation*. International Journal of Web Based Communities (IJWBC), 9(3):349-370, 2013. [doi: 10.1504/IJWBC.2013.054908](https://doi.org/10.1504/IJWBC.2013.054908) - [⟨hal-00840261⟩](https://hal.archives-ouvertes.fr/hal-00840261)
 * **[OLC'12]** G. K. Orman, V. Labatut & H. Cherifi. *Comparative Evaluation of Community Detection Algorithms : A Topological Approach*. Journal of Statistical Mechanics : Theory and Experiment, 2012(08):P08001, 2012. [doi: 10.1088/1742-5468/2012/08/P08001](https://doi.org/10.1088/1742-5468/2012/08/P08001) - [⟨hal-00710659⟩](https://hal.archives-ouvertes.fr/hal-00710659)
 * **[OLC'11]** G. K. Orman, V. Labatut & H. Cherifi. *On Accuracy of Community Structure Discovery Algorithms*. Journal of Convergence Information Technology, 6(11):283-292, 2011. [doi: 10.4156/jcit.vol6.issue11.32](https://doi.org/10.4156/jcit.vol6.issue11.32) - [⟨hal-00653084⟩](https://hal.archives-ouvertes.fr/hal-00653084)
 * **[]** G. K. Orman, V. Labatut & H. Cherifi. *An Empirical Study of the Relation Between Community Structure and Transitivity*. 3rd Workshop on Complex Networks (CompleNet). Studies in Computational Intelligence, 424:99-110, Springer, 2013. [doi: 10.1007/978-3-642-30287-9_11](https://doi.org/10.1007/978-3-642-30287-9_11) - [⟨hal-00717707⟩](https://hal.archives-ouvertes.fr/hal-00717707) 
 
 

