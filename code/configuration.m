if strcmp(scenarioSize,'13')
  scenarioSize = '12';
end

clustTechniques = {'k-means'};%,'kernel_k-means'};%,'k-medoids','hierarch'};
trials2run = 10;
% levels = 2; % Value 1 means doing one clustering. Value 2 means doing
% first clustering on original coordinations and second clustering on
% coordinations of the first ones

clusteringLevels = 2; %this number should be always fixed at 2 for this research
if clusteringLevels~=2
  disp('levels - this number should be always fixed at 2 for this research')
  level
end

CONFIG.show = false; % show graphics?

nAssignments2run = 5; % number of times the network users will have reassigned categories (normal mode and restricted mode)

nAssignments2run = nAssignments2run*2; %once as normal mode, once as restricted mode
for iTmp = 1:2:nAssignments2run
  [coords, maxDelays{iTmp}, bitsIn{iTmp}, idx] = getInput(scenarioSize, false); %normal mode
  [coords, maxDelays{iTmp+1}, bitsIn{iTmp+1}, ~] = getInput(scenarioSize, true, idx); %restricted mode
end
CONFIG.TO_SINK_DATA_RATE = 10*1024^2; % [kbps] tens of Gbps ethernet
CONFIG.DIRECT_LINK_DATA_RATE_ON_SITE = 10*1024^2; % [kbps] -> 10Gbps
% CONFIG.NOT_CONSIDER_I_INTERF_LEVELS = 1; % do not consider interference from lvl 1 (client antennas)
% equipment in levels: cpe, small cell, macro cell
% CONFIG.TDD_rate = [11/15, 4/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one
%CONFIG.TDD_rate = [1, 1]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

% set configuration of antennas
if strcmp(ANTENNAS.hop{1}.technologyName,'wifi')
  ANTENNAS.hop{1}.frequency = 2.4e9;%5.8e9; % 5.4 or 5.8   % [Hz][MHz] -> 2.4e3 = 2.4GHz % TODO 4
  ANTENNAS.hop{1}.radiatedPower.equipment{1} = 20; % [dBm]
  ANTENNAS.hop{1}.gain.equipment{1}           =  0; % [dBm]
  ANTENNAS.hop{1}.radiatedPower.equipment{2} = 40; % [dBm] ERP 30 - 40
  ANTENNAS.hop{1}.gain.equipment{2}           =  0; % [dBm] ERP 30 - 40
  ANTENNAS.hop{1}.bandwidth = 20e6; % [Hz] -> 22e6 = 22MHz
  ANTENNAS.hop{1}.nBands = 11; % EU restricted, US
  ANTENNAS.hop{1}.nSlots = 15; % 3GPP
  
elseif strcmp(ANTENNAS.hop{1}.technologyName,'wimax')
  ANTENNAS.hop{1}.frequency = 3.5e9; % [MHz] 3.5 preffered (Bruno Lyra) 2.5e3 or 3.5e3 according to wiki page List_of_WiMAX_networks % TODO 4
  ANTENNAS.hop{1}.radiatedPower.equipment{1} = 10; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
  ANTENNAS.hop{1}.gain.equipment{1}           =  3; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
  ANTENNAS.hop{1}.radiatedPower.equipment{2} = 30; % [dBm], gain 10-15
  ANTENNAS.hop{1}.gain.equipment{2}           = 15; % [dBm], gain 10-15
  ANTENNAS.hop{1}.bandwidth = 10e6; % [Hz] 1.25, 5, 10, 20
  ANTENNAS.hop{1}.nBands = 11; % EU restricted, US
  ANTENNAS.hop{1}.nSlots = 15; % 3GPP
end

if strcmp(ANTENNAS.hop{2}.technologyName,'wimax')
  ANTENNAS.hop{2}.frequency = 3.5e9; % [Hz]
  ANTENNAS.hop{2}.radiatedPower.equipment{2} = 30; % [dBm], gain 10-15
  ANTENNAS.hop{2}.gain.equipment{2}           = 15; % [dBm], gain 10-15
  ANTENNAS.hop{2}.radiatedPower.equipment{3} = 43; % [dBm], gain 15-20
  ANTENNAS.hop{2}.gain.equipment{3}           = 20; % [dBm], gain 15-20
  ANTENNAS.hop{2}.bandwidth = 10e6; % [Hz] % what the whole equipment (including radio and antenna) supports
  ANTENNAS.hop{2}.nBands = 11; % EU restricted, US
  ANTENNAS.hop{2}.nSlots = 15; % 3GPP
else
  error('unexpected technology: %s', ANTENNAS.hop{2}.technologyName)
end

% =================== previous research mode =====================
% else
%   if strcmp(ANTENNAS.hop{1}.technologyName,'wimax')
%   ANTENNAS.hop{1}.frequency = 2.5e9; % 5.4 or 5.8   % [MHz] -> 2.4e3 = 2.4GHz % TODO 4
%   ANTENNAS.hop{1}.radiatedPower.equipment{1} = 43; % [dBm]
%   ANTENNAS.hop{1}.radiatedPower.equipment{2} = 43; % [dBm] ERP 30 - 40
%   ANTENNAS.hop{1}.bandwidth = 10e6; % [Hz] -> 22e6 = 22MHz
%
%   clusteringLevels = 1;
%   k_set{1} = {10};
%   end
% end

% fprintf('****** just testing some other values of equipment ******\n');
% if strcmp(ANTENNAS.technology{1}.name,'wifi')
%   ANTENNAS.technology{1}.frequency = 5.8e9; % 5.4 or 5.8   % [Hz][MHz] -> 2.4e3 = 2.4GHz % TODO 4
%   ANTENNAS.technology{1}.radiatedPower.equipment{1} = 10; % [dBm]
%   ANTENNAS.technology{1}.radiatedPower.equipment{2} = 40; % [dBm] ERP 30 - 40
%   ANTENNAS.technology{1}.bandwidth = 20e6; % [Hz] -> 22e6 = 22MHz
% elseif strcmp(ANTENNAS.technology{1}.name,'wimax')
%   ANTENNAS.technology{1}.frequency = 3.5e9; % [MHz] 3.5 preffered (Bruno Lyra) 2.5e3 or 3.5e3 according to wiki page List_of_WiMAX_networks % TODO 4
%   ANTENNAS.technology{1}.radiatedPower.equipment{1} = 5+3; % [dBm] ERP: transmit power 10 + gain 3 modem wimax
%   ANTENNAS.technology{1}.radiatedPower.equipment{2} = 30+15; % [dBm], gain 10-15
%   ANTENNAS.technology{1}.bandwidth = 10e6; % [Hz] 1.25, 5, 10, 20
% end
% if strcmp(ANTENNAS.technology{2}.name,'wimax')
% ANTENNAS.technology{2}.frequency = 3.5e9; % [MHz] % TODO 4
% ANTENNAS.technology{2}.radiatedPower.equipment{2} = 30+5; % [dBm], gain 10-15
% ANTENNAS.technology{2}.radiatedPower.equipment{3} = 43+20; % [dBm], gain 15-20
% ANTENNAS.technology{2}.bandwidth = 20e6; % [Hz] %bandwidth - what the whole equipment (including radio and antenna supports
% end