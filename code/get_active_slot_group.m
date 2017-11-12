function [slot_nodes_activity, active_slot] = get_active_slot_group(n_nodes, n_slots)
% Input
%   n_nodes ..     number of items to be selected from. 1x1 Integer
%   n_slots ..     number of slots/groups nodes will be separated into
%                  without overlapping. 1x1 Integer
%
% Output
%   slot_nodes_activity..nodes selected as active, because their group is
%                        active. Vector [1 x n_nodes] of zeros and ones.
%                        Zeros mark non-active nodes, ones mark active
%                        ones.
%   active_slot ..       Which slot between 1 and n_slots was selected.

avg_slot_size = n_nodes/n_slots;

% for every slot i put in a vector value i as many times as i-th slot's size
slot_membership = [];
j_slot = 1;
for i_node = 1:n_nodes
  slot_membership(i_node) = j_slot;
  if i_node > j_slot*avg_slot_size
    j_slot = j_slot+1;
  end
end

% shuffle the vector, so that slot assignment is random
slot_membership = slot_membership(randperm(length(slot_membership)));

% choose which slot is active and mark its nodes as ones
active_slot = randi(n_slots,1);
slot_nodes_activity = slot_membership==active_slot;
end