function [S,total, tot_fiber, tot_trenching ,sub, indices]=trench_prim(implantados)

% for i=1:1:size(implantados,1)
%     indice_temp(i,1)=implantados(i,4);
%     indice_temp(i,2)=implantados(i,5);
% end
% 
% %pontos=[2,2; 2,2.5]; %4 MEIO
% indices = vertcat(indice_temp,pontos);
% indices = unique(indices,'rows');
indices = implantados;

for i=1:1:size(indices,1)
    indices(i,3)=i;
end

aux=1;
for i=1:1:size(indices,1)
    for j=1:1:size(indices,1)
        taxi(aux,1)=((abs(indices(i,1)-indices(j,1))+abs(indices(i,2)-indices(j,2))));
        taxi(aux,2)= indices(i,3);
        taxi(aux,3)= indices(j,3);
        aux=aux+1;
    end
end

W = taxi(:,1)';
DG = sparse(taxi(:,2)',taxi(:,3)',W);
UG = tril(DG + DG');
%view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'));

[ST,pred] = graphminspantree(UG,1);
%[ST,pred] = graphminspantree(UG,'Method', 'Kruskal');

%view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

S=full(ST);
fibra = 0.16; %por metro
cano = 13; %por metro
aux2=1;
for i=1:1:size(S,1)
    for j=1:1:size(S,1)
        custo_final(aux2,1)=(S(i,j)/2*cano)+(S(i,j)/2*fibra);
        custo_trenching(aux2,1) = (S(i,j)/2*cano);
        custo_fiber(aux2,1) = (S(i,j)/2*fibra);
        custo_final(aux2,2)=i;
        custo_final(aux2,3)=j;
        aux2=aux2+1;
    end
end
preco_antena = 1600; %por unidade
sub = size(implantados,1)*preco_antena;
%total=sum(custo_final,1);
total=sum(custo_final(:,1)) + sub;
tot_fiber = sum(custo_fiber(:,1));
tot_trenching = sum(custo_trenching(:,1));