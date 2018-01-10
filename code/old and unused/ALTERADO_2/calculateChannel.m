
function [ dataRate, CQI, SINR] = calculateChannel(user, antenna, frequency, micro)

%Distancia de Euclides
distance = pdist([user.xy; antenna.xy]);
%distance = (((user.ux - antenna.x)^2) + ((user.uy-antenna.y)^2))^0.5;
%distance = 6000;
%if (distance < 1000) %apagar

R = 3; %R é a altura da folhagem em metros;
white_noise = 7.4e-13;
intercellInterference = 0;

%STANFORD
%frequency = 3.5e9;
d0=100;
s = 9; % 8.2 to 10.6 dB ==> Trees
v=3e8; %velocidade da luz (m/s) no vacuo
lambda = v / frequency;
hr = 2;
a=3.6;
b=0.005;
c=20;
equalizador = 16;
hb = 70; %base station antenna height in meters  This is between 10 m and 80 m.

% so arvores
L_Foliage = 0.2*((frequency/1e6)^0.3)*((R)^0.6); %Perda por causa da folhagem;
%####Ao = 92.4+20log10(d[km]) +20log10(f[GHz])
L_db = 92.4 + 20 * log10(distance/1000) + 20 * log10(frequency/1e9) + L_Foliage;

%#####STANFORD - no medio da cidade
% The frequency correction factor Xf and the correction for receiver antenna height Xh for
% the models are expressed in:
% Xf=6*log10((frequency/1e6)/2000);
% Xh=-10.8*log10(hr/2000); %for terrain type A and B
% Xh=-20.0log10 (hr /2000) for terrain type C
% Where, f is the operating frequency in MHz, and hr
% is the receiver antenna height in meter.

%%SUI - com predios
% A=20*log10(4*pi*d0/lambda);
% 
% Y=(a-(b*hb))+(c/hb);
% 
% L_db = A + 10*Y*log10(distance/d0)+s - equalizador;

%Potencia em Dbm, perda em db e o resto transforma pra W
pr_W = 10^((antenna.radiated_power - L_db)/10)/1000;
%L_Foliage = 0;

for i=1:length(micro) % calculate intercell interference
    
    if(micro(i).deployed && micro(i).id ~= antenna.id)
        distanceA = pdist([micro(i).xy; user.xy]);
        % distanceA = (((micro(i).x - user.ux)^2) + ((micro(i).y - user.uy)^2))^0.5;
        L_dbA = micro(i).radiated_power - (92.4 + 20 * log10(distanceA/1000) + 20*log10(frequency/1e9)+ L_Foliage);
        % L_dbA = micro(i).radiated_power - (A + 10*Y*log10(distanceA/d0)+s - equalizador);
        intercellInterference = intercellInterference + (10^(L_dbA/10))/1000;
    end

end
%intercellInterference = 0;
%sum_pot_interf = -30;
%if intercellInterference < sum_pot_interf
    SINR = (pr_W / (white_noise + intercellInterference));
%else
%    SINR = (pr_W / (white_noise + sum_pot_interf));
%end


%STANFORD: 600m ==> vazao de 5kbps || 140m ==> vazao de 976kbps
dataRate = (antenna.band * log2(1+SINR))/1024;
CQI = round(1 + ((7/13)*(SINR+6)));
 
%  else %apagar
%     
%  SINR = 0;         %apagar
%  dataRate = 0;     %apagar
%  CQI = 0;          %apagar
%   
%  end %apagar

end