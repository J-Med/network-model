% function [tstPaths, clustTechniques, levels, k_set] = configuration()
tests = [4];
tstPaths = '';
for test = tests
  tstPaths(end+1,:) = ['tst' filesep num2str(test,'%02d') '.in'];
end
clustTechniques = {'k-means'};%,'kernel_k-means'};%,'k-medoids','hierarch'};
trials2run = 10;
% levels = 2; % Value 1 means doing one clustering. Value 2 means doing
% first clustering on original coordinations and second clustering on
% coordinations of the first ones

clustering_levels = 2; %this number should be always fixed at 2 for this research
if clustering_levels~=2
  disp('levels - this number should be always fixed at 2 for this research')
  level
end
%k_set{1} = {10};
%k_set{2} = {3};
%   k_set{1} = {10:10:200};
%   k_set{2} = {5:5:40};
%   k_set{3} = {1:1:5};
CONFIG.show = false;

%   clustTechniques = {'k-means'};
%   k_set{1} = {100};
%   k_set{2} = {15};
%   %k_set{3} = {4};
cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
cluster_config = [40 2; 50 2; 80 2; 100 2; 100 3];
cluster_config = [50 3; 50 4];

scenario_size = '';
% [scenario_size, technology] = get_test(tstPaths(1,:));
if strcmp(scenario_size,'')
  scenario_size = '2469';%'2469'; % 13, 4, 906, 2469
  ANTENNAS.hop{1}.technology_name = 'wimax';
  ANTENNAS.hop{2}.technology_name = 'wimax';
end
n_assignments2run = 2;
for i_tmp = 1:n_assignments2run
  [coords, maxDelays{i_tmp}, bits_in{i_tmp}] = get_input(scenario_size);
