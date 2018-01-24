
scenarioSize = '13';%'2469'; % 13, 4, 906, 2469
ANTENNAS.hop{1}.technologyName = 'wimax';
ANTENNAS.hop{2}.technologyName = 'wimax';

CONFIG.TDD_effectiveRates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of the application data will occur. Should sum to one
CONFIG.TDD_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

clusterConfig = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
clusterConfig = [40 2; 50 2; 80 2; 100 2; 100 3];
clusterConfig = [50 1; 50 3; 50 5; 100 1; 100 3; 200 1; 200 3];
clusterConfig = [20 1; 20 3; 20 5; 20 7; 30 1; 30 3; 30 5; 30 7; 50 5; 50 7];
clusterConfig = [60 1; 60 3; 60 5; 60 7; 70 1; 70 3; 70 5; 70 7];
clusterConfig = [40 2; 40 3; 45 2; 45 3; 50 2; 50 3; 55 2; 55 3];
clusterConfig = [40 2; 40 3; 45 2; 45 3; 50 2; 50 3; 55 2; 55 3];
clusterConfig = [30 4; 40 4; 45 4; 50 4; 55 4; 60 4; 65 4];
clusterConfig = [30 5; 40 5; 45 5; 50 5; 55 5; 60 5; 65 5];
clusterConfig = [70 5; 75 5; 65 6; 70 6; 75 6];
clusterConfig = [2 1; 3 1];
