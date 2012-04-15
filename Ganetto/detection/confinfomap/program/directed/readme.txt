The software is provided "as is" and is free for academic and non-profit use. 
For commercial use and licensing please contact Martin Rosvall, 
martin.rosvall@physics.umu.se. Please cite in any publication: 
Martin Rosvall and Carl T. Bergstrom, Mapping change in large networks, 
PLoS ONE 5(1): e8694 (2010).

Extract the gzipped tar archive, run 'make' to compile and, for example, 
'./conf-infomap 344 flow.net 10 100 0.90' to run the code.
tar xzvf conf-infomap_dir.tgz
cd conf-infomap_dir
make
./conf-infomap 344 flow.net 10 100 0.9
Here conf-infomap is the name of executable, 344 is a random seed (can be 
any positive integer value), flow.net is the network to partition 
(in Pajek format), 10  is the number of attempts to partition the network 
(can be any integer value equal or larger than 1) and each of the 100 bootstrap 
networks. Finally, 0.90 is the confidence level for the significance analysis.

The output file with extension .smap has the format:

# modules: 4
# modulelinks: 4
# nodes: 16
# links: 20
# codelength: 3.32773
*Directed
*Modules 4
1 "Node 13,..." 0.25 0.0395432
2 "Node 5,..." 0.25 0.0395432
3 "Node 9,..." 0.25 0.0395432
4 "Node 1,..." 0.25 0.0395432
*Insignificants 2
4>2
3>2
*Nodes 16
1:1 "Node 13" 0.0820133
1;2 "Node 14" 0.0790863
1:3 "Node 16" 0.0459137
1:4 "Node 15" 0.0429867
2:1 "Node 5" 0.0820133
2;2 "Node 6" 0.0790863
2;3 "Node 8" 0.0459137
2;4 "Node 7" 0.0429867
3:1 "Node 9" 0.0820133
3:2 "Node 10" 0.0790863
3;3 "Node 12" 0.0459137
3;4 "Node 11" 0.0429867
4;1 "Node 1" 0.0820133
4;2 "Node 2" 0.0790863
4:3 "Node 4" 0.0459137
4:4 "Node 3" 0.0429867
*Links 4
1 4 0.0395432
2 3 0.0395432
3 1 0.0395432
4 2 0.0395432	

This file contains the necessary information to generate a significance map 
in the alluvial generator. The names under *Modules are derived from the node 
with the highest flow volume within the module and 0.25 0.0395432 represent, 
respectively, the aggregated flow volume of all nodes within the module and 
the per step exit flow from the module. The nodes are listed with their module
assignments together with their flow volumes. Finally, all links between the 
modules are listed in order from high flow to low flow

This file also contains information about which modules that are not significantly 
standalone and which modules they most often are clustered together with. The 
notation "4>2" under "*Insignificants 2" in the example file above means that
the significant nodes in module 4 more often than the confidence level are clustered 
together with the significant nodes in module 2. In the module assignments, we use 
colons to denote significantly clustered nodes and semicolons to denote 
insignificantly clustered nodes. For example, the colon in '1:1 "Node 13" 0.0820133' 
means that the node belongs to the largest, measured by flow, set of nodes that 
are clustered together in at least a fraction of bootstrap networks that is given 
by the confidence level.