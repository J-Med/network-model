function clustering = my_cluster(technique, levels, k_lvls, x, trials2run, ANTENNAS, show)
% Performs multi-level clustering using a technique given by parameter
%
% INPUTS
% technique       clustering technique to be used
% k_lvls          k (number of clusters) values for each level
%                 size: number of cells = number of levels - 
%                 in each cell there is arbitrary-sized n*1 array of values of k
% x               coordinates or some values of items to be clustered  
% trials2run      how many times to run clustering (best clustering is returned)
%
% OUTPUTS
% clustering                        size levels*1
%   clustering.memberships
%   clustering.x
%   clustering.next_k
%   clustering.idx
%   clustering.k


  	%	clustering1 = cluster(technique, k_lvls(1), coords); %Level1
  	%	clustering2 = cluster(technique, k_lvls(2), clustering1.CH_coords); %Level2
  	%	clustering3 = cluster(technique, k_lvls(3), clustering2.CH_coords); %Level3
  
  %size(k_lvls)
  x_temp = x;
  %size(x)
  clustering{1}.node_coords = x; % in the base level, cluster head 
    % cooordinates are our input data. It will be used for next clustering
  clustering{1}.next_k = k_lvls{1};
  clustering{1}.idx = [1];
  clustering{1}.k_history = [];
  i_clust = 2;
  
  for lvl = 1:levels
    originals = clustering{lvl};
    for original = originals
      idx = [original.idx, 2]; %indexing will start from 2 - first element is already occupied
     % for k = clustering{1}.next_k
        for k = k_lvls{lvl}
          if i_clust > 1
            fprintf('k: %i\n', k)
          end
          if numel(k) ~= 1
            disp('k is not a single number')
            k
            k{1}
            return
          end
          %k = k{1};
          x_temp = original.node_coords;
          cluster_head_coords = [];
          memberships = [];
          
          % ***** Cluster *****
          % [cluster_head_coords, memberships] = do_cluster(technique,k,x,trials2run)
          if strcmp(technique,'k-means')
            addpath('k_means');
            [c_m, means_m, x_dists_m] = main_k_means(x_temp',k,false, trials2run, Inf);
            cluster_head_coords = means_m';
            memberships = c_m';
          elseif strcmp(technique,'kernel_k-means')
            addpath('k_means');
            options.kernel = 'rbf';
            options.sigma = 1.0;
            [c_m, means_m, x_dists_m] = main_k_means(getKernel(x_temp',x_temp',options),k,false, trials2run, Inf);
            cluster_head_coords = means_m';
            memberships = c_m';
          elseif strcmp(technique,'test')
            cluster_head_coords = x_temp(1:end-1,:); % x_temp(1:end-1,:); worked
            %cluster_head_coords = x_temp{1:k} % x_temp(1:end-1,:); worked
            memberships = randi(k{1},size(x_temp,1),1);
          end
          
        % function Index = sub2indV(X, V)
        % transform idx to one number (linear) index to use in cell array
        % where dimensionality is not fixed
%           tmp     = [1, cumprod(size(clustering))];
%           idx_linear = sum(tmp(1:length(idx)) .* (idx - 1)) + 1; % use as clustering{idx_linear}
% 
%           idx_linear = num2cell(idx) % use as clustering{idx_linear{:}}

%           clustering{idx_linear{:}}.x = cluster_head_coords;
%           clustering{idx_linear{:}}.memberships = memberships;
%           clustering{idx_linear{:}}.next_k = k_lvls{lvl+1};
%           clustering{idx_linear{:}}.idx = idx;
%           clustering{idx_linear{:}}.k = [original.k, k];
          
          clustering{i_clust}.node_coords = cluster_head_coords;
          clustering{i_clust}.memberships = memberships;
          clustering{i_clust}.down_bands  = get_frequency_bands_down(cluster_head_coords, k, i_clust-1, ANTENNAS);
          if lvl < levels   clustering{i_clust}.next_k = k_lvls{lvl+1}; end
          clustering{i_clust}.idx = idx;
          clustering{i_clust}.k_history = [original.k_history, k];
          i_clust = i_clust+1;
          idx(end) = idx(end)+1;
        end
      % end
    end
  end
  
  if show
    figure('Name','Scenario and cluster heads');
    hold on;
    plot(clustering{1}.node_coords(:,1), clustering{1}.node_coords(:,2), 'bx', 'linewidth', 1, 'markersize', 5);
    plot(clustering{2}.node_coords(:,1), clustering{2}.node_coords(:,2), 'k+', 'linewidth', 2, 'markersize', 10);
    plot(clustering{3}.node_coords(:,1), clustering{3}.node_coords(:,2), 'r^', 'linewidth', 2, 'markersize', 12);
    hold off;
  end
end