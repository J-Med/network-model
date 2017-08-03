function elbow_graph(x, k_cands, n_trials, max_iter, show)
% elbow_graph(x, k_cands, n_trials, max_iter, show)
%
% For each considered value of k, this function performs several trials of
% the k-means clustering algorithm and displays the "elbow" graph
% (number of clusters vs "within-cluster sum of squares").
%
% Input:
%   x         .. Feature vectors, of size [dim,number_of_vectors], where dim
%                is arbitrary feature vector dimension.
%
%   k_cands   .. Candidate values of k to be considered, of size [1,number_of_k_cands].
%
%   n_trials  .. Number of trials of the k-means clustering for each k.
%
%   max_iter  .. Stopping criterion: max. number of iterations (single number)
%                for each of the trials. Set it to Inf if you wish to deactivate
%                this criterion.
%
%   show      .. Boolean switch to turn on/off visualization of partial results.

if nargin < 5
    show = false;
end

skipped_cands = k_cands(1) - 1;

for k = k_cands
    [c, means, x_dists] = k_means_multiple_trials(x, k, n_trials, max_iter, show);
    dists(k-skipped_cands) = sum(x_dists.^2);
end

figure
plot(k_cands,dists);


