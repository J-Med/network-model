
scenarioSize = '906';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wimax';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [8/15, 7/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [7/15, 8/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
cluster_config = [40 2; 50 2; 80 2; 100 2; 100 3];
cluster_config = [ 50 5; 60 3; 60 4; 60 5];
clusterConfig = [6, 2];
