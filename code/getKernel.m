function [ K ] = getKernel( Xi, Xj, options )
%GETKERNEL Returns kernel matrix K(Xi, Xj)
%
% Input:
% Xi        [n x p (double)] matrix containing feature points in columns
% Xj        [n x q (double)] matrix containing feature points in columns
% options   [1 x 1 (struct)] structure with field 
%                             .kernel which specifies the type of a kernel 
%                             (rbf, linear, polynomial) and other possible parameters
%                             (like .sigma for rbf kernel or .d for polynomial)
% 
% Output: 
% K         [p x q (double)] matrix with kernel function values
% 

    if nargin < 3
        % NOTE: this requries STPR Toolbox in paths
        options = c2s({'kernel', 'rbf', 'sigma', 1.0});
    end;

    switch options.kernel
        case 'rbf'
            
            n = size(Xi, 2);
            m = size(Xj, 2);
            t = size(Xi, 1);
            u = size(Xj, 1);
            K = zeros(n, m);
%            X = [1, 2, 1, -1  -1  -2;
%                 1, 1, 2, -1, -2, -1];
%            Z = [0  1  1  8 13 13;...
%                 1  0  2 13 18 20;...
%                 1  2  0 13 20 18;...
%                 8 13 13  0  1  1;...
%                13 18 20  1  0  2;...
%                13 20 18  1  2  0];

            Z = zeros(m,n);
            for i = 1:m
                Z(i,:) = sum((Xi-repmat(Xj(:,i),t/u,n)).^2);
            end
            K = (exp(-1/(2*options.sigma^2)*Z))';
            
        case 'polynomial'
            
            p = size(Xi, 2);
            q = size(Xj, 2);
            K = ones(p, q);
            
            K = (K+Xi'*Xj).^options.d;
            
        case 'linear'
            
            K = Xi'*Xj;
            
        otherwise
            
            K = [];
            error('getKernel: unknown kernel.');
            
    end;
   % xlswrite('kernel_x.xlsx', K) 
end

