
scenarioSize = '906'; % 13, 906, 2469,  4
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

clusterConfig = [2 1; 4 1; 10 1; 10 2; 30, 2];
