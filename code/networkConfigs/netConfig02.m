
scenarioSize = '13'; % 13, 906, 2469,  4
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
cluster_config = [40 2; 50 2; 80 2; 100 2; 100 3];
cluster_config = [50 3; 50 4];
clusterConfig = [2 1; 3 1];
