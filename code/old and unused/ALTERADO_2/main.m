%function [ udesc, mdr, msinr, uncovered, icUDESC, icDR, icSINR, icUNCO ] = main( l,m,simu )

clear;
clc;
filename = 'saida-5G.csv';

num_sim = 0; 
%s = simu;  %número de simulações
%s = 30;
s = 30;
z = 6;
u = 0;    %número de usuários
%f = l;  %frequencia utilizada
f = 2e9;
%b = m; %banda utilizada
b = 180000;

%Media final
udesc = 0;
mdr = 0;
msinr = 0;
uncovered  = 0;

%Intervalo de Confiança
icDR = 0;
icSINR = 0;
icUNCO = 0;
icUDESC = 0;


matrix_final = 0;
dv = [0 0 0 0 0]; %udesc;mdr;msinr;uncovered;
for o = 1:z
    
    %dv = [0 0 0 0 0]; %udesc;mdr;msinr;uncovered;
    u = u + 500;
    
    for h = 1:s
        
        [vetor_results, total, tot_fiber, tot_trenching, sub] = root (u, f, b, o, h);
        
        num_sim = num_sim + 1;
        
        matrix_final(h,1) = vetor_results(1);
        matrix_final(h,2) = vetor_results(2);
        matrix_final(h,3) = vetor_results(3);
        matrix_final(h,4) = vetor_results(4);
        matrix_final(h,5) = total;
        matrix_final(h,6) = tot_fiber;
        matrix_final(h,7) = tot_trenching;
        matrix_final(h,8) = sub;
        matrix_final(h,9) = vetor_results(5);
        
        num_sim
%      xlswrite(filename2,matrix_final(h,1),o,sprintf('A%d',h));
%      xlswrite(filename2,matrix_final(h,2),o,sprintf('B%d',h));
%      xlswrite(filename2,matrix_final(h,3),o,sprintf('C%d',h));
%      xlswrite(filename2,matrix_final(h,4),o,sprintf('D%d',h));
%      xlswrite(filename2,matrix_final(h,5),o,sprintf('E%d',h));
%      xlswrite(filename2,matrix_final(h,6),o,sprintf('F%d',h));
%      xlswrite(filename2,matrix_final(h,7),o,sprintf('G%d',h));
%      xlswrite(filename2,matrix_final(h,8),o,sprintf('H%d',h));
%      xlswrite(filename2,matrix_final(h,9),o,sprintf('I%d',h));
     filename2 = strcat('saida-5G-',int2str(o),'.csv'); 
     %filename2 = strcat('saida-com-',int2str(o),'-',int2str(h),'.csv'); 
     csvwrite(filename2,matrix_final);
 
    end
    
    % for i = 1:s
    %
    %   dv(1) = dv(1) + matrix_final(i,1);
    %   dv(2) = dv(2) + matrix_final(i,2);
    %   dv(3) = dv(3) + matrix_final(i,3);
    %   dv(4) = dv(4) + matrix_final(i,4);
    %   dv(5) = dv(5) + matrix_final(i,5);
    %
    % end
    
    s1 = std(matrix_final(:,1)');
    s2 = std(matrix_final(:,2)');
    s3 = std(matrix_final(:,3)');
    s4 = std(matrix_final(:,4)');
    s5 = std(matrix_final(:,5)');
    s6 = std(matrix_final(:,6)');
    s7 = std(matrix_final(:,7)');
    s8 = std(matrix_final(:,8)');
    s9 = std(matrix_final(:,9)');
    
    
    ci = 0.95;
    alpha = 1 - ci;
    
    T_multiplier = tinv(1-alpha/2, s-1);
    
    dv(o,1) = T_multiplier*s1/sqrt(s);
    dv(o,2) = T_multiplier*s2/sqrt(s);
    dv(o,3) = T_multiplier*s3/sqrt(s);
    dv(o,4) = T_multiplier*s4/sqrt(s);
    dv(o,5) = T_multiplier*s5/sqrt(s);
    dv(o,6) = T_multiplier*s6/sqrt(s);
    dv(o,7) = T_multiplier*s7/sqrt(s);
    dv(o,8) = T_multiplier*s8/sqrt(s);
    dv(o,9) = T_multiplier*s9/sqrt(s);
    
    dv(o,10) = mean(matrix_final(:,1)');
    dv(o,12) = mean(matrix_final(:,2)');
    dv(o,13) = mean(matrix_final(:,3)');
    dv(o,13) = mean(matrix_final(:,4)');
    dv(o,14) = mean(matrix_final(:,5)');
    dv(o,15) = mean(matrix_final(:,6)');
    dv(o,16) = mean(matrix_final(:,7)');
    dv(o,17) = mean(matrix_final(:,8)');
    dv(o,18) = mean(matrix_final(:,9)');
    
    PAG=1;
    
    csvwrite(filename,dv);
%     xlswrite(filename,dv(o,1),PAG,sprintf('A%d',o));
%     xlswrite(filename,dv(o,2),PAG,sprintf('B%d',o));
%     xlswrite(filename,dv(o,3),PAG,sprintf('C%d',o));
%     xlswrite(filename,dv(o,4),PAG,sprintf('D%d',o));
%     xlswrite(filename,dv(o,5),PAG,sprintf('E%d',o));
%     xlswrite(filename,dv(o,6),PAG,sprintf('F%d',o));
%     xlswrite(filename,dv(o,7),PAG,sprintf('G%d',o));
%     xlswrite(filename,dv(o,8),PAG,sprintf('H%d',o));
%     xlswrite(filename,dv(o,9),PAG,sprintf('I%d',o));
%     xlswrite(filename,dv(o,10),PAG,sprintf('J%d',o));

    
    %     icUDESC(o) = 1.96 * dv(1) / sqrt(s);
    %     icDR(o) = 1.96 * dv(2) / sqrt(s);
    %     icSINR(o) = 1.96 * dv(3) / sqrt(s);
    %     icUNCO(o) = 1.96 * dv(4) / sqrt(s);
    %     icTOTAL_IMPL = 1.96 * dv(5) / sqrt(s)
    
end

%figure
%plot(dv(:,10));

%end

%% Intervalo de Confiança = 1.96 * desvio padrão / raiz(número de simulações)
%% Desvio Padrão = raiz (somatorio dos valores / número de simulações - 1)
%%