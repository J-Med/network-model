
  scenario_size = '906';%'2469'; % 13, 4, 906, 2469
  ANTENNAS.hop{1}.technology_name = 'wimax';
  ANTENNAS.hop{2}.technology_name = 'wimax';

CONFIG.TDD_effective_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of the intenional data will occur. Should sum to one
CONFIG.TDD_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one
% CONFIG.TDD_effective_rates = [9/15, 4/15]; % [upstream, downstream] - percentage during which transfer of the intenional data will occur. Should sum to one
% CONFIG.TDD_rates = [10/15, 5/15]; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
cluster_config = [40 2; 50 2; 80 2; 100 2; 100 3];
cluster_config = [50 1; 50 3; 50 5; 100 1; 100 3; 200 1; 200 3];
cluster_config = [20 1; 20 3; 20 5; 20 7; 30 1; 30 3; 30 5; 30 7; 50 5; 50 7];
cluster_config = [60 1; 60 3; 60 5; 60 7; 70 1; 70 3; 70 5; 70 7];
cluster_config = [40 2; 40 3; 45 2; 45 3; 50 2; 50 3; 55 2; 55 3];
cluster_config = [40 2; 40 3; 45 2; 45 3; 50 2; 50 3; 55 2; 55 3];
cluster_config = [30 4; 40 4; 45 4; 50 4; 55 4; 60 4; 65 4];
cluster_config = [30 5; 40 5; 45 5; 50 5; 55 5; 60 5; 65 5];
cluster_config = [70 5; 75 5; 65 6; 70 6; 75 6];
cluster_config = [10 2; 30, 3];
