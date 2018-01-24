function delays_ms = computeDelaysUpDown_ms(AdjacencyMat_bps, nBits)
  % only supports singlepath - meaning only one non-zero (positive)
  % number per membership matrix row.
  % We can not simply use max(column) to identify the highest delay.
  % We would need to check the delays on the higher levels of abstraction to
  % choose an optimal path to the graph's root.
  % For simplicity then, we will skip this analysis and focus on singlepath.
  % INPUT
  %   AdjacencyMat .. Adjacency matrix N x M where N > M
  %                   (N= original data count, M= k) [kbps]
  % OUTPUT
  %   delays_ms ..      1xN vector of delays in ms
  
%   delays = sum(AdjacencyMat, 2)' .* bits_in

% in first and second column delays for input and output respectively
delays_ms = nBits./repmat(sum(AdjacencyMat_bps,2),1,size(nBits, 2))*1000;
end