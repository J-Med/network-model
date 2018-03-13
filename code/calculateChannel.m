function [dataRate, CQI, SINR, intercellInterferences_] = calculateChannel(sender, receiver, frequency_Hz, interferers, nReceivers)

distance_m = pdist([receiver.xy; sender.xy]); % Euclidean distance

%Potencia em Dbm, perda em db e o resto transforma pra W
loss_dB = getLoss_dB(distance_m, frequency_Hz);
power_dBm = (sender.radiatedPower) + sender.gain + receiver.gain - loss_dB;
power_W = dBm2W(power_dBm);

intercellInterferences_ = [];
intercellInterference_W = 0;
for i=1:length(interferers) % calculate intercell interference
  if interferers(i).deployed && ~isequal(interferers(i).xy,sender.xy) && ~isequal(interferers(i).xy,receiver.xy)  % && interferers(i).id ~= sender.id)
    distanceA = pdist([interferers(i).xy; receiver.xy]);
    if distanceA == 0
      error('distanceA = %f', distanceA)
    end
    if pdist([interferers(i).xy; sender.xy]) == 0
      error('distanceB = %f', 0)
    end
    L_dbA = interferers(i).radiatedPower - getLoss_dB(distanceA, frequency_Hz);
  intercellInterference_W = intercellInterference_W + dBm2W(L_dbA);
  end
  intercellInterferences_(i) = intercellInterference_W;
end

AGWN_W = dBm2W(randn(1,1)); % additive gaussian white noise
thermalNoiseArticle_W=7.4e-14;
temp_Celsius = 20;
thermalNoise_W = dBm2W(getThermalNoise_dBm(sender.bandwidth, temp_Celsius));
noise_W = thermalNoise_W;

SINR = (power_W / (noise_W + intercellInterference_W)); % (W / (W+W))
dataRate = (sender.bandwidth * log2(1+SINR))/1024;
CQI = round(1 + ((7/13)*(SINR+6)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loss_dB = getLoss_dB(distance_m, frequency_Hz)
  R_m = 3;  %R eh a profundidade da folhagem em metros;
%  c = 2.99792458e8; % speed of light in vacuum
%   freeSpaceLoss_dB = -147.5522 + 20*log10(distance_m) + 20*log10(frequency_Hz); % distance meters to km, frequency from Hz to GHz
  freeSpaceLoss_dB = 92.4478 + 20*log10(distance_m/1000) + 20*log10(frequency_Hz/1e9); % distance meters to km, frequency from Hz to GHz
%  freeSpaceLoss_dB3 = 20*log10(distance_m) + 20*log10(frequency_Hz) + 20*log10(4*pi/c); % freeSpaceLoss_dB and freeSpaceLoss_dB2 and freeSpaceLoss_dB3 are equal
  
  lossFoliage_dB = 0.2*((frequency_Hz/1e6)^0.3)*((R_m)^0.6); %Perda por causa da folhagem; % frequency conversion from Hz to MHz
  airAttenuation_dB = 0.01 * distance_m/1000;
  rainAttenuation_dB = 0.1 * distance_m/1000;
  
  loss_dB = freeSpaceLoss_dB + lossFoliage_dB + airAttenuation_dB + rainAttenuation_dB;
end

function temp_Kelvin = celsius2kelvin(temp_Celsius)
  Celsius0_Kelvin = 273.15;
  temp_Kelvin = Celsius0_Kelvin+temp_Celsius;
end

function thermalNoise_dBm = getThermalNoise_dBm(bandwidth_Hz, temp_Celsius)
  boltzmannConst_JPerK = 1.38064852e-23;
  temp_Kelvin = celsius2kelvin(temp_Celsius);
  thermalNoise_dBm = 10*log10(boltzmannConst_JPerK*temp_Kelvin*1000) + 10*log10(bandwidth_Hz);
end

function W = dBm2W(dBm)
  W = 10^(dBm/10)/1000;
end
