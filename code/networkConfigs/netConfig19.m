scenarioSize = '2469';
ANTENNAS.hop{1}.technologyName = 'wimax';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [6/15, 4/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [7/15, 5/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

clusterConfig = [30 1; 30 3; 60 1; 60 4];
