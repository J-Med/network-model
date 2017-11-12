function interferers = get_interferers(sender, receiver, freq, c_lvl, clustering, up1_down2, ANTENNAS, i_hop, band)
%TODO this function
interferers = [];
n_interferers_added = 0;
% coordinates of all nodes at the current level (which is the same as
% 'positions' variable. It is the lower communication level of the two
% neighbors. That would be either end users or micros.

% check which fctn gives band as argument
% once I need down_bands and once up bands, so bands should be fixed and up and down grouped probably
% after these fixes, it might work
for node_lvl = i_hop:i_hop+1
  if ANTENNAS.technology{i_hop}.frequency == freq
    nodes_idx_in_same_band = clustering{node_lvl}.down_bands{i_hop}==band;
    n_nodes_in_same_band = sum(nodes_idx_in_same_band); %todo test this
    same_band_IDs = clustering{node_lvl}.id(nodes_idx_in_same_band);
    same_band_coords = clustering{node_lvl}.node_coords(nodes_idx_in_same_band);
    % nodes(end+1:end+1+n_nodes_in_same_band) = nodes_in_same_band;
  end

  for i_node = 1:n_nodes_in_same_band
    interferers(end+1).id = same_band_IDs(i_node);
    interferers(end+1).xy = same_band_coords(i_node);
    interferers(end+1).deployed = 1;
    interferers(end+1).radiated_power = ANTENNAS.technology{i_hop}.radiated_power.equipment{node_lvl}; % only interfernce from the same communication hop is considered in our case, since it is a wifi-wimax scenario. So we can use i_hop instead of identifying the specific hop.
    n_interferers_added = n_interferers_added+1;
  end
end
% ^^^^^^^ this above should work. Test it! 







% for node_level = 1:size(clustering,1)
%   for comm_hop = node_level:node_level+1
%     if ANTENNAS.technology{comm_hop}.frequency == freq
%       coords_at_lvl = clustering{c_lvl}.node_coords(:,1:2);
%     
%     
%     
%     for i_node = 1:size(nodes,1)
%       node = nodes(i_node);
%       interferers(n_interferers_added+i_node).id = node.id;
%       interferers(n_interferers_added+i_node).xy = node.xy;
%       interferers(n_interferers_added+i_node).deployed = 1;
%       interferers(n_interferers_added+i_node).radiated_power = ANTENNAS.technology{node.hop}.radiated_power.equipment{node.lvl};
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
%       interferers(n_interferers_added+i_node).radiated_power = ANTENNAS.technology{c_lvl}.radiated_power.equipment{hop_idx};
%     end
%     n_interferers_added = n_interferers_added+i_node;