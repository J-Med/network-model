
scenarioSize = '906';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [8/15, 7/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [7/15, 8/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2];
cluster_config = [100 3; 200 3; 300 3];
clusterConfig = [3 1; 6 2];