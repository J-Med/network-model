%% TODOs
% indexing, i.e. {lvl}, {lvl-1}
% better result analysis

%% INFO
% x - data points - a list of 2D coordinates
% xCount - number of data points, such as 2649 or 12
clearvars
clear
rng(0);
iRun = 1;
%for iConfig = 1:8
for iConfig = 13:13
fileName = sprintf('netConfig%02d.m', iConfig);
run(['networkConfigs' filesep fileName])
run configuration
% sets tstPaths .. tests paths
%      clusteringLevels ..          number of clustering levels
%      clustTechniques .. clustering techniques' names
%      kSet ..           number of clusters to test per level - in cell
%                         array of size {clusteringLevels}

divide_per_bit = 1; %!!!!!!! this parameter needs to be changed in calc_delays_plot_topology, not here. It's here just as a reference
nItems = size(coords,1);

%% Start clustering
for iClusterConfig = 1:size(clusterConfig,1)
  kSet{1} = clusterConfig(iClusterConfig,1);
  kSet{2} = clusterConfig(iClusterConfig,2);
  
  for technique = clustTechniques
    filenameC = ['clustered' filesep scenarioSize filesep technique{1} '_' num2str(kSet{1}(1),'%d') '_' num2str(kSet{2}(1),'%d') '.mat'];
    if exist(filenameC, 'file') > 0
      load(filenameC);
    else
      clustering = myCluster(technique, clusteringLevels, kSet, coords, trials2run, ANTENNAS, CONFIG.show);
      save(filenameC, 'clustering');
    end

	  for up1Down2 = 1:2

      AdjacencyMat{clusteringLevels} = [];
      for lvl = 1:clusteringLevels
        AdjacencyMat{lvl+1} = getAdjacency(clustering{lvl}.nodeCoords(:,1:2), clustering, ANTENNAS, CONFIG, lvl, up1Down2);
        AdjacencyMat{lvl+1} = AdjacencyMat{lvl+1} * CONFIG.TDD_effectiveRates(up1Down2);
      end
        
	    for iAssignment = 1:nAssignments2run
		
        %size of clustering struct needs to be the product of sizes of k_lvls (kind of)- for 2 and 1 it is 5, not 4
        % for 6 points to 3 clusters, membership looks like this: [1,0,0; 0,0,1; 0,1,0; 0,0,1; 1,0,0; 0,1,0]
        % it is a matrix of dim. pointCount * k - in clustering pointCount>=k
        bits{up1Down2,1} = bitsIn{iAssignment}(:,up1Down2); %bits to transfer between x and lvl1 clusters
        for lvl = 2:clusteringLevels+1
          % Sum bits flowing through cluster heads of this level.
          % Traffic of each cluster head is a sum of its members - given by
          % memberships. Use previous layer/level bits matrix
          bitsTmp = zeros(1,1);
          for iCluster = unique(clustering{lvl}.memberships)'
            clusterMembersIdx = clustering{lvl}.memberships==iCluster;
            bitsTmp(iCluster,:) = sum(bits{up1Down2,lvl-1}(clusterMembersIdx,:),1);
          end
          bits{up1Down2,lvl} = bitsTmp; %bits to transfer between lvl-1 and lvl clusters
        end
        
        %% Compute delays on each level (for upstream and downstream simultaneously or separately)
        
        % delaysXY is a 1*k row vector representing delay when transferring
        % between lvlX and lvlY [ms]
        %    make sure the delay is ms
        %    data rate kbps, volume  in bits
        delays_ms{clusteringLevels} = []; % [ms]
        for lvl = 1:clusteringLevels
          delays_ms{lvl} = computeDelaysUpDown_ms(AdjacencyMat{lvl+1}*1024, bits{up1Down2,lvl}); %convert adjacency from kbps to bps
        end
        % Also add final delay from last level to server using variable TO_SINK_DATA_RATE
        delays_ms{clusteringLevels+1} = computeDelaysUpDown_ms(ones(size(AdjacencyMat{clusteringLevels+1},2),1) * CONFIG.TO_SINK_DATA_RATE * 1024, bits{up1Down2,clusteringLevels+1}); %convert adjacency from kbps to bps
        
        %% Sum the delays on each level to get total delay for each original node
        % The delay of a node is a sum of delays from node to root
        
        % sum from root to leaves
        % backpropagate delay on tree nodes so that leaves contain the sum
        % of delays on the way to root - using matrix multiplication
        % only supports single-path - meaning only one non-zero (positive)
        % number per membership matrix row.
        totalDelays_ms = delays_ms{clusteringLevels+1}; % for delay to/from server
        
        for lvl = clusteringLevels:-1:1
          % expand the matrix, transforming by membership matrix
          totalDelays_ms = totalDelays_ms(clustering{lvl+1}.memberships,:);
          % add delays at this level
          totalDelays_ms = totalDelays_ms + delays_ms{lvl};
        end
        totalDelays_ms(bitsIn{iAssignment}(:,up1Down2)==0) = 0;
        
        % old version
        %   delays = delays01+delays12*clustering1.membership'+delays23*clustering2.membership';
        %   delay = delays{1};
        %   for lvl = 2:clusteringLevels
        %     delay = delay+ delays{lvl}*clustering{lvl-1}.membership;
        %   end
        
        % totalDelaysUp1Down2(:,up1Down2) = totalDelays;
        % if up1Down2 == 1
        %   Adjacency_mat_up = AdjacencyMat;
        % elseif up1Down2 == 2
        %   Adjacency_mat_down = AdjacencyMat;
        % end
        fprintf('Run # %i\n', iRun);
        fprintf('k1: %i\n', kSet{1}(1))
        fprintf('k2: %i\n', kSet{2}(1))
        analyzeResults(technique, ANTENNAS.hop, maxDelays{iAssignment}, totalDelays_ms, bits, AdjacencyMat, clustering, up1Down2, CONFIG, delays_ms);
      iRun = iRun+1;
      end
    end
  end
end
end