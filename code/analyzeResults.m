function analyzeResults(technique, hop, maxDelays, delays1_ms, bits, AdjacencyMat, clustering, up1Down2, CONFIG, delays2_ms)
% Shows results on cmd line. In future will do some analysis.

fprintf('%d nodes\n', size(maxDelays,1));
fprintf('clustering technique: %s\n',technique{:})
for iHop = 1:size(hop,2)
  fprintf('technology %d: %s\n', iHop, hop{iHop}.technologyName)
end

%[bits_in(:,1) delays(:,1) maxDelays(:,1) delays(:,1)>maxDelays(:,1)]
%tab1 = [bits{1,1} bits{2,1} delays maxDelays delays>maxDelays];
%tab1(bits{1,1}==1665,:)

if up1Down2 == 1
  fprintf('UPstream\n')
else
  fprintf('DOWNstream\n')
end
%disp('At level 1, there is no clustering. The average is always NaN.')
for i = 2:size(AdjacencyMat, 2)
  fprintf('Average bitrate [Mbps] at hop %d = %.5f\n', i-1, mean(sum(AdjacencyMat{i},2))/1024)  
end
for i = 1:size(AdjacencyMat, 2)-1
  nCols = size(AdjacencyMat{i+1},2);
  delayMat_s = repmat(bits{1,i},1,nCols)./(AdjacencyMat{i+1}*1024);
  delayMat_s(isnan(delayMat_s))=0;
  delayMat_s(delayMat_s==Inf)=0;
  fprintf('Average delay     [ms] at hop %d = %.5f\n', i, mean(sum(delayMat_s,2))*1000)
  fprintf('Average delay     [ms] at hop %d = %.5f\n', i, mean(delays2_ms{i}))
end
  fprintf('Average delay     [ms] at top hop = %.5f\n',   mean(bits{1,end})./(CONFIG.TO_SINK_DATA_RATE*1024)*1000)

notAtttendSum = sum(delays1_ms>maxDelays(up1Down2));
fprintf('Number of not attended: %d\n', notAtttendSum)
fprintf('=====================================================\n\n')

% Plot the scenario again, with cluster heads. Now, distinguishing clients
% whose delay was not higher than maxdelay (blue) and those that exceeded
% it (red). This will allow us to visualize which regions are problematic.
%
% Plot for upstream
%if up1Down2==1
overDelayUpstreamPositions = delays1_ms(:,1)>maxDelays(:,1);
%if CONFIG.show
figure('Name', 'Upstream results - blue=good, red=bad');
hold on;
plot(clustering{1}.nodeCoords(overDelayUpstreamPositions,1), ...
  clustering{1}.nodeCoords(overDelayUpstreamPositions,2), 'rx', 'linewidth', 1, 'markersize', 5);
plot(clustering{1}.nodeCoords(~overDelayUpstreamPositions,1), ...
  clustering{1}.nodeCoords(~overDelayUpstreamPositions,2), 'bx', 'linewidth', 1, 'markersize', 5);
plot(clustering{2}.nodeCoords(:,1), clustering{2}.nodeCoords(:,2), 'k+', 'linewidth', 2, 'markersize', 10);
plot(clustering{3}.nodeCoords(:,1), clustering{3}.nodeCoords(:,2), 'r^', 'linewidth', 2, 'markersize', 12);
hold off;
pause
return%else
% Plot for downstream
overDelayDownstreamPositions = delays1_ms(:,2)>maxDelays(:,2);
figure('Name', 'Downstream results - blue=good, red=bad');
hold on;
plot(clustering{1}.nodeCoords(overDelayDownstreamPositions,1), ...
  clustering{1}.nodeCoords(overDelayDownstreamPositions,2), 'rx', 'linewidth', 1, 'markersize', 5);
plot(clustering{1}.nodeCoords(~overDelayDownstreamPositions,1), ...
  clustering{1}.nodeCoords(~overDelayDownstreamPositions,2), 'bx', 'linewidth', 1, 'markersize', 5);
plot(clustering{2}.nodeCoords(:,1), clustering{2}.nodeCoords(:,2), 'k+', 'linewidth', 2, 'markersize', 10);
plot(clustering{3}.nodeCoords(:,1), clustering{3}.nodeCoords(:,2), 'r^', 'linewidth', 2, 'markersize', 12);
hold off;
%end
end
