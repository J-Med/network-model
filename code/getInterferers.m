function interferers = getInterferers(sender, receiver, freq, c_lvl, clustering, up1_down2, ANTENNAS, iHop, band, TDD_rates, iCluster)
%TODO this function
interferers1 = [];
interferers2 = [];
interferers_up = [];
interferers_down = [];
nInterferers1Added = 0;
nInterferers2Added = 0;

clusterIndices = clustering{c_lvl+1}.memberships;
% coordinates of all nodes at the current level (which is the same as
% 'positions' variable. It is the lower communication level of the two
% neighbors. That would be either end users or micros.

% check which fctn gives band as argument
% once I need downBands and once up bands, so bands should be fixed and up and down grouped probably
% after these fixes, it might work

% % for upper level
% node_lvl = iHop+1;
% if ANTENNAS.hop{iHop}.frequency == freq
%   sameBand.nodesIdx = band-1<=clustering{node_lvl}.downBands & clustering{node_lvl}.downBands<=band+1;
%   sameBand.nNodes = sum(sameBand.nodesIdx); %todo test this
%   %sameBand.IDs = clustering{node_lvl}.id(sameBand.nodesIdx);
%   sameBand.coords = clustering{node_lvl}.nodeCoords(sameBand.nodesIdx,:);
%   % nodes(end+1:end+1+n_nodes_in_sameBand) = nodes_in_sameBand;
% end
%
% for iNode = 1:sameBand.nNodes
%   %  interferers1(end+1).id = sameBand.IDs(iNode);
%   interferers1(end+1).xy = sameBand.coords(iNode,:);
%   interferers1(end).deployed = 1;
%   interferers1(end).radiatedPower = ANTENNAS.hop{iHop}.radiatedPower.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use iHop instead of identifying the specific hop.
%   nInterferers1Added = nInterferers1Added+1;
% end
%
% % for same level
% node_lvl = iHop;
% if ANTENNAS.hop{iHop}.frequency == freq
%   same_lvl_bands = clustering{iHop+1}.downBands(clustering{iHop+1}.memberships);
%   sameBand.nodesIdx = band-1<=same_lvl_bands & same_lvl_bands<=band+1;
%   sameBand.nNodes = sum(sameBand.nodesIdx); %todo test this
%   %sameBand.IDs = clustering{node_lvl}.id(sameBand.nodesIdx);
%   sameBand.coords = clustering{node_lvl}.nodeCoords(sameBand.nodesIdx,:);
%   % nodes(end+1:end+1+n_nodes_in_sameBand) = nodes_in_sameBand;
% end
%
% [slotNodesActivity, activeSlot] = get_active_slot_group(sameBand.nNodes, ANTENNAS.hop{iHop}.n_slots);
% for iNode = 1:sameBand.nNodes
%   %interferers2(end+1).id = sameBand.IDs(iNode);
%   interferers2(end+1).xy = sameBand.coords(iNode,:);
%   interferers2(end).deployed = slotNodesActivity(iNode);
%   interferers2(end).radiatedPower = ANTENNAS.hop{iHop}.radiatedPower.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use iHop instead of identifying the specific hop.
%   nInterferers2Added = nInterferers2Added+1;
% end

for hop = 1:2
  for level = hop:hop+1 % number of wireless hops
    %printf('%d %d\n',level,hop);
    if ANTENNAS.hop{hop}.frequency ~= freq
      continue
    end
    
    if hop==level % upstream
      if level >= 3
        continue
      end
      sameBand.nodesIdx = band-1<=clustering{level+1}.downBands(clustering{level+1}.memberships) & clustering{level+1}.downBands(clustering{level+1}.memberships)<=band+1;
      
    else % downstream
      if level <= 1
        continue
      end
      sameBand.nodesIdx = band-1<=clustering{level}.downBands & clustering{level}.downBands<=band+1;
    end
    
    if level==1
      %continue
    end
    if level == iHop
      sameBand.nodesIdx(clusterIndices == iCluster) = false;
    end
    b = sum(sameBand.nodesIdx);
    [slotNodesActivity, activeSlot] = getActiveSlotGroup(sum(sameBand.nodesIdx), ANTENNAS.hop{hop}.nSlots);
    allSameBandIndices = find(sameBand.nodesIdx);
    allActiveSameBandIndices = allSameBandIndices(slotNodesActivity);
    sameBand.nodesIdx = false(size(sameBand.nodesIdx)); %zero-out the indeces
    sameBand.nodesIdx(allActiveSameBandIndices) = true;
    sameBand.nNodes = sum(sameBand.nodesIdx); %todo test this
    %sameBand.IDs = clustering{node_lvl}.id(sameBand.nodesIdx);
    sameBand.coords = clustering{level}.nodeCoords(sameBand.nodesIdx,:);
    
    interferersX = [];
    for iNode = 1:sameBand.nNodes
      %  interferers1(end+1).id = sameBand.IDs(iNode);
      interferersX(end+1).xy = sameBand.coords(iNode,:);
      interferersX(end).deployed = 1;
      interferersX(end).radiatedPower = ANTENNAS.hop{hop}.radiatedPower.equipment{level};
      nInterferers1Added = nInterferers1Added+1;
    end
    
    if hop==level % upstream
      interferers_up = [interferers_up,interferersX];
    else % downstram
      interferers_down = [interferers_down,interferersX];
      
    end
  end
end

TDD_upstreamActive = rand(size(interferers_up,2),1) <= TDD_rates(1);
TDD_downstreamActive = rand(size(interferers_down,2),1) <= TDD_rates(2);
interferers = [];
interferers = [interferers,interferers_up(TDD_upstreamActive)];
interferers = [interferers,interferers_down(TDD_downstreamActive)];
%fprintf('%i\n',numel(interferers));
end

