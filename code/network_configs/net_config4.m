
  scenario_size = '2469';%'2469'; % 13, 4, 906, 2469
  ANTENNAS.hop{1}.technology_name = 'wifi';
  ANTENNAS.hop{2}.technology_name = 'wimax';

CONFIG.TDD_effective_rates = [11/15, 2/15]; % [upstream, downstream] - percentage during which transfer of the intenional data will occur. Should sum to one
CONFIG.TDD_rates = [12/15, 3/15]; % [upstream, downstream] - percentage during which transfer of all data including control messages will occur. Should sum to one

cluster_config = [100 1; 100 2; 200 1; 200 2; 300 1; 300 2];
cluster_config = [100 3; 200 3; 300 3];
