
function [vetor_results, total, tot_fiber, tot_trenching, sub] = root (u, f, b, o, h)
%clear;
%clc;
l=1;
%h = 1;

numUsers = u*0.2;
numUsers2 = u*0.8;
%numUsers3 = u*0.3;
threshold = 400; % minimo de 40 Kbps
radiated_power = 20;
channel = 50;
%Hz
%frequency = 2e9;
%frequency = 3.5e9;
%band = 180000;
frequency = f;
band = b;
%rng(1235);
rng(1234+3000*o*h);

%Xmin = -500;
%Xmax = 500;
%Ymin = -500;
%Ymax = 500;
Xmin = -500;
Xmax = 500;
Ymin = -500;
Ymax = 500;

%Distribuição dos usuários
for i=1:numUsers
    usuario(i) = User;
    usuario(i).ux = (Xmax - Xmin).*rand(1) + Xmin;
    usuario(i).uy = (Ymax - Ymin).*rand(1) + Ymin;
    usuario(i).channel = 0;
    usuario(i).reqDataRate = threshold;
end 

 Xmin2 = -500;
 Xmax2 = 0;
 Ymin2 = -500;
 Ymax2 = 500;

for i=numUsers+1:numUsers2+numUsers
    usuario(i) = User;
    usuario(i).ux = (Xmax2 - Xmin2).*rand(1) + Xmin2;
    usuario(i).uy = (Ymax2 - Ymin2).*rand(1) + Ymin2;
    usuario(i).channel = 0;
    usuario(i).reqDataRate = threshold;
end 
% 
%  Xmin3 = -500;
%  Xmax3 = 500;
%  Ymin3 = -500;
%  Ymax3 = 0;
% 
% for i=numUsers+numUsers2+1:numUsers2+numUsers+numUsers3
%     usuario(i) = User;
%     %usuario(i).ux = ((Xmax-250) - (Xmin+250)).*rand(1) + Xmin;
%     %usuario(i).uy = ((Ymax-250) - (Ymin+250)).*rand(1) + Ymin;
%     usuario(i).ux = (Xmax3 - Xmin3).*rand(1) + Xmin3;
%     usuario(i).uy = (Ymax3 - Ymin3).*rand(1) + Ymin3;
%     usuario(i).channel = 0;
%     usuario(i).reqDataRate = threshold;
% end 
% 
 numUsers = numUsers + numUsers2;

%QUANTIDADE DE SMALL CELL
num_x = 3;
num_y = 3;

% x = 0; y = 0;
aux2 = 1;
aux5 = 1;

%pos_x = linspace(Xmin + (Xmax-Xmin)/(num_x-1)/2, Xmax - (Xmax-Xmin)/(num_x-1)/2, num_x);
%pos_y = linspace(Ymin + (Ymax-Ymin)/(2+num_y), Ymax - (Ymax-Ymin)/(2+num_y), num_y);
pos_x = linspace(Xmin , Xmax , num_x);
pos_y = linspace(Ymin , Ymax , num_y);

passo = (Xmax-Xmin)/(num_x-1);
% for i = 1:size_x


for i = 1:num_x
    
    %y = 0;
    
    %for j = 1:size_y
    for j = 1:num_y
        
    micro(aux2) = Antenna;
    micro(aux2).id = aux2;
    micro(aux2).x = pos_x(i);
    micro(aux2).y = pos_y(j);
    micro(aux2).radiated_power = radiated_power;
    micro(aux2).deployed = true;
    micro(aux2).channels = channel;
    micro(aux2).channelsFREE = channel;
    micro(aux2).band = band;
    micro(aux2).check = 0;
   
%     if (aux2 == floor(num_x*num_y/2)+1)
%         micro(aux2).channels = 100;
%         micro(aux2).channelsFREE = 100;
%         micro(aux2).radiated_power = 43;
%     end

   % if (aux2 == 15 || aux2 == 16 || aux2 == 17) %ok 6x6 12%
  %  if (aux2 == 10 || aux2 == 16 || aux2 == 22)   %ok 7% 
   % if (aux2 == 1 || aux2 == 2)
    if (aux2 == 1 || aux2 == 2 || aux2 == 3) 
        micro(aux2).faps = 1;
        micro(aux2).check = 1;
        pontos(aux5,1) = micro(aux2).x;
        pontos(aux5,2) = micro(aux2).y;
        aux5 = aux5 + 1;
    end
    
    %y = y + espacamento;
    aux2 = aux2 + 1;
    end
   
    %x = x + espacamento;
    
end

%##########################################################
%##########################################################


%dbstop in updateScenario;
         [usuario micro uncovered] = updateScenario(usuario, micro, frequency); 
%dbstop in selectionBs;
     %   [usuario micro custo_final] = selectionBs(usuario, micro, frequency,passo,l);
%Para 5G paper
         [usuario micro custo_final] = selectionBs_5Gpaper(usuario, micro, frequency,passo,l);
 %Chama de novo, para ligar micro a seus usuarios finais!!        
         [usuario micro uncovered] = updateScenario(usuario, micro, frequency);
         
         [vetor_results] = medias(usuario);
%    vet_CQI = graphCQI(usuario);
%    saveas(graph_CQI, 'teste_cqi.pdf'); 
%   
    graph = gerarGrafico(usuario, micro);
    set(graph,'Visible','off');
    nome = strcat('teste-',int2str(o),'-',int2str(h),'.pdf');
    saveas(graph, nome);
    %saveas(graph, 'teste.pdf');
    %############################################
    %##CALCULANDO CUSTO FINAL
    %############################################
    k = 1;
    for i = 1:length(micro)
      if micro(i).deployed == 1
       implantados(k,1) = micro(i).x;
       implantados(k,2) = micro(i).y;
       %comentar se usar trenching_prim
       implantados(k,3) = length(micro(i).usuario);
       k = k+1;
      end
    end
  %  [S,total,tot_fiber, tot_trenching, sub, indices]=trench_prim(implantados);
%dbstop calcula_trenching 
    [total,tot_fiber, tot_trenching, sub]=calcula_trenching(implantados,pontos,passo);   
%     implantados2=ordenacao2(implantados,pontos,passo);
%     valor=sum(implantados2(:,1));
%     fibra_final=sum(implantados2(:,8));
%     trenching_final=sum(implantados2(:,10));
%     total=valor+fibra_final+trenching_final;
%    nun_smallcells=size(implantados,1);
    %############################################
    %CHECANDO VAZAO
    %############################################
    for i = 1:length(usuario)
        vet(i) = usuario(i).dataRate;
    end
    if min(vet)<400
        fprintf('BAIXO!! \n');
    else
        fprintf('TUDO OK! \n');
    end
    %############################################
% end