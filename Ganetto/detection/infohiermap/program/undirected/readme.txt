The software is provided "as is" and is free for academic and non-profit use. 
For commercial use and licensing please contact Martin Rosvall, 
martin.rosvall@physics.umu.se. Please cite in any publication: 
Martin Rosvall and Carl T. Bergstrom, Multilevel compression of 
random walks on networks reveals hierarchical organization in large 
integrated systems, PLoS ONE 6(4): e18209 (2011).

Extract the gzipped tar archive, run 'make' to compile and, for example, 
'./infohiearmap 345234 ninetriangles.net 10' to run the code.
tar xzvf infohiermap_undir.tgz
cd infohiermap_undir
make
./infohiermap 345234 ninetriangles.net 10
Here infohiermap is the name of the executable, 345234 is a random seed 
(can be any positive integer value), ninetriangles.net is the network
to partition (in Pajek format), and 10 is the number of attempts to partition 
the network (can be any integer value equal to or larger than 1). 

The output file has the extension .tree (plain text file) and corresponds 
to the best partition (shortest description length) of the attempts. 
The output format has the pattern:
# Codelength = 3.48419 bits.
1:1:1 0.0384615 "7"
1:1:2 0.0384615 "8"
1:1:3 0.0384615 "9"
1:2:1 0.0384615 "4"
1:2:2 0.0384615 "5"
...
Each row (except the first one, which summarizes the result) begins with 
the multilevel module assignments of a node. The module assignments are 
colon separated from coarse to fine level, and all modules within each level 
are sorted by the total PageRank of the nodes they contain. Further, the 
integer after the last comma is the rank within the finest-level module, 
the decimal number is the steady state population of random walkers, and 
finally, within quotation marks, is the node name.
