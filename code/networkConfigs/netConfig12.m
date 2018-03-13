
scenarioSize = '906';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wifi';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [14/15, 1/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = CONFIG.TDD_effectiveRates; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

clusterConfig = [10 1; 15 1; 20 1; 30 1; 30 2; 40 1; 40 2];
clusterConfig = [15 1; 20 1];
