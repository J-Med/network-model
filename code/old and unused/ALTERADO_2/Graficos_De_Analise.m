numUsers = [100 200 300 400 500 600 700 800 900 1000];

% x = DataRate
% y = SINR
% z = usuário desconectado
% unc = uncovered


texto = 'Simulação 01';
disp(texto);

[ udesc, mdr, msinr, uncovered, icUDESC, icDR, icSINR, icUNCO ] = main( 2e9, 180000, 1 );

x1 = mdr;
y1 = msinr;
z1 = udesc;
unc1 = uncovered;

ic_x1 = icDR;
ic_y1 = icSINR;
ic_z1 = icUDESC;
ic_unc1 = icUNCO; 


texto = 'Simulação 02';
disp(texto);


[ udesc, mdr, msinr, uncovered, icUDESC, icDR, icSINR, icUNCO ] = main( 28e9, 180000, 1 );

x2 = mdr;
y2 = msinr;
z2 = udesc;
unc2 = uncovered;

ic_x2 = icDR;
ic_y2 = icSINR;
ic_z2 = icUDESC;
ic_unc2 = icUNCO;

texto = 'Simulação 03';
disp(texto);

[ udesc, mdr, msinr, uncovered, icUDESC, icDR, icSINR, icUNCO ] = main( 28e9, 360000, 1 );

x3 = mdr;
y3 = msinr;
z3 = udesc;
unc3 = uncovered;

ic_x3 = icDR;
ic_y3 = icSINR;
ic_z3 = icUDESC;
ic_unc3 = icUNCO;

%Geração dos Gráficos
%% dataRate
blockfig = figure;
axes('Parent',blockfig,'YMinorTick','on',...
    'YMinorGrid','off',...
    'YGrid','on',...
    'XTick',[100 200 300 400 500 600 700 800 900 1000],... 
    'XGrid','off')
hold on
g1 = errorbar (numUsers,x1,ic_x1);
g2 = errorbar (numUsers,x2,ic_x2);
g3 = errorbar (numUsers,x3,ic_x3);
title('??????');
xlabel('Usuários');
ylabel('Capacidade do Canal (Mbps)');
legend ('2GHz@180KHz','28GHz@180KHz','28GHz@360KHz');

saveas(blockfig, 'teste_taxa.pdf');

%% SINR

blockfig = figure;
axes('Parent',blockfig,'YMinorTick','on',...
    'YMinorGrid','off',...
    'YGrid','on',...
    'XTick',[100 200 300 400 500 600 700 800 900 1000],... 
    'XGrid','off')
hold on
g1 = errorbar (numUsers,y1,ic_y1);
g2 = errorbar (numUsers,y2,ic_y2);
g3 = errorbar (numUsers,y3,ic_y3);
title('?????');
xlabel('Usuários');
ylabel('SINR)');
legend ('2GHz@180KHz','28GHz@180KHz','28GHz@360KHz');

saveas(blockfig, 'teste_sinr.pdf');


%% Desconectados

blockfig = figure;
axes('Parent',blockfig,'YMinorTick','on',...
    'YMinorGrid','off',...
    'YGrid','on',...
    'XTick',[100 200 300 400 500 600 700 800 900 1000],... 
    'XGrid','off')
hold on
g1 = errorbar (numUsers,z1,ic_z1);
g2 = errorbar (numUsers,z2,ic_z2);
g3 = errorbar (numUsers,z3,ic_z3);
title('Desconectados');
xlabel('Total de Usuários');
ylabel('Usuários Desconectados');
legend ('2GHz@180KHz','28GHz@180KHz','28GHz@360KHz');

saveas(blockfig, 'teste_desconectados.pdf');

%% Insatisfeito 

blockfig = figure;
axes('Parent',blockfig,'YMinorTick','on',...
    'YMinorGrid','off',...
    'YGrid','on',...
    'XTick',[100 200 300 400 500 600 700 800 900 1000],... 
    'XGrid','off')
hold on
g1 = errorbar (numUsers,unc1,ic_unc1);
g2 = errorbar (numUsers,unc2,ic_unc2);
g3 = errorbar (numUsers,unc3,ic_unc3);
title('Insatisfação');
xlabel('Total de Usuários');
ylabel('Usuários Insatisfeitos');
legend ('2GHz@180KHz','28GHz@180KHz','28GHz@360KHz');

saveas(blockfig, 'teste_Insatisfeitos.pdf');

