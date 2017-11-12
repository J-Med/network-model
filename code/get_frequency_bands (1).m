function freq_band = get_frequency_bands_down(cluster_head_coords, memberships, clust_lvl, ANTENNAS)
% Randomly assigns one of the possible bands to each of the groups. 
% Each group has one line in cluster_head_coords and memberships.
% This function is called by my_cluster.m to choose band for the whole cluster

% taking clustering level clust_lvl as parameter, freq band is assigned for
% the hop closer to the end user -> i_hop = clust_lvl-1
i_hop = clust_lvl-1;
freq_band = randi(ANTENNAS.technology{i_hop}.n_bands,size(memberships,1));
end