
scenarioSize = '13';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [8/15, 7/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [8/15, 7/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

clusterConfig = [2 1; 3 1];
