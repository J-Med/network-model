function [c_m, means_m, x_dists_m] = main_k_means(x,k,show_graphics,no_trials,max_iter)
% here is the k-means approach decided and manipulated
% INPUTS
% x ... data coordenates - N-dimensional vector - Feature vectors, of size [dim,number_of_vectors], where dim
%                is arbitrary feature vector dimension
% k ... number of clusters
% OUTPUTS
% 

%% K-means
% fprintf('K-means...\n');
% [c, means, x_dists] = k_means(x, 2, Inf, true);
% show_clusters(x, c, means);
% pause

%% Estimate Optimal Number of Clusters
if show_graphics
    elbow_graph(x, 1:10, 10, Inf, false);
end
% pause;

%% Final run for k clusters
% fprintf('K-means with multiple trials, k = %d...\n', k);

[c_m, means_m, x_dists_m] = k_means_multiple_trials(x, k, no_trials, max_iter, show_graphics);
if show_graphics
  show_clusters(x, c_m, means_m);
end