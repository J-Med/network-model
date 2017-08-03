function analyze_results(technique, technology, maxDelays, delays, bits, Adjacency_mat_up, Adjacency_mat_down, clustering, CONFIG)
% Shows results on cmd line. In future will do some analysis.

fprintf('clustering technique: %s\n',technique{:})
%[bits_in(:,1) delays(:,1) maxDelays(:,1) delays(:,1)>maxDelays(:,1)]
tab1 = [bits{1,1} bits{2,1} delays maxDelays delays>maxDelays];
%tab1(bits{1,1}==1665,:)

%disp('At level 1, there is no clustering. The average is always NaN.')
for i = 2:size(Adjacency_mat_up, 2)
  fprintf(  'Average upstream bitrate [Mbps] at level %d = \t%.15f\n', i-1, mean(sum(Adjacency_mat_up{i},2))/1024)  
  fprintf('Average downstream bitrate [Mbps] at level %d = \t%.15f\n', i-1, mean(sum(Adjacency_mat_down{i},2))/1024)
end
for i = 1:size(Adjacency_mat_up, 2)-1
  n_cols = size(Adjacency_mat_up{i+1},2);
  speed_mat = repmat(bits{1,i},1,n_cols)./(Adjacency_mat_up{i+1}*1024);
  speed_mat(isnan(speed_mat))=0;
  speed_mat(speed_mat==Inf)=0;
  fprintf(  'Average upstream delay [ms] at level %d = \t\t%.5f\n', i, mean(sum(speed_mat,2))*1000)
  speed_mat = repmat(bits{2,i},1,n_cols)./(Adjacency_mat_down{i+1}*1024);
  speed_mat(isnan(speed_mat))=0;
  speed_mat(speed_mat==Inf)=0;
  fprintf('Average downstream delay [ms] at level %d = \t\t%.5f\n', i, mean(sum(speed_mat,2))*1000)
end
  fprintf('Average upstream delay [ms] at top level = \t\t%.5f\n',   mean(bits{1,end})./(CONFIG.to_sink_data_rate*1024)*1000)
  fprintf('Average downstream delay [ms] at top level = \t%.5f\n', mean(bits{2,end})./(CONFIG.to_sink_data_rate*1024)*1000)

fprintf('Number of not attended:\n\t\tUP\t\t\tDOWN\n')
disp([sum(delays>maxDelays)])

for i_tech = 1:size(technology,2)
  fprintf('technology: %s\n', technology{i_tech}.name)
end

fprintf('=====================================================\n\n')

% Plot the scenario again, with cluster heads. Now, distinguishing clients
% whose delay was not higher than maxdelay (blue) and those that exceeded
% it (red). This will allow us to visualize which regions are problematic.
%
% Plot for upstream
over_delay_upstream_positions = delays(:,1)>maxDelays(:,1);
if CONFIG.show
figure('Name', 'Upstream results - blue=good, red=bad');
hold on;
plot(clustering{1}.CH_coords(over_delay_upstream_positions,1), ...
  clustering{1}.CH_coords(over_delay_upstream_positions,2), 'rx', 'linewidth', 1, 'markersize', 5);
plot(clustering{1}.CH_coords(~over_delay_upstream_positions,1), ...
  clustering{1}.CH_coords(~over_delay_upstream_positions,2), 'bx', 'linewidth', 1, 'markersize', 5);
plot(clustering{2}.CH_coords(:,1), clustering{2}.CH_coords(:,2), 'k+', 'linewidth', 2, 'markersize', 10);
plot(clustering{3}.CH_coords(:,1), clustering{3}.CH_coords(:,2), 'r^', 'linewidth', 2, 'markersize', 12);
hold off;

% Plot for downstream
over_delay_downstream_positions = delays(:,2)>maxDelays(:,2);
figure('Name', 'Downstream results - blue=good, red=bad');
hold on;
plot(clustering{1}.CH_coords(over_delay_downstream_positions,1), ...
  clustering{1}.CH_coords(over_delay_downstream_positions,2), 'rx', 'linewidth', 1, 'markersize', 5);
plot(clustering{1}.CH_coords(~over_delay_downstream_positions,1), ...
  clustering{1}.CH_coords(~over_delay_downstream_positions,2), 'bx', 'linewidth', 1, 'markersize', 5);
plot(clustering{2}.CH_coords(:,1), clustering{2}.CH_coords(:,2), 'k+', 'linewidth', 2, 'markersize', 10);
plot(clustering{3}.CH_coords(:,1), clustering{3}.CH_coords(:,2), 'r^', 'linewidth', 2, 'markersize', 12);
hold off;
end
end