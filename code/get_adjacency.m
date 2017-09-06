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

micros_positions = clustering{clustering_level+1}.CH_coords(:,1:2);
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
hop_idx = clustering_level-1+up1_down2; % 1 for 1st level (user/IED <-> small cell), 2 for 2nd level (small cell <-> macro) etc.
freq = ANTENNAS.technology{clustering_level}.frequency; % [Hz]
antenna.radiated_power = ANTENNAS.technology{clustering_level}.radiated_power.equipment{hop_idx}; % [dBm]
antenna.band = ANTENNAS.technology{clustering_level}.bandwidth; % [Hz]
micro_radiated_power = antenna.radiated_power; % [dBm]

n_micros_added = 0;
micros = [];
% coordinates of all nodes at the current level (which is the same as
% 'positions' variable. It is the lower communication level of the two
% neighbors. That would be either end users or micros.
all_micros_disabled_for_interference = 1;
if up1_down2 == 1
  all_micros_disabled_for_interference = 0;
  coords_at_lvl = clustering{clustering_level}.CH_coords(:,1:2);
  for i = 1:size(coords_at_lvl,1)
    micros(i+n_micros_added).id = i+n_micros_added;
    micros(i+n_micros_added).xy = coords_at_lvl(i,:);
    % let us deploy only those which share the same frequency - same
    % cluster and same level. We will use different frequency band per
    % cluster. For now undeploy all and turn them on when we know which
    % cluster are we dealing with when we select our 'user'
    micros(i+n_micros_added).deployed = 0;
    micros(i+n_micros_added).radiated_power = ANTENNAS.technology{clustering_level}.radiated_power.equipment{hop_idx};
  end
  n_micros_added = n_micros_added+i;
end

% ====== use adjacency here, pdist, some function
data_rates = zeros(n_data,k);
multipath = false;
if size(cluster_idx,2)>1; multipath = true; end
for i = 1:n_data
 % fprintf('%d of %d: ', i, n_data)
  %every time make sure all is undeployed = ready & clean to use
  cells0 = num2cell(zeros(size(micros,2),1));
  cells1 = num2cell(ones(size(micros,2),1));
  if size(micros,1) ~= 0
    [micros.deployed] = cells0{:}; % this functinality is summarized as disperse fun
  end
  if ~multipath
    user.xy = positions(i,:);
    %user_micro = 0;
    current_cluster_members_idx = clustering{clustering_level+1}.memberships == cluster_idx(i); % TODO this is weird - memberships should be together with original locations. Or not?
    if ~all_micros_disabled_for_interference
      [micros(current_cluster_members_idx).deployed] = cells1{1:sum(current_cluster_members_idx)};
    else
      current_cluster_members_idx = [];
    end
    antenna.xy = micros_positions(cluster_idx(i),:);
    antenna.id = n_micros_added+1;
    for i_micro = 1:size(micros,2)
      if micros(i_micro).xy == user.xy
        user_micro = i_micro;
        micros(user_micro).deployed = 0; % we do not want interference to be caused by our user
      end
      if micros(i_micro).xy == antenna.xy
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
      error('antenna_id is %d',antenna.id)
    end
    
%     if cluster_idx(i) == 12
%       fprintf('12\n')
%     end
    j = cluster_idx(i);
    [data_rates(i,j),~,~,inter] = calculateChannel(user,antenna,freq,micros(current_cluster_members_idx));
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