end
CONFIG.to_sink_data_rate = 20*1024^2; % [kbps] tens of Gbps ethernet
CONFIG.DIRECT_LINK_DATA_RATE_ON_SITE = 40*1024^2; % [kbps] -> 10Gbps
CONFIG.not_consider_i_interf_levels = 1; % do not consider interference from lvl 1 (client antennas)
% equipment in levels: cpe, small cell, macro cell
CONFIG.TDD_rate = [9/15, 4/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one
%CONFIG.TDD_rate = [1, 1]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

% set configuration of antennas
if strcmp(ANTENNAS.hop{1}.technology_name,'wifi')
  ANTENNAS.hop{1}.frequency = 5.8e9; % 5.4 or 5.8   % [Hz][MHz] -> 2.4e3 = 2.4GHz % TODO 4
  ANTENNAS.hop{1}.radiated_power.equipment{1} = 20; % [dBm]
  ANTENNAS.hop{1}.gain.equipment{1}           =  0; % [dBm]
  ANTENNAS.hop{1}.radiated_power.equipment{2} = 40; % [dBm] ERP 30 - 40
  ANTENNAS.hop{1}.gain.equipment{2}           =  0; % [dBm] ERP 30 - 40
  ANTENNAS.hop{1}.bandwidth = 20e6; % [Hz] -> 22e6 = 22MHz
  ANTENNAS.hop{1}.n_bands = 11; % EU restricted, US
  ANTENNAS.hop{1}.n_slots = 15; % 3GPP
  
elseif strcmp(ANTENNAS.hop{1}.technology_name,'wimax')
  ANTENNAS.hop{1}.frequency = 3.5e9; % [MHz] 3.5 preffered (Bruno Lyra) 2.5e3 or 3.5e3 according to wiki page List_of_WiMAX_networks % TODO 4
  ANTENNAS.hop{1}.radiated_power.equipment{1} = 10; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
  ANTENNAS.hop{1}.gain.equipment{1}           =  3; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
  ANTENNAS.hop{1}.radiated_power.equipment{2} = 30; % [dBm], gain 10-15
  ANTENNAS.hop{1}.gain.equipment{2}           = 15; % [dBm], gain 10-15
  ANTENNAS.hop{1}.bandwidth = 10e6; % [Hz] 1.25, 5, 10, 20
  ANTENNAS.hop{1}.n_bands = 11; % EU restricted, US
  ANTENNAS.hop{1}.n_slots = 15; % 3GPP
end

if strcmp(ANTENNAS.hop{2}.technology_name,'wimax')
  ANTENNAS.hop{2}.frequency = 3.5e9; % [Hz]
  ANTENNAS.hop{2}.radiated_power.equipment{2} = 30; % [dBm], gain 10-15
  ANTENNAS.hop{2}.gain.equipment{2}           = 15; % [dBm], gain 10-15
  ANTENNAS.hop{2}.radiated_power.equipment{3} = 43; % [dBm], gain 15-20
  ANTENNAS.hop{2}.gain.equipment{3}           = 20; % [dBm], gain 15-20
  ANTENNAS.hop{2}.bandwidth = 20e6; % [Hz] % what the whole equipment (including radio and antenna) supports
  ANTENNAS.hop{2}.n_bands = 11; % EU restricted, US
  ANTENNAS.hop{2}.n_slots = 15; % 3GPP
else
  error('unexpected technology: %s', ANTENNAS.hop{2}.technology_name)
end

% =================== previous research mode =====================
% else
%   if strcmp(ANTENNAS.hop{1}.technology_name,'wimax')
%   ANTENNAS.hop{1}.frequency = 2.5e9; % 5.4 or 5.8   % [MHz] -> 2.4e3 = 2.4GHz % TODO 4
%   ANTENNAS.hop{1}.radiated_power.equipment{1} = 43; % [dBm]
%   ANTENNAS.hop{1}.radiated_power.equipment{2} = 43; % [dBm] ERP 30 - 40
%   ANTENNAS.hop{1}.bandwidth = 10e6; % [Hz] -> 22e6 = 22MHz
%
%   clustering_levels = 1;
%   k_set{1} = {10};
%   end
% end

% fprintf('****** just testing some other values of equipment ******\n');
% if strcmp(ANTENNAS.technology{1}.name,'wifi')
%   ANTENNAS.technology{1}.frequency = 5.8e9; % 5.4 or 5.8   % [Hz][MHz] -> 2.4e3 = 2.4GHz % TODO 4
%   ANTENNAS.technology{1}.radiated_power.equipment{1} = 10; % [dBm]
%   ANTENNAS.technology{1}.radiated_power.equipment{2} = 40; % [dBm] ERP 30 - 40
%   ANTENNAS.technology{1}.bandwidth = 20e6; % [Hz] -> 22e6 = 22MHz
% elseif strcmp(ANTENNAS.technology{1}.name,'wimax')
%   ANTENNAS.technology{1}.frequency = 3.5e9; % [MHz] 3.5 preffered (Bruno Lyra) 2.5e3 or 3.5e3 according to wiki page List_of_WiMAX_networks % TODO 4
%   ANTENNAS.technology{1}.radiated_power.equipment{1} = 5+3; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
%   ANTENNAS.technology{1}.radiated_power.equipment{2} = 30+15; % [dBm], gain 10-15
%   ANTENNAS.technology{1}.bandwidth = 10e6; % [Hz] 1.25, 5, 10, 20
% end
% if strcmp(ANTENNAS.technology{2}.name,'wimax')
% ANTENNAS.technology{2}.frequency = 3.5e9; % [MHz] % TODO 4
% ANTENNAS.technology{2}.radiated_power.equipment{2} = 30+5; % [dBm], gain 10-15
% ANTENNAS.technology{2}.radiated_power.equipment{3} = 43+20; % [dBm], gain 15-20
% ANTENNAS.technology{2}.bandwidth = 20e6; % [Hz] %bandwidth - what the whole equipment (including radio and antenna supports
% end