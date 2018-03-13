# network-model

This README is a bit obsolete. Please return later for an updated description.

Performs multi-level clustering to determine positions of network cells and measures QoS. This project was developed specifically for Smart Grids, following IEC 61850 specifications and adding encryption on top of the data volumes.

This is the continuation of a first research project which compared different clustering techniques to determine which has the highest performance in Smart Grid scenario. K-means and K-medoids were the winners and the results were published at ICNSC 2017 in paper: Vrbsky, L. et al. Clustering Techniques for Data Network Planning in Smart Grids.

Input specs (in code):
 - positions (cartesian, [m]) of nodes/clients/users in a 2D scenario
 - number of bits and max-delays to transfer (separately for upstream and downstream
 - number of wireless network layers - currently supports only 2 layers (i.e. access points, gateway)
 - number of cells per layer
 - network equipment specs per type (client, small cell, macro cell)
 - wireless technology per layers (currently first allows {'wifi', 'wimax'} and second allows {'wimax'}
 
Current code works well for two wireless layers. Specs of equipment are specified for client devices, small cells, macro cells. Client's positions are fixed - this applies in Smart Grids, which is a focus of this project. The main idea is that clients connect to small cells (wirelessly), small cells connect to macro cells (wirelessly), and macro cells connect to servers/cloud via fiber optics of high bandwidth. There is a possibility to add more layers to the network communication, like a small access point between users and small cells.

The QoS and the whole communication is measured separately for upstream and downstream, taking into account interference from all network nodes at the same frequency, excluding interference caused by users. It was excluded because of its high complexity and relatively low interference, since user equipment is the least powerful in the network.
