
scenarioSize = '906';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wimax';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [6/15, 4/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [7/15, 5/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

clusterConfig = [2 1; 4 1; 10 1; 10 2; 30, 2];
