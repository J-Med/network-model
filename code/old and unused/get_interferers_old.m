function interferers = get_interferers(sender, receiver, freq, c_lvl, clustering, up1_down2, ANTENNAS, i_hop, band, TDD_rates)
%TODO this function
interferers1 = [];
interferers2 = [];
n_interferers1_added = 0;
n_interferers2_added = 0;
% coordinates of all nodes at the current level (which is the same as
% 'positions' variable. It is the lower communication level of the two
% neighbors. That would be either end users or micros.

% check which fctn gives band as argument
% once I need down_bands and once up bands, so bands should be fixed and up and down grouped probably
% after these fixes, it might work

% for upper level
node_lvl = i_hop+1;
if ANTENNAS.hop{i_hop}.frequency == freq
  same_band.nodes_idx = clustering{node_lvl}.down_bands==band;
  same_band.nodes_idx = band-1<=clustering{node_lvl}.down_bands & clustering{node_lvl}.down_bands<=band+1;
  same_band.n_nodes = sum(same_band.nodes_idx); %todo test this
  %same_band.IDs = clustering{node_lvl}.id(same_band.nodes_idx);
  same_band.coords = clustering{node_lvl}.node_coords(same_band.nodes_idx,:);
  % nodes(end+1:end+1+n_nodes_in_same_band) = nodes_in_same_band;
end

for i_node = 1:same_band.n_nodes
%  interferers1(end+1).id = same_band.IDs(i_node);
  interferers1(end+1).xy = same_band.coords(i_node,:);
  interferers1(end).deployed = 1;
  interferers1(end).radiated_power = ANTENNAS.hop{i_hop}.radiated_power.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use i_hop instead of identifying the specific hop.
  n_interferers1_added = n_interferers1_added+1;
end 

% for same level
node_lvl = i_hop;
if ANTENNAS.hop{i_hop}.frequency == freq
  same_lvl_bands = clustering{i_hop+1}.down_bands(clustering{i_hop+1}.memberships);
  same_band.nodes_idx = band-1<=same_lvl_bands & same_lvl_bands<=band+1;
  same_band.n_nodes = sum(same_band.nodes_idx); %todo test this
  %same_band.IDs = clustering{node_lvl}.id(same_band.nodes_idx);
  same_band.coords = clustering{node_lvl}.node_coords(same_band.nodes_idx,:);
  % nodes(end+1:end+1+n_nodes_in_same_band) = nodes_in_same_band;
end

[slot_nodes_activity, active_slot] = get_active_slot_group(same_band.n_nodes, ANTENNAS.hop{i_hop}.n_slots);
for i_node = 1:same_band.n_nodes
  %interferers2(end+1).id = same_band.IDs(i_node);
  interferers2(end+1).xy = same_band.coords(i_node,:);
  interferers2(end).deployed = slot_nodes_activity(i_node);
  interferers2(end).radiated_power = ANTENNAS.hop{i_hop}.radiated_power.equipment{node_lvl}; % only interference from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use i_hop instead of identifying the specific hop.
  n_interferers2_added = n_interferers2_added+1;
end

TDD_upstream = rand(1) > TDD_rates;
if TDD_upstream
  interferers = interferers2; %for upstream
else
  interferers = interferers1; %for downstream
end
% ^^^^^^^ this above should work. Test it! 







% for node_level = 1:size(clustering,1)
%   for comm_hop = node_level:node_level+1
%     if ANTENNAS.hop{comm_hop}.frequency == freq
%       coords_at_lvl = clustering{c_lvl}.node_coords(:,1:2);
%     
%     
%     
%     for i_node = 1:size(nodes,1)
%       node = nodes(i_node);
%       interferers(n_interferers_added+i_node).id = node.id;
%       interferers(n_interferers_added+i_node).xy = node.xy;
%       interferers(n_interferers_added+i_node).deployed = 1;
%       interferers(n_interferers_added+i_node).radiated_power = ANTENNAS.hop{node.hop}.radiated_power.equipment{node.lvl};
%     end
%     n_interferers_added = n_interferers_added+size(nodes,1);




% for i_node = 1:size(nodes,1)
%       interferers(n_interferers_added+i_node).id = n_interferers_added+i_node;
%       interferers(n_interferers_added+i_node).xy = coords_at_lvl(i_node,:);
%       % let us deploy only those which share the same frequency - same
%       % cluster and same level. We will use different frequency band per
%       % cluster. For now undeploy all and turn them on when we know which
%       % cluster are we dealing with when we select our 'user'
%       interferers(n_interferers_added+i_node).deployed = 0;
%       interferers(n_interferers_added+i_node).radiated_power = ANTENNAS.hop{c_lvl}.radiated_power.equipment{hop_idx};
%     end
%     n_interferers_added = n_interferers_added+i_node;