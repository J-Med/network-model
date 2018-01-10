%% TODOs
% antenna values - getAdjacency, line 73
% clustering techniques

% test correct indexing, i.e. {lvl}, {lvl-1}
% better result analysis

%% INFO
% x - data points - a list of 2D coordinates
% xCount - number of data points, such as 2649 or 12
clearvars
clear
rng(0);

run(['network_configs' filesep 'net_config1.m'])
run configuration
% sets tstPaths .. tests paths
%      clustering_levels ..          number of clustering levels
%      clustTechniques .. clustering techniques' names
%      k_set ..           number of clusters to test per level - in cell
%                         array of size {clustering_levels}

divide_per_bit = 1; %!!!!!!! this parameter needs to be changed in calc_delays_plot_topology, not here. It's here just as a reference
n_items = size(coords,1);

%% Start clustering
for i_cluster_config = 1:size(cluster_config,1)
  k_set{1} = cluster_config(i_cluster_config,1);
  k_set{2} = cluster_config(i_cluster_config,2);
  
  for technique = clustTechniques
    filename_c = ['clustered' filesep scenario_size filesep technique{1} '_' num2str(k_set{1}(1),'%d') '_' num2str(k_set{2}(1),'%d') '.mat'];
    if exist(filename_c, 'file') > 0
      fprintf('k: %i\n', k_set{1}(1))
      fprintf('k: %i\n', k_set{2}(1))
      load(filename_c);
    else
      clustering = my_cluster(technique, clustering_levels, k_set, coords, trials2run, ANTENNAS, CONFIG.show);
      save(filename_c, 'clustering');
    end
    for i_assignment = 1:n_assignments2run
      
      for up1_down2 = 1:2
        
        Adjacency_mat{clustering_levels} = [];
        for lvl = 1:clustering_levels
          Adjacency_mat{lvl+1} = get_adjacency(clustering{lvl}.node_coords(:,1:2), clustering, ANTENNAS, CONFIG, lvl, up1_down2);
          Adjacency_mat{lvl+1} = Adjacency_mat{lvl+1} * CONFIG.TDD_effective_rates(up1_down2);
        end
        
        %size of clustering struct needs to be the product of sizes of k_lvls kindof- for 2 and 1 it is 5, not 4
        % for 6 points to 3 clusters, membership looks like this: [1,0,0; 0,0,1; 0,1,0; 0,0,1; 1,0,0; 0,1,0]
        % it is a matrix of dim. pointCount * k - in clustering pointCount>=k
        bits{up1_down2,1} = bits_in{i_assignment}(:,up1_down2); %bits to transfer between x and lvl1 clusters
        for lvl = 2:clustering_levels+1
          % Sum bits flowing through cluster heads of this level.
          % Traffic of each cluster head is a sum of its members - given by
          % memberships. Use previous layer/level bits matrix
          bits_tmp = zeros(1,1);
          for i_cluster = unique(clustering{lvl}.memberships)'
            cluster_members_idx = clustering{lvl}.memberships==i_cluster;
            bits_tmp(i_cluster,:) = sum(bits{up1_down2,lvl-1}(cluster_members_idx,:),1);
          end
          bits{up1_down2,lvl} = bits_tmp; %bits to transfer between lvl-1 and lvl clusters
        end
        
        %% Compute delays on each level (for upstream and downstream simultaneously or separately)
        
        % delaysXY is a 1*k row vector representing delay when transfering
        % between lvlX and lvlY [ms]
        %    make sure the delay is ms
        %    data rate kbps, volume  in bits
        delays{clustering_levels} = []; % [ms]
        for lvl = 1:clustering_levels
          delays{lvl} = compute_delays_up_down(Adjacency_mat{lvl+1}*1024, bits{up1_down2,lvl})*1000; %convert adjacency from kbps to bps, delays from s to ms
        end
        % Also add final delay from last level to server using variable to_sink_data_rate
        delays{clustering_levels+1} = compute_delays_up_down(ones(size(Adjacency_mat{clustering_levels+1},2),1) * CONFIG.to_sink_data_rate * 1024, bits{up1_down2,clustering_levels+1})*1000; %convert adjacency from kbps to bps, delays from s to ms
        
        %% Sum the delays on each level to get total delay for each original node
        % The delay of a node is a sum of delays from node to root
        
        % sum from root to leaves
        % backpropagate delay on tree nodes so that leaves contain the sum
        % of delays on the way to root - using matrix multiplication
        % only supports singlepath - meaning only one non-zero (positive)
        % number per membership matrix row.
        total_delays = delays{clustering_levels+1}; % for delay to/from server
        
        for lvl = clustering_levels:-1:1
          % expand the matrix, transforming by membership matrix
          total_delays = total_delays(clustering{lvl+1}.memberships,:);
          % add delays at this level
          total_delays = total_delays + delays{lvl};
        end
        total_delays(bits_in{i_assignment}(:,up1_down2)==0) = 0;
        
        % old version
        %   delays = delays01+delays12*clustering1.membership'+delays23*clustering2.membership';
        %   delay = delays{1};
        %   for lvl = 2:clustering_levels
        %     delay = delay+ delays{lvl}*clustering{lvl-1}.membership;
        %   end
        
        total_delays_up1_down2(:,up1_down2) = total_delays;
        if up1_down2 == 1
          Adjacency_mat_up = Adjacency_mat;
        elseif up1_down2 == 2
          Adjacency_mat_down = Adjacency_mat;
        end
      end
      
      analyze_results(technique, ANTENNAS.hop, maxDelays{i_assignment}, total_delays_up1_down2, bits, Adjacency_mat_up, Adjacency_mat_down, clustering, CONFIG);
    end
  end
end