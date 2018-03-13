
scenarioSize = '13';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [10/15, 5/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = CONFIG.TDD_effectiveRates; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

clusterConfig = [2 1; 3 1; 4 1];
