function [c, means, x_dists] = k_means_multiple_trials(x, k, n_trials, max_iter, show)
%
% Performs several trials of the k-means clustering algorithm in order to
% avoid local minima. Result of the trial with the lowest "within-cluster
% sum of squares" is selected as the best one and returned.
%
% Input:
%   x         .. Feature vectors, of size [dim,number_of_vectors], where dim
%                is arbitrary feature vector dimension.
%
%   k         .. Required number of clusters (single number).
%
%   n_trials  .. Number of trials.
%
%   max_iter  .. Stopping criterion: max. number of iterations (single number)
%                for each of the trials. Set it to Inf if you wish to deactivate
%                this criterion.
%
%   show      .. Boolean switch to turn on/off visualization of partial results.
%
% Output (= information about the best clustering from all the trials):
%   c         .. Cluster index for each feature vector, of size
%                [1, number_of_vectors], containing only values from 1 to k,
%                i.e. c(i) is the index of a cluster which the vector x(:,i)
%                belongs to.
%
%   means     .. Cluster centers, of size [dim,k], i.e. means(:,i) is the
%                center of the i-th cluster.
%
%   x_dists   .. Distance to the nearest mean for each feature vector,
%                of size [1, number_of_vectors].

if nargin < 5
  show = false;
end

c_temp = zeros(n_trials,size(x,2));
means_temp = zeros(size(x,1),k,n_trials);
x_dists_temp = zeros(n_trials,size(x,2));
sum_dists = zeros(n_trials,1);

% Multiple trial of the k-means clustering algorithm
for i_trial = 1:n_trials
  
  [c, means, x_dists] = k_means(x,k,max_iter,false);
  c_temp(i_trial,:) = c;
  means_temp(:,:,i_trial) = means;
  x_dists_temp(i_trial,:) = x_dists;
  
  % Plotting partial results
  if show
    show_clusters(x,c,means);
    pause
  end
  
  sum_dists = x_dists * ones(size(x_dists,2),1);
  [min_x,top_trial] = min(sum_dists);
  c = c_temp(top_trial,:);
  means = means_temp(:,:,top_trial);
  x_dists = x_dists_temp(top_trial,:);
  
end
