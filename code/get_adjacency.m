function data_rates = get_adjacency(positions, clustering, ANTENNAS, CONFIG, clustering_level, up1_down2)
% INPUT
%   positions     Coordinates of current level of the communication
%                 network. For example of all users of all macro cells etc.
%                 [n, 2] dim vector.
%   clustering    The results of clustering. Cells of structures reporting
%                 about the clusterization at each level. clustering{1} 
%                 stores the original positions in variable CH_coords, 
%                 next_k, and idx Results of first
%                 clusterization are performed on the original data and
%                 are stored in clustering{2}. This might change in the
%                 future and it would be stored at clustering{1}. 
%     .CH_coords  [n, 2] dim vector of positions of nodes at the level {i}
%     .memberships  vector dim [n, 1] of memberships that indicates to which
%                 cluster do all of n cluster heads from previous level
%                 belong to.
%     .next_k     scalar - the next value of k - used only during clustering (not here)
%     .idx        vector dim [1, some] - index of this specifc clustering.
%                 Serves as an ID and is an unused variable
%     .k_history  vector dim [1, i_k] of all of the the previous k values used
%                 
%   ANTENNAS      values of antennas and equipment defined in configuration.m
%   CONFIG        other model definitions from configuration.m
%   clustering_level  the clustering level of these positions. Value i
%                 indicates one clustering was performed, nodes have their
%                 positions at clustering{i}.CH_coords and their cluster
%                 heads are at clustering{i+1}.CH_coords. Cluster
%                 memberships for each node are at
%                 clustering{i+1}.memberships
%   up1_down2     indicates stream mode - value 1 for upstream, 2 for downstream

% OUTPUT
% 	data_rates  	MxN adjacency matrix where values indicate
%					        data rates in kilobits per second (kbps). The matrix
%                 is non-symmetrical as different antenna values should
%                 be used for upstream and downstream (over and under
%                 the main diagonal respectively)

% ISO model of network

%
% micro vector
% micro(i).deployed, id, radiated_power
% antenna.id, band

micros_positions = clustering{clustering_level+1}.node_coords(:,1:2);
cluster_idx = clustering{clustering_level+1}.memberships;
k = clustering{clustering_level+1}.k_history(end); % take the last k from the list - clustering.k stores all ks in the hierarchy of clustering levels
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
i_hop = clustering_level; % 1 for 1st level (user/IED <-> small cell), 2 for 2nd level (small cell <-> macro) etc.
freq = ANTENNAS.hop{clustering_level}.frequency; % [Hz]
sender.radiated_power = ANTENNAS.hop{clustering_level}.radiated_power.equipment{i_hop}; % [dBm]
sender.gain   = ANTENNAS.hop{clustering_level}.gain.equipment{i_hop}; % [dBm]
sender.bandwidth   = ANTENNAS.hop{clustering_level}.bandwidth; % [Hz]
receiver.gain = ANTENNAS.hop{clustering_level}.gain.equipment{clustering_level+2-up1_down2}; % [dBm]

all_micros_disabled_for_interference = 0;


data_rates = zeros(n_data,k);
multipath = false;
if size(cluster_idx,2)>1; multipath = true; end
for i = 1:n_data
  band_idx = clustering{i_hop+1}.memberships(i);

%   if up1_down2 == 1
%     band_idx = clustering{i_hop+1}.memberships(i);
%   elseif up1_down2 == 2
%     band_idx = i;
%   end
  i_band = clustering{i_hop+1}.down_bands(band_idx);
  interferers = get_interferers(sender, receiver, freq, clustering_level, clustering, up1_down2, ANTENNAS, i_hop, i_band);
  n_interferers_added = size(interferers,1);
 % fprintf('%d of %d: ', i, n_data)
  %every time make sure all is undeployed = ready & clean to use
%   cells0 = num2cell(zeros(size(interferers,2),1));
%   cells1 = num2cell(ones(size(interferers,2),1));
%   if size(interferers,1) ~= 0
%     [interferers.deployed] = cells0{:}; % this assignment functinality is called disperse function
%   end
  if ~multipath
    user.xy = positions(i,:);
    %user_micro = 0;
%     current_cluster_members_idx = clustering{clustering_level+1}.memberships == cluster_idx(i); % TODO this is weird - memberships should be together with original locations. Or not?
%     if ~all_micros_disabled_for_interference
%       [interferers(current_cluster_members_idx).deployed] = cells1{1:sum(current_cluster_members_idx)};
%     else
%       current_cluster_members_idx = [];
%     end
    antenna.xy = micros_positions(cluster_idx(i),:);
    antenna.id = n_interferers_added+1;
    user.id    = n_interferers_added+2;

    for i_micro = 1:size(interferers,2)
      if interferers(i_micro).xy == user.xy
        interferers(i_micro).deployed = 0; % we do not want interference to be caused by our user
        user.id = i_micro;
      end
      if interferers(i_micro).xy == antenna.xy
        antenna.id = i_micro;
      end
    end

    % not always user's equipment is among those in a list that cause
    % interference. But when it is, undeploy it, calculate channel and turn
    % it back on (some lines below at the end of the for loop) so that it
    % is set as "deployed" for interference calculations for other users.
%     if user_micro ~= 0
%       micros(user_micro).deployed = 0; % actually we won't use it since
%       we keep all micros' deployed at 0 and only turn on some.
%     end
    if antenna.id == 0
      error('antenna.id is %d',antenna.id)
    end
    if user.id == 0
      error('user.id is %d',user.id)
    end
    
%     if cluster_idx(i) == 12
%       fprintf('12\n')
%     end
    j = cluster_idx(i);
    if up1_down2 == 1      % user    is sender, antenna is receiver
      receiver.xy = antenna.xy;
      receiver.id = antenna.id;
      sender.xy   = user.xy;
      sender.id   = user.id;
    elseif up1_down2 == 2  % antenna is sender, user    is receiver
      sender.xy   = antenna.xy;
      sender.id   = antenna.id;
      receiver.xy = user.xy;
      receiver.id = user.id;
    end
    
    [data_rates(i,j),~,~,inter] = calculateChannel(sender,receiver,freq,interferers);
    %interf(i,:) = inter; different size every time
    %         disp([user.xy antenna.xy])
    %         disp([i j data_rates(i,j)])
    %     if isnan(data_rates(i,j))
    %         [i j]
    % %         pause
    %         antenna.xy = antenna.xy + [1e-10 0];
    %         calculateChannel(user,antenna,freq,micros)
    %     end
  else
    error('not implemented and tested branch. Refer to previous versions (june2017) for ideas')
  end

%   if user_micro ~= 0
%     micros(user_micro).deployed = 1;
%   end
end
data_rates(data_rates==Inf) = CONFIG.DIRECT_LINK_DATA_RATE_ON_SITE;
end