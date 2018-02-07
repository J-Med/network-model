function dataRates = getAdjacency(positions, clustering, ANTENNAS, CONFIG, clusteringLevel, up1Down2)
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
%   clusteringLevel  the clustering level of these positions. Value i
%                 indicates one clustering was performed, nodes have their
%                 positions at clustering{i}.CH_coords and their cluster
%                 heads are at clustering{i+1}.CH_coords. Cluster
%                 memberships for each node are at
%                 clustering{i+1}.memberships
%   up1Down2     indicates stream mode - value 1 for upstream, 2 for downstream

% OUTPUT
% 	dataRates  	MxN adjacency matrix where values indicate
%					        data rates in kilobits per second (kbps). The matrix
%                 is non-symmetrical as different antenna values should
%                 be used for upstream and downstream (over and under
%                 the main diagonal respectively)

% ISO model of network

%
% micro vector
% micro(i).deployed, id, radiatedPower
% antennaBigger.id, band

microsPositions = clustering{clusteringLevel+1}.nodeCoords(:,1:2);
clusterIndices = clustering{clusteringLevel+1}.memberships;
k = clustering{clusteringLevel+1}.k_history(end); % take the last k from the list - clustering.k stores all ks in the hierarchy of clustering levels
nData = size(positions,1);
nMicros = size(microsPositions,1);
% if nargin == 4
%     adj = ones(num);
% else
%     adj = find(adjacency_mat>0);
%     adj = adj+adj';
% end

% undeploy duplicate micros (those that are at the same position)
deployedMicros = ones(nMicros,1);
temp = squareform(pdist(microsPositions));
[row,col]=find(temp==0);
for i = 1:numel(row)
  if deployedMicros(col(i))
    if row(i) ~= col(i)
      deployedMicros(row(i)) = 0;
    end
  end
end
[uniqueK_idx,~] = find(deployedMicros);

% Rememinder: level is (n+1). That is: 1 for no clustering, 2 for
% one clustering, etc.
iHop = clusteringLevel; % 1 for 1st level (user/antennaSmaller/IED <-> small cell), 2 for 2nd level (small cell <-> macro) etc.
freq = ANTENNAS.hop{clusteringLevel}.frequency; % [Hz]
sender.radiatedPower = ANTENNAS.hop{clusteringLevel}.radiatedPower.equipment{iHop}; % [dBm]
sender.gain   = ANTENNAS.hop{clusteringLevel}.gain.equipment{iHop}; % [dBm]
sender.bandwidth   = ANTENNAS.hop{clusteringLevel}.bandwidth; % [Hz]
receiver.gain = ANTENNAS.hop{clusteringLevel}.gain.equipment{clusteringLevel+2-up1Down2}; % [dBm]

ALL_MICROS_DISABLED_FOR_INTERFERENCE = 0;


dataRates = zeros(nData,k);
multipath = false;
if size(clusterIndices,2)>1; multipath = true; end
for i = 1:nData
  bandIdx = clustering{iHop+1}.memberships(i);

%   if up1Down2 == 1
%     bandIdx = clustering{iHop+1}.memberships(i);
%   elseif up1Down2 == 2
%     bandIdx = i;
%   end
  iBand = clustering{iHop+1}.downBands(bandIdx);
  interferers = getInterferers(sender, receiver, freq, clusteringLevel, clustering, up1Down2, ANTENNAS, iHop, iBand, CONFIG.TDD_rates, clusterIndices(i));
  nInterferersAdded = size(interferers,1);

 % fprintf('%d of %d: ', i, nData)
  %every time make sure all is undeployed = ready & clean to use
%   cells0 = num2cell(zeros(size(interferers,2),1));
%   cells1 = num2cell(ones(size(interferers,2),1));
%   if size(interferers,1) ~= 0
%     [interferers.deployed] = cells0{:}; % this assignment functionality is called disperse function
%   end
  if ~multipath
    antennaSmaller.xy = positions(i,:);
    %user_micro = 0;
%     current_cluster_members_idx = clustering{clusteringLevel+1}.memberships == clusterIndices(i); % TODO this is weird - memberships should be together with original locations. Or not?
%     if ~all_micros_disabled_for_interference
%       [interferers(current_cluster_members_idx).deployed] = cells1{1:sum(current_cluster_members_idx)};
%     else
%       current_cluster_members_idx = [];
%     end
    antennaBigger.xy = microsPositions(clusterIndices(i),:);
    antennaBigger.id = nInterferersAdded+1;
    antennaSmaller.id = nInterferersAdded+2;

    for iMicro = 1:numel(interferers)
      if interferers(iMicro).xy == antennaSmaller.xy
        interferers(iMicro).deployed = 0; % we do not want interference to be caused by our antennaSmaller
        antennaSmaller.id = iMicro;
      else
        interferers(iMicro).deployed = 1;
      end
      if interferers(iMicro).xy == antennaBigger.xy
        antennaBigger.id = iMicro;
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
    if antennaBigger.id == 0
      error('antennaBigger.id is %d',antennaBigger.id)
    end
    if antennaSmaller.id == 0
      error('antennaSmaller.id is %d',antennaSmaller.id)
    end
    
%     if clusterIndices(i) == 12
%       fprintf('12\n')
%     end
    j = clusterIndices(i);
	  nReceivers = 1;
    if up1Down2 == 1      % antennaSmaller    is sender, antennaBigger is receiver
      receiver.xy = antennaBigger.xy;
      receiver.id = antennaBigger.id;
      sender.xy   = antennaSmaller.xy;
      sender.id   = antennaSmaller.id;
    elseif up1Down2 == 2  % antennaBigger is sender, antennaSmaller    is receiver
      sender.xy   = antennaBigger.xy;
      sender.id   = antennaBigger.id;
      receiver.xy = antennaSmaller.xy;
      receiver.id = antennaSmaller.id;
	    nReceivers = sum(clusterIndices(clusterIndices == i));
    end
    
    [dataRates(i,j),~,~,inter] = calculateChannel(sender,receiver,freq,interferers,nReceivers);
    %interf(i,:) = inter; different size every time
    %         disp([antennaSmaller.xy antennaBigger.xy])
    %         disp([i j dataRates(i,j)])
    %     if isnan(dataRates(i,j))
    %         [i j]
    % %         pause
    %         antennaBigger.xy = antennaBigger.xy + [1e-10 0];
    %         calculateChannel(antennaSmaller,antennaBigger,freq,micros)
    %     end
  else
    error('not implemented and tested branch. Refer to previous versions (june2017) for ideas')
  end

%   if user_micro ~= 0
%     micros(user_micro).deployed = 1;
%   end
end
dataRates(dataRates==Inf) = CONFIG.DIRECT_LINK_DATA_RATE_ON_SITE;
end