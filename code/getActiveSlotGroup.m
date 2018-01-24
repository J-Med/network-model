function [slotNodesActivity, activeSlot] = getActiveSlotGroup(nNodes, nSlots)
% Input
%   nNodes ..     number of items to be selected from. 1x1 Integer
%   nSlots ..     number of slots/groups nodes will be separated into
%                  without overlapping. 1x1 Integer
%
% Output
%   slotNodesActivity..nodes selected as active, because their group is
%                        active. Vector [1 x nNodes] of zeros and ones.
%                        Zeros mark non-active nodes, ones mark active
%                        ones.
%   activeSlot ..       Which slot between 1 and nSlots was selected.

avgSlotSize = nNodes/nSlots;

% for every slot i put in a vector value i as many times as i-th slot's size
slotMembership = [];
jSlot = 1;
for iNode = 1:nNodes
  slotMembership(iNode) = jSlot;
  if iNode > jSlot*avgSlotSize
    jSlot = jSlot+1;
  end
end

% shuffle the vector, so that slot assignment is random
slotMembership = slotMembership(randperm(length(slotMembership)));

% choose which slot is active and mark its nodes as ones
activeSlot = randi(nSlots,1);
slotNodesActivity = slotMembership==activeSlot;
end