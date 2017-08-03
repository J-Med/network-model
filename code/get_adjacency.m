function data_rates = get_adjacency(positions, clustering, ANTENNAS, CONFIG, clustering_level, up1_down2)
%%
%% INPUT
% 	clustering.membership
% 	clustering.coordsI
% 	clustering.coordsJ

% OUTPUT
% 	AdjacencyMat	MxN adjacency matrix where values indicate
%					        data rates in kilobits per second (kbps). The matrix
%                 is non-symmetrical as different antenna values should
%                 be used for upstream and downstream (over and under
%                 the main diagonal respectively)
%function [data_rates,max_receiving_rates,uniqueK_idx] = get_data_rates_kbps(positions,k,cluster_idx,micros_xy,network_technology)
%% INPUT
% positions         x,y coordinates of [sink; clients]
% cluster_idx       vector saying which cluster is each client belonging to
% network_technology  network technology of communication - possible inputs are
%                     '802.11g', 'WiMAX', 'LTE4G'
%% OUTPUT
% data_rates        data rates in kilobits per second - kbps in a symmetric
%                   matrix NxN with zeros on main diagonal
% max_rcv_rates     maximum stream of kbps that device with selected
%                   technology is able to receive and process

% ISO model of network

%%
% micro vector
% micro(i).deployed, id, radiated_power
% antenna.id, band
%% TODO - missing:
% antennna.band
% frequency
% micros, antenna .micro_radiated_power

%%
micros_positions = clustering{clustering_level+1}.CH_coords(:,1:2);
cluster_idx = clustering{clustering_level+1}.memberships;
k = clustering{clustering_level+1}.k_history(end); % take the last k from the list - clustering.k stores all ks in the hierarchy of clustering levels
%addpath 'ALTERADO_2'
% 1 bit/ms = 1 kbps
% 1e3 = 1Mbps
n_data = size(positions,1);
n_micros = size(micros_positions,1);
% if nargin == 4
%     adj = ones(num);
% else
%     adj = find(adjacency_mat>0);
%     adj = adj+adj';
% end

% undeploy duplicate micros (those that are at the same position)
deployed_micros = ones(n_micros,1);
temp = squareform(pdist(micros_positions));
[row,col]=find(temp==0);
for i = 1:numel(row)
  if deployed_micros(col(i))
    if row(i) ~= col(i)
      deployed_micros(row(i)) = 0;
    end
  end
end
[uniqueK_idx,~] = find(deployed_micros);

% Rememinder: level is (n+1). That is: 1 for no clustering, 2 for
% one clustering, etc.

freq = ANTENNAS.technology{clustering_level}.frequency; % [Hz]
antenna.radiated_power = ANTENNAS.technology{clustering_level}.radiated_power.equipment{clustering_level-1+up1_down2}; % [dBm]
antenna.band = ANTENNAS.technology{clustering_level}.bandwidth; % [Hz]


% if      level == 2 && up1_down2 == 1
%   % Antenna 1 transmitting - CPE
%   if strcmp('wifi', network_technology)
%     freq = ANTENNAS.wifi.frequency.level1_2; % [MHz]
%     antenna.radiated_power = ANTENNAS.wifi.radiated_power.cpe; % [dBm]
%     antenna.band = ANTENNAS.wifi.bandwidth.level1_2; % [Hz]
%   elseif strcmp('wimax', network_technology)
%     freq = ANTENNAS.wimax.frequency.level1_2; % [MHz]
%     antenna.radiated_power = ANTENNAS.wimax.radiated_power.cpe; % [dBm]
%     antenna.band = ANTENNAS.wimax.bandwidth.level1_2; % [Hz]
%   end
%
% elseif (level == 2 && up1_down2 == 2) || (level == 3 && up1_down2 == 1)
%   % Antenna 2 transmitting - small cell
%   if strcmp('wifi', network_technology)
%     if up1_down2 == 2 % downstream
%       freq = ANTENNAS.wifi.frequency.level1_2; % [MHz]
%       antenna.band = ANTENNAS.wifi.bandwidth.level1; % [Hz]
%     else % upstream
%       freq = ANTENNAS.wifi.frequency.level2_3; % [MHz]
%       antenna.band = ANTENNAS.wifi.bandwidth.level2_3; % [Hz]
%     end
%     antenna.radiated_power = ANTENNAS.wifi.radiated_power.small_cell; % [dBm]
%   elseif strcmp('wimax', network_technology)
%     if up1_down2 == 2 % downstream
%       freq = ANTENNAS.wimax.frequency.level1_2; % [MHz]
%       antenna.band = ANTENNAS.wimax.bandwidth.level1_2; % [Hz]
%     else % upstream
%       freq = ANTENNAS.wimax.frequency.level2_3; % [MHz]
%       antenna.band = ANTENNAS.wimax.bandwidth.level2_3; % [Hz]
%     end
%     antenna.radiated_power = ANTENNAS.wimax.radiated_power.small_cell; % [dBm]
%   end
%
% elseif  level == 3 && up1_down2 == 2
%   % Antenna 3 transmitting - macro cell
%   if strcmp('wifi', network_technology)
%     freq = ANTENNAS.wifi.frequency.level2_3;
%     antenna.radiated_power = ANTENNAS.wifi.radiated_power.macro_cell; % [dBm]
%     antenna.band = ANTENNAS.wifi.bandwidth.level2_3; % [Hz]
%   elseif strcmp('wimax', network_technology)
%     freq = ANTENNAS.wimax.frequency.level2_3; % [MHz]
%     antenna.radiated_power = ANTENNAS.wimax.radiated_power.macro_cell; % [dBm]
%     antenna.band = ANTENNAS.wimax.bandwidth.level2_3; % [Hz]
%   end
%
% else
%   error('Unexpected level: %d, up1_down2: %d', level, up1_down2)
% end
micro_radiated_power = antenna.radiated_power; % [dBm]

