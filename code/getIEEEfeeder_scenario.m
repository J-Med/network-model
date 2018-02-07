function [positions, sink_idx, data, max_delays, node_names] = getIEEEfeeder_scenario(scenario_size, sink_xy)
% returns eucledian coordinates of 13 feeders based on IEEE 13 Node Test
% Feeder [Kersting, 2001]

% INPUTS
% for no inputs function will set the offset to [0,0]
% offset    ...   [X,Y] 2-dim coordinate offset of the gateway node 650 -
%                 this is where coordinates setting will begin - useful for
%                 plotting purposes - recommendation would be [250,1600]
% sink_xy   ..  coordinates of sink(s) of size k,dim

%% Init
% clc;
% cla;
%run('LIB/my_library/my_library_path.m')
% run('../../../../../Matlab/my_library/my_library_path.m')
% rng(0); % Initialization of seed for random number generation

num = scenario_size;
data__max_delays = [
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
    
client_types = [
         321         448           1          50
        1344           0         100         Inf
        1665         448           1          50];

% client_types = [
%          321         448           1          50
%            0           0         Inf         Inf
%          321         448           1          50];
     
% client_types = [
%          321         448           1          50
%          321         448           1          50
%          321         448           1          50];
if scenario_size == 13
    
if nargin == 1
    sink_xy = [0,0];
end
offset = sink_xy;


%% define names, connections with distances, and calculate
node_names = {
%     '650'
    '632'
    '645'
    '633'
    '671'
    '646'
    '634'
    '684'
    '692'
    '680'
    '611'
    '652'
    '675'};

% data = [
%     321  448;
%     1665 448;
%     321  448;
%     1665 448;
%     1344 0;
%     321  448;
%     321  448;
%     1344 0;
%     1665 448;
%     1344 0;
%     321  448;
%     1344 0];
% 
% max_delays = [
%     1 50;
%     1 50;
%     1 50;
%     1 50;
%     100 0;
%     1 50;
%     1 50;
%     100 0;
%     1 50;
%     100 0;
%     1 50;
%     100 0];

data =       data__max_delays(:,1:2);
max_delays = data__max_delays(:,3:4);

sink_idx = 1;

distances = {
%     {609.6};                %650
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
%     {south};                %650
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

positions = zeros(size(distances,1),2);
positions(1,:) = pos_650;
count_set = 1;
for i = 1:size(distances,1)
    tmp_dists = cell2mat(distances{i});
    tmp_dirs  = cell2mat(directions{i});
    for j = 1:size(tmp_dists,2)
        positions(count_set+1,:) = next_position(positions(i,:),tmp_dirs(j,:),tmp_dists(j));
        count_set = count_set+1;
    end
end

else % scenario_size ~=13
%% define names, connections with distances, and calculate
% idx = randi(size(data__max_delays,1)-1,num,1)+1;
% data =       data__max_delays(idx,1:2);
% max_delays = data__max_delays(idx,3:4);

idx = randi(size(client_types,1),num,1);
data =       client_types(idx,1:2);
max_delays = client_types(idx,3:4);

IEEEcoords = csvread(num2str(scenario_size,'Buscoords%d.csv'),2,1);

sink_xy = mean(IEEEcoords);
s1 = size(sink_xy,1);
s2 = size(sink_xy,2);
i1 = size(IEEEcoords,1);
i2 = size(IEEEcoords,2);

data =      [zeros(s1,2);           data];
max_delays = [ones(s1,2)*Inf; max_delays];
node_names = cellstr(num2str((0:num+s1-1)','n%d'));

sink_idx = 1:s1;

positions = zeros(s1+i1, max(s2,i2));
positions(1:s1,1:s2) = sink_xy;
positions(s1+1:s1+i1,1:i2) = IEEEcoords;
    
end

end