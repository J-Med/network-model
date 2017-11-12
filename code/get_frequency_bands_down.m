function freq_band = get_frequency_bands_down(cluster_head_coords, k, i_hop, ANTENNAS)
% Randomly assigns one of the possible bands to each of the groups. 
% Each group has one line in cluster_head_coords and memberships.
% This function is called by my_cluster.m to choose band for the whole cluster
% Output
% freq_band ..  vector [k, 1] of numbers between 1 and ANTENNAS.i_hop{i_hop}.n_bands


% we used to do it like this (but this is not so good, as explained below):
%freq_band = randi(ANTENNAS.i_hop{i_hop}.n_bands,k,1);

% add sets of numbers 1:n_bands as many times as necessary to fill temp
% until its size == k
% the last filling is usually partial. This method minimizes the number of
% cluster per frequency band by spreading the band usage as evenly as
% possible. 
%  Why do we do this?
% When we just assign random bandwidth per cluster, there can be
% many clusters communicating in band A, while band B is totally unused and
% so on.
temp = [];
n_bands = ANTENNAS.hop{i_hop}.n_bands;
while size(temp,1)+n_bands<k
  temp(end+1:end+n_bands,1) = randperm(n_bands);
end
remainder = k-size(temp,1);
temp(end+1:end+remainder,1) = randperm(n_bands, remainder);

freq_band = temp(randperm(k));
