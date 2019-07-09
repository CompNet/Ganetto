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

-----------------------------------------------------------------------


# Description
These R scripts are designed to handle various tasks related to the community structure of complex networks: community detection, generation of modular artificial graphs, evaluation of communinity detection results, assessment of various topological measures, generation of plots.  


# Organization
The organization is very simple, all the source code folders are located directly in the root folder.

Folder `detection` contains the scripts used to apply community detection methods. Some of them are a part of the `igraph` library, but some others are separate pieces of softwares. The source code of the latter is located in their own folder, in folder `detection/xxxxx` (where `xxxxx` is the name of the considered algorithm).


# Installation
You first need to install `R` and the required packages:

1. Install the [`R` language](https://www.r-project.org/)
2. Install the following R packages:
   * [`igraph`](http://igraph.org/r/)
3. Download this project from GitHub and unzip.
4. Launch `R`, setup the working directory with `setwd` so that it points at the root of this project. 

Then, if you want to use some of the external community detection algorithms, you need to compile them. See the instructions in their dedicated folders (itself in folder `detection`).


# Use
In order to process the measures:

1. Open the `R` console.
2. Set the project root as the working directory, using `setwd("<my directory>")`.
3. Launch the `Main.R` script to get an example of how the scripts can be used.


# Dependencies
* [`igraph`](http://igraph.org/r/) package: used to build and handle graphs.
* [`infomap`](http://www.tp.umu.se/~rosvall/code.html): Infomap community detection tool.
* [`conf-infomap`](http://www.tp.umu.se/~rosvall/code.htmle): significance-based variant of Infomap.
* [`infohiermap`](http://www.tp.umu.se/~rosvall/code.html): hierarchical variant of Infomap.
* [`infomod`](http://www.tp.umu.se/~rosvall/code.html): Infomod community detection tool.


# References
 * **[L'15]** V. Labatut, *Generalised measures for the evaluation of community detection methods*, International Journal of Social Network Mining (IJSNM), 2(1):44-63, 2015. [doi: 10.1504/IJSNM.2015.069776](https://doi.org/10.1504/IJSNM.2015.069776) - [⟨hal-00802923⟩](https://hal.archives-ouvertes.fr/hal-00802923)
 * **[OLC'13]** G. K. Orman, V. Labatut & H. Cherifi, *Towards realistic artificial benchmark for community detection algorithms evaluation*. International Journal of Web Based Communities (IJWBC), 9(3):349-370, 2013. [doi: 10.1504/IJWBC.2013.054908](https://doi.org/10.1504/IJWBC.2013.054908) - [⟨hal-00840261⟩](https://hal.archives-ouvertes.fr/hal-00840261)
 * **[OLC'12a]** G. K. Orman, V. Labatut & H. Cherifi. *Comparative Evaluation of Community Detection Algorithms : A Topological Approach*. Journal of Statistical Mechanics : Theory and Experiment, 2012(08):P08001, 2012. [doi: 10.1088/1742-5468/2012/08/P08001](https://doi.org/10.1088/1742-5468/2012/08/P08001) - [⟨hal-00710659⟩](https://hal.archives-ouvertes.fr/hal-00710659)
 * **[OLC'12b]** G. K. Orman, V. Labatut & H. Cherifi. *An Empirical Study of the Relation Between Community Structure and Transitivity*. 3rd Workshop on Complex Networks (CompleNet 2012). Studies in Computational Intelligence, 424:99-110, Springer, 2013. [doi: 10.1007/978-3-642-30287-9_11](https://doi.org/10.1007/978-3-642-30287-9_11) - [⟨hal-00717707⟩](https://hal.archives-ouvertes.fr/hal-00717707) 
 * **[L'12]** V. Labatut. *Une nouvelle mesure pour l’évaluation des méthodes de détection de communautés*. 3ème Conférence sur les modèles et l’analyse de réseaux : approches mathématiques et informatiques (MARAMI). 12p, 2012. [⟨hal-00743888⟩](https://hal.archives-ouvertes.fr/hal-00743888)
 * **[OLC'11a]** G. K. Orman, V. Labatut & H. Cherifi. *On Accuracy of Community Structure Discovery Algorithms*. Journal of Convergence Information Technology, 6(11):283-292, 2011. [doi: 10.4156/jcit.vol6.issue11.32](https://doi.org/10.4156/jcit.vol6.issue11.32) - [⟨hal-00653084⟩](https://hal.archives-ouvertes.fr/hal-00653084)
 * **[OLC'11b]** G. K. Orman, V. Labatut & H. Cherifi. *Qualitative Comparison of Community Detection Algorithms*. 1st International Conference on Digital Information and Communication Technology and its Applications (DICTAP). Communications in Computer and Information Science, Springer, 167:265-279, 2011. [doi: 10.1007/978-3-642-22027-2_23](https://doi.org/10.1007/978-3-642-22027-2_23) - [⟨hal-00611385⟩](https://hal.archives-ouvertes.fr/hal-00611385)
 * **[OLC'11c]** G. K. Orman, V. Labatut & H. Cherifi. *Relation entre transitivité et structure de communauté dans les réseaux complexes*. 2ème Journée thématique Fouille de grands graphes (JFGG). 4p, 2011. [⟨hal-01112256⟩](https://hal.archives-ouvertes.fr/hal-01112256)
 * **[OL'10]** G. K. Orman & V. Labatut. *The Effect of Network Realism on Community Detection Algorithms*. International Conference on Advances in Social Networks Analysis and Mining (ASONAM). 301-305, 2010. [doi: 10.1109/ASONAM.2010.70](https://doi.org/10.1109/ASONAM.2010.70) - [⟨hal-00633641⟩](https://hal.archives-ouvertes.fr/hal-00633641)
 * **[OL'09a]** G. K. Orman & V. Labatut. *A Comparison of Community Detection Algorithms on Artificial Networks*. 12th International Conference on Discovery Science (DS). Lecture Notes in Artificial Intelligence, Springer, 5808:242-256, 2009. [doi: 10.1007/978-3-642-04747-3_20](https://doi.org/10.1007/978-3-642-04747-3_20) - [⟨hal-00633640⟩](https://hal.archives-ouvertes.fr/hal-00633640)
 * **[OL'09b]** G. K. Orman & V. Labatut. *Relative Evaluation of Partition Algorithms for Complex Networks*. 1st International Conference on Networked Digital Technologies (NDT). 20-25, 2009. [doi: 10.1109/NDT.2009.5272078](https://doi.org/10.1109/NDT.2009.5272078) - [⟨hal-00633624⟩](https://hal.archives-ouvertes.fr/hal-00633624)
 