function analyzeAndSaveResults(technique, hop, maxDelays, delays1_ms, bits, AdjacencyMat, clustering, up1down2, CONFIG, iRun, resultsPath, summaryName)
% Shows results on cmd line. In future will do some analysis.

fprintf('%d nodes\n', size(maxDelays,1));
fprintf('clustering technique: %s\n',technique{:})
for iHop = 1:size(hop,2)
  fprintf('technology %d: %s\n', iHop, hop{iHop}.technologyName)
end

%[bits_in(:,1) delays(:,1) maxDelays(:,1) delays(:,1)>maxDelays(:,1)]
%tab1 = [bits{1,1} bits{2,1} delays maxDelays delays>maxDelays];
%tab1(bits{1,1}==1665,:)

if up1down2 == 1
  fprintf('^^^^^^^^^^^ UPstream ^^^^^^^^^^^\n')
else
  fprintf('vvvvvvvvvv DOWNstream vvvvvvvvvv\n')
end
%disp('At level 1, there is no clustering. The average is always NaN.')
for i = 2:size(AdjacencyMat, 2)
  fprintf('Average bitrate [Mbps] at hop %d   = %.5f\n', i-1, mean(sum(AdjacencyMat{i},2))/1024)  
end
for i = 1:size(AdjacencyMat, 2)-1
  nCols = size(AdjacencyMat{i+1},2);
  delayMat_s = repmat(bits{1,i},1,nCols)./(AdjacencyMat{i+1}*1024);
  delayMat_s(isnan(delayMat_s))=0;
  delayMat_s(delayMat_s==Inf)=0;
  fprintf('Average delay     [ms] at hop %d   = %.5f\n', i,   mean(sum(delayMat_s,2))*1000)
  %[val,idx]=sort(sum(delayMat_s,2),'descend');
  %mean(val(10:end))*1000;
end
  fprintf('Average delay     [ms] at top hop = %.5f\n',       mean(bits{1,end})./(CONFIG.TO_SINK_DATA_RATE*1024)*1000)

notAtttendSum = sum(delays1_ms>maxDelays(:,up1down2));
fprintf('Number of not attended: %d\n', notAtttendSum)
fprintf('=====================================================\n\n')

% Plot the scenario again, with cluster heads. Now, distinguishing clients
% whose delay was not higher than maxdelay (blue) and those that exceeded
% it (red). This will allow us to visualize which regions are problematic.
%
% Plot for upstream
%if up1Down2==1
aboveMaxDelayIdx = delays1_ms(:,1)>maxDelays(:,up1down2);
nAboveMaxDelay = sum(aboveMaxDelayIdx);

%%%%% Change these two for desired output %%%%%%%%%
createFigure = false; %should figure for every execution be created?
visibleOnOff = 'off'; % this will be set for figure parameter ('on' or 'off')s
if createFigure
  if CONFIG.show
    visibleOnOff = 'on';
  end
  fig = figure('Name', 'Upstream results - blue=good, red=bad', 'Visible', visibleOnOff);
  hold on;
  plot(clustering{3}.nodeCoords(:,1), clustering{3}.nodeCoords(:,2), 'k^', 'linewidth', 2, 'markersize', 12);
  plot(clustering{2}.nodeCoords(:,1), clustering{2}.nodeCoords(:,2), 'k+', 'linewidth', 2, 'markersize', 14);
  plot(clustering{1}.nodeCoords(~aboveMaxDelayIdx,1), ...
    clustering{1}.nodeCoords(~aboveMaxDelayIdx,2), 'bo', 'linewidth', 2, 'markersize', 1);
  plot(clustering{1}.nodeCoords(aboveMaxDelayIdx,1), ...
    clustering{1}.nodeCoords(aboveMaxDelayIdx,2), 'x', 'Color', [0.85 0 0], 'linewidth', 1, 'markersize', 6);
  hold off;
  legend({'\fontname{Times}\fontsize{13}Gateway', ...
    '\fontname{Times}\fontsize{13}Access Point', ...
    '\fontname{Times}\fontsize{13}Subscriber - sufficient QoS', ...
    '\fontname{Times}\fontsize{13}Subscriber - insufficient QoS'},...
    'Location', 'northeast',... %   'FontSize', 12,... %'Orientation','horizontal',...
    'Interpreter', 'tex');
  % legend('boxoff');
  n1 = num2str(size(clustering{1}.nodeCoords,1));
  n2 = num2str(size(clustering{2}.nodeCoords,1));
  n3 = num2str(size(clustering{3}.nodeCoords,1));
  hop1techRaw = hop{1}.technologyName;
  hop1tech = '';
  if strcmp('wimax',hop1techRaw)
  hop1tech = 'WiMAX';
  elseif strcmp('wifi',hop1techRaw)
  hop1tech = 'Wi-Fi';
  end
  title({['\fontname{Times}\fontsize{14}Hop_1 technology: ',hop1tech];...
    ['\fontname{Times}\fontsize{14}Subscribers: ',n1,',  Access Points: ',n2,',  Gateways: ',n3,]});
 
  filename = sprintf('%04i',iRun);
  set(fig,'Units','Inches');
  pos = get(fig,'Position');
  set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
  print(fig, [resultsPath filename], '-dpdf', '-r0');
  if CONFIG.show % pause to see every figure
    pause
  end
  close(fig);
end
id = floor((iRun+1)/2);
up1down2descriptionBase = {'uplink';'downlink'};
up1down2description = up1down2descriptionBase(up1down2);
if mod(iRun,2)==1 % regular mode
  xlwrite([resultsPath summaryName], {id, up1down2description, nAboveMaxDelay, '', size(maxDelays,1), ...
    clustering{size(clustering,2)}.k_history(1), clustering{size(clustering,2)}.k_history(2), ...
    technique{:}, hop{1}.technologyName, hop{2}.technologyName, ...
    CONFIG.TDD_rates(1), CONFIG.TDD_rates(2), ...
    CONFIG.TDD_effectiveRates(1), CONFIG.TDD_effectiveRates(2)}, ...
    1, sprintf('A%i',id+1));
%saveResults(nAboveMaxDelay, aboveMaxDelayIdx, fig);
else % restricted mode
  % use either xlwrite or xlswrite, whatever works on your computer
  % if xlwrite is to be used, use the addjavapath command to include all
  % jars in xlwrite/poi_library
  xlwrite([resultsPath summaryName], nAboveMaxDelay, 1, sprintf('D%i',id+1));
end
end
