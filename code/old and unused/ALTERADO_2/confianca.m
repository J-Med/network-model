function [media,ci] = confianca(y)

ybar = mean(y);
s = std(y);
ci = 0.95;
alpha = 1 - ci;

n = length(y); %number of elements in the data vector
T_multiplier = tinv(1-alpha/2, n-1);
% the multiplier is large here because there is so little data. That means
% we do not have a lot of confidence on the true average or standard
% deviation
ci = T_multiplier*s/sqrt(n);

media= ybar;

end