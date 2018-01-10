function interferers = get_interferers(sender, receiver, freq, c_lvl, clustering, up1_down2, ANTENNAS, i_hop, band, TDD_rates, i_cluster)
%TODO this function
interferers1 = [];
interferers2 = [];
interferers_up = [];
interferers_down = [];
n_interferers1_added = 0;
n_interferers2_added = 0;

cluster_indices = clustering{c_lvl+1}.memberships;

% coordinates of all nodes at the current level (which is the same as
% 'positions' variable. It is the lower communication level of the two
% neighbors. That would be either end users or micros.

% check which fctn gives band as argument
% once I need down_bands and once up bands, so bands should be fixed and up and down grouped probably
% after these fixes, it might work

% % for upper level
% node_lvl = i_hop+1;
% if ANTENNAS.hop{i_hop}.frequency == freq
%   same_band.nodes_idx = band-1<=clustering{node_lvl}.down_bands & clustering{node_lvl}.down_bands<=band+1;
%   same_band.n_nodes = sum(same_band.nodes_idx); %todo test this
%   %same_band.IDs = clustering{node_lvl}.id(same_band.nodes_idx);
%   same_band.coords = clustering{node_lvl}.node_coords(same_band.nodes_idx,:);
%   % nodes(end+1:end+1+n_nodes_in_same_band) = nodes_in_same_band;
% end
%
% for i_node = 1:same_band.n_nodes
%   %  interferers1(end+1).id = same_band.IDs(i_node);
%   interferers1(end+1).xy = same_band.coords(i_node,:);
%   interferers1(end).deployed = 1;
%   interferers1(end).radiated_power = ANTENNAS.hop{i_hop}.radiated_power.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use i_hop instead of identifying the specific hop.
%   n_interferers1_added = n_interferers1_added+1;
% end
%
% % for same level
% node_lvl = i_hop;
% if ANTENNAS.hop{i_hop}.frequency == freq
%   same_lvl_bands = clustering{i_hop+1}.down_bands(clustering{i_hop+1}.memberships);
%   same_band.nodes_idx = band-1<=same_lvl_bands & same_lvl_bands<=band+1;
%   same_band.n_nodes = sum(same_band.nodes_idx); %todo test this
%   %same_band.IDs = clustering{node_lvl}.id(same_band.nodes_idx);
%   same_band.coords = clustering{node_lvl}.node_coords(same_band.nodes_idx,:);
%   % nodes(end+1:end+1+n_nodes_in_same_band) = nodes_in_same_band;
% end
%
% [slot_nodes_activity, active_slot] = get_active_slot_group(same_band.n_nodes, ANTENNAS.hop{i_hop}.n_slots);
% for i_node = 1:same_band.n_nodes
%   %interferers2(end+1).id = same_band.IDs(i_node);
%   interferers2(end+1).xy = same_band.coords(i_node,:);
%   interferers2(end).deployed = slot_nodes_activity(i_node);
%   interferers2(end).radiated_power = ANTENNAS.hop{i_hop}.radiated_power.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use i_hop instead of identifying the specific hop.
%   n_interferers2_added = n_interferers2_added+1;
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
      same_band.nodes_idx = band-1<=clustering{level+1}.down_bands(clustering{level+1}.memberships) & clustering{level+1}.down_bands(clustering{level+1}.memberships)<=band+1;
      
    else % downstream
      if level <= 1
        continue
      end
      same_band.nodes_idx = band-1<=clustering{level}.down_bands & clustering{level}.down_bands<=band+1;
    end
    
    if level==1
      %continue
    end
    
    if level == i_hop
      same_band.nodes_idx(cluster_indices == i_cluster) = false;
    end
    [slot_nodes_activity, active_slot] = get_active_slot_group(sum(same_band.nodes_idx), ANTENNAS.hop{hop}.n_slots);
    same_band.nodes_idx(~slot_nodes_activity) = false;

    same_band.n_nodes = sum(same_band.nodes_idx); %todo test this
    %same_band.IDs = clustering{node_lvl}.id(same_band.nodes_idx);
    same_band.coords = clustering{level}.node_coords(same_band.nodes_idx,:);
    
    interferersX = [];
    for i_node = 1:same_band.n_nodes
      %  interferers1(end+1).id = same_band.IDs(i_node);
      interferersX(end+1).xy = same_band.coords(i_node,:);
      interferersX(end).deployed = 1;
      interferersX(end).radiated_power = ANTENNAS.hop{hop}.radiated_power.equipment{level};
      n_interferers1_added = n_interferers1_added+1;
    end
    
    if hop==level % upstream
      interferers_up = [interferers_up,interferersX];
    else % downstram
      interferers_down = [interferers_down,interferersX];
      
    end
  end
end

TDD_upstream_active = rand(size(interferers_up,2),1) <= TDD_rates(1);
TDD_downstream_active = rand(size(interferers_down,2),1) <= TDD_rates(2);
interferers = [];
interferers = [interferers,interferers_up(TDD_upstream_active)];
interferers = [interferers,interferers_down(TDD_downstream_active)];
end

