scenarioSize = '2469';
ANTENNAS.hop{1}.technologyName = 'wimax';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [10/15, 5/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = CONFIG.TDD_effectiveRates; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

clusterConfig = [40 1; 60 1; 60 2; 100 1; 100 2; 140 1; 140 2; 180 1; 180 2; 180 3; 220 1; 220 2; 220 3; 250 1; 250 2; 250 3];
clusterConfig = [40 1; 80 1; 100 2; 150 1];
clusterConfig = [200 1; 200 2; 250 1;];
