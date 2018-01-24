function freqBand = getFrequencyBandsDown(clusterHeadCoords, k, iHop, ANTENNAS)
% Randomly assigns one of the possible bands to each of the groups. 
% Each group has one line in clusterHeadCoords and memberships.
% This function is called by my_cluster.m to choose band for the whole cluster
% Output
% freqBand ..  vector [k, 1] of numbers between 1 and ANTENNAS.iHop{iHop}.nBands


% we used to do it like this (but this is not so good, as explained below):
%freqBand = randi(ANTENNAS.iHop{iHop}.nBands,k,1);

% add sets of numbers 1:nBands as many times as necessary to fill temp
% until its size == k
% the last filling is usually partial. This method minimizes the number of
% cluster per frequency band by spreading the band usage as evenly as
% possible. 
%  Why do we do this?
% When we just assign random bandwidth per cluster, there can be
% many clusters communicating in band A, while band B is totally unused and
% so on.
temp = [];
nBands = ANTENNAS.hop{iHop}.nBands;
while size(temp,1)+nBands<=k
  temp(end+1:end+nBands,1) = randperm(nBands);
end
remainder = k-size(temp,1);
temp(end+1:end+remainder,1) = randperm(nBands, remainder);

freqBand = temp(randperm(k));
