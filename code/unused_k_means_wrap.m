%TODO all
function [c_m, means_m] = unused_k_means_wrap(x, k, trials2run, show)
% Runs k-means clustering algorithm, given input matrix x, number of clusters k.

% INPUTS
% 

% OUTPUTS
% 
addpath('k_means');
  
%  for trial = 1:trials2run
%    fprintf('    trial %d\n',trial);

    %fprintf('K-means with multiple trials, k = %d...\n', k);
    [c_m, means_m, x_dists_m] = main_k_means(x',k,true, trials2run);

    c_m = c_m';
    means_m = means_m';
    
%% down from here can be deleted

%     for up_down = 1:2
%         scenario.stream = up_down;
%       scenario_kmeans = scenario;
%       %% data rates
%       [scenario_kmeans.data_rates,scenario_kmeans.max_receiving_rates,uniqueK_idx] = ...
%           get_data_rates_kbps(x,k,c_m,means_m,network_technology);
%       
%       scenario_kmeans.data_rates = [CH2sink_data_rate*ones(sink_size,k); scenario_kmeans.data_rates; zeros(k,k)];
%       scenario_kmeans.max_receiving_rates = [CH2sink_max_receiving_rate*ones(sink_size,1); scenario_kmeans.max_receiving_rates];
%       
%   %     %     add clusters to cluster vector
%   %     c_m2 = [zeros(sink_size,1); c_m]; % sink belongs to cluster #0
%   %     for i = 1:k
%   %         c_m2(c_m2==i) = numWithS+i;
%   %         c_m2(numWithS+i) = sink_idx; % cluster heads send to sink
%   %     end
%       a = cellstr(num2str((1:k)','CH%d'));
%       scenario_kmeans.node_names = {scenario.node_names{:} a{:}}';
%       scenario_kmeans.x = [scenario_kmeans.x; means_m];
%       scenario_kmeans.data_vol = [scenario_kmeans.data_vol; zeros(k,2)];

    % end
%  end
end
