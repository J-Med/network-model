function [dataRate, CQI, SINR, intercell_interferences_db] = calculateChannel(sender, receiver, frequency_hz, interferers, n_receivers)

distance_m = pdist([receiver.xy; sender.xy]); % Euclidean distance

%Potencia em Dbm, perda em db e o resto transforma pra W
power_db = (sender.radiated_power + sender.gain + receiver.gain)/n_receivers - get_loss_db(distance_m, frequency_hz);
power_W = dB2W(power_db);

intercell_interferences_db = [];
intercell_interference_db = 0;
for i=1:length(interferers) % calculate intercell interference
  if interferers(i).deployed && ~isequal(interferers(i).xy,sender.xy) && ~isequal(interferers(i).xy,receiver.xy)  % && interferers(i).id ~= sender.id)
    distanceA = pdist([interferers(i).xy; receiver.xy]);
    if distanceA == 0
      error('distanceA = %f', distanceA)
    end
    if pdist([interferers(i).xy; sender.xy]) == 0
      error('distanceB = %f', 0)
    end
    L_dbA = interferers(i).radiated_power - get_loss_db(distanceA, frequency_hz);
    intercell_interference_db = intercell_interference_db + dB2W(L_dbA);
  end
  intercell_interferences_db(i) = intercell_interference_db;
end

AGWN_W = dB2W(randn(1,1)); % additive gaussian white noise

SINR = (power_W / (AGWN_W + intercell_interference_db)); % (W / (W+W))
dataRate = (sender.bandwidth * log2(1+SINR))/1024;
CQI = round(1 + ((7/13)*(SINR+6)));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loss_W = get_loss_W(distance_m, frequency_hz)
  loss_W = dB2W(get_loss_db(distance_m, frequency_hz));
end

function loss_db = get_loss_db(distance_m, frequency_hz)
  R_m = 3;  %R é a profundidade da folhagem em metros;
  loss_Foliage_db = 0.2*((frequency_hz/1e6)^0.3)*((R_m)^0.6); %Perda por causa da folhagem; % frequency conversion from Hz to MHz
  air_attenuation_db = 0.01 * distance_m/1000;
  rain_attenuation_db = 0.1 * distance_m/1000;

  loss_db = 92.4 + 20 * log10(distance_m/1000) + 20 * log10(frequency_hz/1e9); % frequency conversion from Hz to GHz
  loss_db = loss_db + loss_Foliage_db + rain_attenuation_db + air_attenuation_db;
end

function W = dB2W(dB)
  W = 10^(dB/10)/1000;
end
