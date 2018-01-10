
  scenario_size = '2469';%'2469'; % 13, 4, 906, 2469
  ANTENNAS.hop{1}.technology_name = 'wimax';
  ANTENNAS.hop{2}.technology_name = 'wimax';

CONFIG.TDD_rates = [9/15, 4/15]; % [upstream, downstream] - percentage during which transfer will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2; 400 1; 400 2; 500 1];
cluster_config = [40 2; 50 2; 80 2; 100 2; 100 3];
cluster_config = [ 50 5; 60 3; 60 4; 60 5];