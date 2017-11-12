function [c, means, x_dists] = k_means(x, k, max_iter, show)
% [c, means, x_dists] = k_means(x, k, max_iter, show)
%
% Implementation of the k-means clustering algorithm.
%
% Input:
%   x         .. Feature vectors, of size [dim,number_of_vectors], where dim
%                is arbitrary feature vector dimension.
%
%   k         .. Required number of clusters (single number).
%
%   max_iter  .. Stopping criterion: max. number of iterations (single number).
%                Set it to Inf if you wish to deactivate this criterion. 
%
%   show      .. Boolean switch to turn on/off visualization of partial results.
%
% Output:
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
%
%   Note 1: All inputs and outputs are of double type.
%
%   Note 2: The iterative procedure terminates if either maximum number of
%   iterations is reached or there is no change in assignment of data to the
%   clusters.

if nargin < 4
    show = false;
end

means = x(:,randsample(size(x,2), k)');
c = zeros(1,size(x,2));
Dist = zeros(size(x,2),k);

i_iter = 0;
while i_iter < max_iter

    %i_iter
    %means
    for t = 1:k
        for h = 1:size(x,2)
            %compute squared distance home h to tank t
            Dist(h,t) = norm(double(x(:,h)-means(:,t)),2)^2;
        end
%         dif = x-repmat(means(:,t),1,size(x,2));
%         for h = 1:size(dif,2)
%             Dist(h,t) = norm(double(dif(:,h)),2)^2;
%         end
    end

    %store last assignment
    last_c = c;
    
    %pick the nearest tank for each home
    [x_dists,c] = min(Dist',[],1);  

	%no reassignment -> end
    if last_c == c
        break
    end
    
%     disp(c)
%     disp(means)
    %recompute means
    for n = 1:k
        if numel(c(c==n)) > 0
            means(:,n) = sum(x(:,(c==n)),2)/numel(c(c==n));
        end
    end
%     disp(means)
    
    % Ploting partial results
    if show
        show_clusters(x,c,means);
        pause
    end
    
    i_iter = i_iter+1;
end
x_dists = sqrt(x_dists);