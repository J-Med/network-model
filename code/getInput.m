function [coords, maxDelays, bitsIn] = getInput(scenario, restrictedMode)
  scenarioSize = str2num(scenario);
% OUTPUTS
% positions     2D coordinates of clients - size dim*scenarioSize
% maxDelays     maximum delays allowed for upstream (first col) and
%               downstream (second column) - size 2*scenarioSize
% bitsIn        bits to be transfered for upstream (first col) and
%               downstream (second column) - size 2*scenarioSize



% previously: function [positions, sink_idx, data, max_delays, node_names] = getIEEEfeeder_scenario(scenarioSize, sink_xy)
% returns eucledian coordinates of feeders based on IEEE XY Node Test Feeder

% INPUTS
% for no inputs function will set the offset to [0,0]
% offset    ...   [X,Y] 2-dim coordinate offset of the gateway node 650 -
%                 this is where coordinates setting will begin - useful for
%                 plotting purposes - recommendation would be [250,1600]
% sink_xy   ..  coordinates of sink(s) of size k,dim


data__maxDelays = [
           0           0         Inf         Inf
         321         448           1          50
        1665         448           1          50
         321         448           1          50
        1665         448           1          50
        1344           0         100         Inf
         321         448           1          50
         321         448           1          50
        1344           0         100         Inf
        1665         448           1          50
        1344           0         100         Inf
         321         448           1          50
        1344           0         100         Inf];

if scenarioSize ~= 13
%   clientTypes = [
%          321         448           1          50
%         1344           0         100         Inf
%         1665         448           1          50];
  clientTypesRegular = [
         321         448           1          50
        1665         448           1          50
         321         448           1          50
        1665         448           1          50
        1344           0         100         Inf
         321         448           1          50
         321         448           1          50
        1344           0         100         Inf
        1665         448           1          50
        1344           0         100         Inf
         321         448           1          50
        1344           0         100         Inf];

  clientTypesRestricted = [
         321         448           1          50
         321         448           1          50
         321         448           1          50
         321         448           1          50
           0           0         Inf         Inf
         321         448           1          50
         321         448           1          50
           0           0         Inf         Inf
         321         448           1          50
           0           0         Inf         Inf
         321         448           1          50
           0           0         Inf         Inf];

  %% define names, connections with distances, and calculate
  % idx = randi(size(data__max_delays,1)-1,num,1)+1;
  % data =       data__max_delays(idx,1:2);
  % max_delays = data__max_delays(idx,3:4);

if restrictedMode
    clientTypes = clientTypesRestricted;
else
    clientTypes = clientTypesRegular;    
end

  idx = randi(size(clientTypes,1),scenarioSize,1);
  bitsIn =    clientTypes(idx,1:2);
  maxDelays = clientTypes(idx,3:4);

  scenarioPath = ['scenarios' filesep num2str(scenarioSize,'Buscoords%d.csv')];
  coords = csvread(scenarioPath,2,1);
  
else
  sink_xy = [0,0];
  offset = sink_xy;

  bitsIn =    data__maxDelays(:,1:2);
  maxDelays = data__maxDelays(:,3:4);

  sink_idx = 1;

  distances = {
      {609.6};                %650
      {152.4,152.4,609.6};    %632
      {91.44};                %645
      {0};                    %633
      {91.44,0,304.8};        %671
      {};                     %646
      {};                     %634
      {91.44,243.84};         %684
      {152.4};                %692
      {};                     %680
      {};                     %611
      {};                     %652
      {};                     %675
      };

  % north = [0, 1];
  south = [0,-1];
  west  = [-1,0];
  east  = [1, 0];
  zero  = [0 ,0];

  directions = {
      {south};                %650
      {west;east;south};      %632
      {west};                 %645
      {east};                 %633
      {west;east;south};      %671
      {zero};                 %646
      {zero};                 %634
      {west;south};           %684
      {east};                 %692
      {zero};                 %680
      {zero};                 %611
      {zero};                 %652
      {zero};                 %675
      };

  pos_650 = offset;

  coords = zeros(size(distances,1),2);
  coords(1,:) = pos_650;
  countSet = 1;
  for i = 1:size(distances,1)
      tmp_dists = cell2mat(distances{i});
      tmp_dirs  = cell2mat(directions{i});
      for j = 1:size(tmp_dists,2)
          coords(countSet+1,:) = next_position(coords(i,:),tmp_dirs(j,:),tmp_dists(j));
          countSet = countSet+1;
      end
  end 
end

end