% add other devices/antennas on the same level as 'antenna'. That layer is
% one level/hop closer to the sink/server
for i = 1:n_micros
  micros(i).id = i;
  micros(i).xy = micros_positions(i,:);
  micros(i).deployed = deployed_micros(i);
  micros(i).radiated_power = micro_radiated_power;
end


n_micros_added = n_micros;
interference_from_other_lvls = 1;
if interference_from_other_lvls
  for c_lvl = 1:size(clustering,2)-1
    if c_lvl==clustering_level && up1_down2 == 2 % do not add the same micros from the same level
      continue
    end
    if c_lvl==size(clustering,2)-1 && up1_down2 == 1 % last level and upstream (nowhere to send data in this model)
      continue
    end
    if c_lvl == 1 && up1_down2 == 1 %equal to c_lvl-1+up1_down2 == 1 % skip interference caused by all the end users (at the lowest level)
      continue
    end
    if ANTENNAS.technology{clustering_level}.frequency ~= ANTENNAS.technology{c_lvl}.frequency
      continue % no interference if the frequency is different
    end

    micros_at_lvl = clustering{c_lvl-1+up1_down2}.CH_coords(:,1:2);
    for i = 1:size(micros_at_lvl,1)
      micros(i+n_micros_added).id = i+n_micros_added;
      micros(i+n_micros_added).xy = micros_at_lvl(i,:);
      micros(i+n_micros_added).deployed = 1;
      micros(i+n_micros_added).radiated_power = ANTENNAS.technology{c_lvl}.radiated_power.equipment{c_lvl-1+up1_down2};
    end
    n_micros_added = n_micros_added+i;
  end
end

% clustering_size = size(clustering,2);
% n_micros_added = 0;
% last_lvl = 0;
% for lvl = 1:clustering_size
%   if lvl == clustering_size
%     last_lvl = 1;
%   end
%   if sum(lvl == CONFIG.not_consider_i_interf_levels) == 0 % if I should not consider this level's interference, this does not pass
%     if freq == ANTENNAS.technology{lvl-last_lvl}.frequency % same frequency -> interference
%       micros_at_lvl = clustering{lvl}.CH_coords(:,1:2);
%       for i = 1:size(micros_at_lvl,1)
%         micros(i+n_micros_added).id = i+n_micros_added;
%         micros(i+n_micros_added).xy = micros_at_lvl(i,:);
%         micros(i+n_micros_added).deployed = 1;
%         micros(i+n_micros_added).radiated_power = ANTENNAS.technology{lvl-last_lvl}.radiated_power.equipment{lvl-1+up1_down2-last_lvl};
%       end
%       n_micros_added = n_micros_added+i;
%     end
%   end
% end



% ====== use adjacency here, pdist, some function
data_rates = zeros(n_data,k);
multipath = false;
if size(cluster_idx,2)>1; multipath = true; end
for i = 1:n_data
  if ~multipath
    user.xy = positions(i,:);
    user_micro = 0;
    antenna.xy = micros_positions(cluster_idx(i),:);
    antenna.id = 0;
    for i_micro = 1:size(micros,2)
      if micros(i_micro).xy == user.xy
        user_micro = i_micro;
      end
      if micros(i_micro).xy == antenna.xy
        antenna.id = i_micro;
      end
    end
    if user_micro ~= 0
      micros(user_micro).deployed = 0;
    end
    if antenna.id == 0
      error('antenna_id is %d',antenna.id)
    end
    
    
    j = antenna.id;
    [data_rates(i,j),~,~,inter] = calculateChannel(user,antenna,freq,micros);
    interf(i,:) = inter;
    %         disp([user.xy antenna.xy])
    %         disp([i j data_rates(i,j)])
    %     if isnan(data_rates(i,j))
    %         [i j]
    % %         pause
    %         antenna.xy = antenna.xy + [1e-10 0];
    %         calculateChannel(user,antenna,freq,micros)
    %     end
  else
    error('not implemented and tested branch.')
    for ii = 1:size(cluster_idx,2)
      antenna.id = cluster_idx(i,ii);
      j = antenna.id;
      antenna.xy = micros_positions(antenna.id,:);
      data_rates(i,j) = calculateChannel(user,antenna,freq,micros);
    end
  end
  if user_micro ~= 0
    micros(user_micro).deployed = 1;
  end
end
data_rates(data_rates==Inf) = CONFIG.DIRECT_LINK_DATA_RATE_ON_SITE;
% data_rates = 700e3./adj;
end