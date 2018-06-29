
# Causal Set Generator (Feynman Posets) A.2

Author: Conor Haugrønning

Date Created: June 28, 2018 

Last Edited: June 29, 2018 


# Summary

This program allows you to create Feynman posets.
Current support includes two types of three-
degenerate posets.

Features:
- Classical Stochastic Growth model for posets with
  specified kinematic restrictions
- Coarse-graining
- Rigidity Tests
- (Hopefully) streamlined saving process

Planned updates in the immediate future:
- Plenty of optimization issues
- Automatic saving of plots
- Automatic saving of Hasse diagrams
- Computation of level structure
- Automatic plotting of characteristic interval
  abundance curves (for d-rigidity testing)
- Adding in quantum dynamical transitions

Planned updates in the more distant future:
- Migration to Python
- Addition of new embeddedness tests
- More user friendly way to change kinematic
  properties of posets
- More coarse-graining options

# BRIEF USER GUIDE

The 'Main' program allows you to choose settings for the construction parameters. Current choices include:

----------------------------------------------------------------------------------------------------

**Type of poset**:

makeHoles
makeNoHoles

By setting these variables equal to 1, you can create holes posets that allow for indegree/outdegree
of vertices equal to 3 or 'no holes' posets, that allow for a maximum indegree/outdegree of 2
(but with a total vertex degeneracy of 3). Both can be set to 1 and the script will run once for each
type of poset.

----------------------------------------------------------------------------------------------------

**Statistical and single trials**

makesMany
trials

By selecting makesMany=1, the script will create several posets, with the number specified by the
value of 'trials'.
NB! It is highly recommended to keep the number of trials below 100.

----------------------------------------------------------------------------------------------------

**Cardinality of posets**

smallSets
bigSet

If makesMany=1, the value entered for smallSets will specify the number of points in the multiple
posets created. By default, if makesMany=0, the script will only create 

NB: It is highly recommended to keep smallSets below 2000 and bigSets below 5000.

----------------------------------------------------------------------------------------------------

**Coarse-Graining**

coarseGrain
numCoarse
coarseParam

By selecting coarseGrain=1, ONE singular set (the one specified by bigSet) will be coarse-grained.
coarseParam allows you to select how many elements will be removed each time the set is coarse-grained.
numCoarse allows you to choose how many times the set will be coarse-grained.

----------------------------------------------------------------------------------------------------


# HOW THE FILES ARE SAVED 

Regardless of the parameters chosen, the resulting folder after running the
program will always have the following structure:

1. Result_DD-MMM-YYYY
- Holes
    - Single
    - Statistical
    - Graphics
    - Coarse-Graining
- No Holes
    - Single
    - Statistical
    - Graphics
    - Coarse-Graining

The 'single' folder will always contain results. This is where you will find
the adjacency matrix, incidence matrix, average length of subintervals, average ordering
fraction of subintervals, average volume of subintervals, the number of extremal points,
the height, and the total ordering fraction for the entire poset. In addition to averages,
the 'sample.dat' file will contain the ratio, length, and volume of all subintervals for
convenient plotting usage. The read me file contains an immediate reminder of how the sample
file is organized.


The 'Statistical' folder will contain results if makesMany=0. This contains distributions
of the height, total ordering fraction, average volume and ordering fraction of subintervals,
and the number of extremal points over the number of smaller sets created, as specified by the
'trial' variable in the main program.

The 'Coarse_Graining' folder contains the results of the coarse-grainings if coarseGrain=0
in the main program. For the time being, the only variables saved are the tests for weak
and strong d-rigidity and the adjacency matrices for each coarse-grained version of the
posets. If one is lucky, it will also contain the incidence matrices, 'sample' data,
and the total ordering fraction of each coarse-grained version of the sets.  If not,
it will be available in the next update.
