function implantados=ordenacao2(implantados,pontos,passo)
%clear all;
%#######################################################
%Parameters = textread('Parameters.txt','%f');
%############################################################
%############################################################
%Custo de tunelamento
aux_passa_temp=1;
tunelamento=[];
l=1;
newpoint3=implantados;
implantados=[];

Value_Cost=1600;
fibra = 0.16; %por metro
cano = 13; %por metro
a=1;

% %Custos iniciais só dos implantados!!

%########################################################################
%########################################################################
costs=[];

%cria o vetor de custos
for i=1:1:size(newpoint3,1)
    taxi=[];
    taxicab=[];
    posi=[];
    for j=1:1:size(pontos,1);
        taxi(j,1)=((abs(newpoint3(i,1)-pontos(j,1))+abs(newpoint3(i,2)-pontos(j,2))));
        taxi(j,2)= pontos(j,1);
        taxi(j,3)= pontos(j,2);
        taxi(j,4)= newpoint3(i,1);
        taxi(j,5)= newpoint3(i,2);
    end
        [taxicab,posi]=min(taxi);
        costs(i,1)=Value_Cost/newpoint3(i,3);
        costs(i,2)= taxi(posi(1),2);
        costs(i,3)= taxi(posi(1),3);
        costs(i,4)= newpoint3(i,1);
        costs(i,5)= newpoint3(i,2);
        costs(i,6)= newpoint3(i,3);
        costs(i,7)= taxicab(1);
        costs(i,8)= taxicab(1)*fibra;
        costs(i,9)= taxicab(1)*cano;
        costs(i,10)= taxicab(1)*cano;
        costs(i,11)=(taxicab(1)*fibra+taxicab(1)*cano);
end

%########################################################################
%########################################################################
%montei matriz inicial!!
%costs=setdiff(costs,implantados,'rows');
costs=sortrows(costs,7);
mataux_temp=[];
mataux_temp(:,1)=costs(:,4);
mataux_temp(:,2)=costs(:,5);
mataux_temp(:,3)=costs(:,7);
cont=1;
passado=[];
custo_tunelamento_temp=[];
aux_passa=1;
b=1;

%Para cada elemento da matriz
while size(mataux_temp,1)>0    

if (mataux_temp(b,3)==0)

    implantados(cont,1)=costs(b,1);
    implantados(cont,2)=costs(b,2);
    implantados(cont,3)=costs(b,3);
    implantados(cont,4)=costs(b,4);
    implantados(cont,5)=costs(b,5);
    implantados(cont,6)=costs(b,6);
    implantados(cont,7)=costs(b,7);
    implantados(cont,8)=costs(b,8);
    implantados(cont,9)=costs(b,9);
    implantados(cont,10)=costs(b,10);
    implantados(cont,11)=costs(b,11);
   % costs(b,:)=[];
    
else
    %Guardo mas ainda vou atualizar!
    implantados(cont,1)=costs(b,1);
    implantados(cont,2)=costs(b,2);
    implantados(cont,3)=costs(b,3);
    implantados(cont,4)=costs(b,4);
    implantados(cont,5)=costs(b,5);
    implantados(cont,6)=costs(b,6);
    implantados(cont,7)=costs(b,7);
    implantados(cont,8)=costs(b,8);
    implantados(cont,9)=costs(b,9);
    implantados(cont,10)=costs(b,10);
    implantados(cont,11)=costs(b,11);
    
    
%     if ((implantados(cont,4)==implantados(cont,2))&&(implantados(cont,5)==implantados(cont,3)))
%         implantados(cont,10)=implantados(cont,10);
%     else
    %Custo de tunelamento
    tunelamento=[];
    l=1;
    %Andando em X
    if implantados(cont,4)<implantados(cont,2)
        atual=implantados(cont,4);
        while atual<implantados(cont,2)
            tunelamento(l,1)=atual;
            tunelamento(l,2)=implantados(cont,5);
            tunelamento(l,3)=atual+passo;
            tunelamento(l,4)=implantados(cont,5);
            atual=atual+passo;
            l=l+1;
        end
    else
         atual=implantados(cont,4);
        while atual>implantados(cont,2)
            tunelamento(l,1)=atual;
            tunelamento(l,2)=implantados(cont,5);
            tunelamento(l,3)=atual-passo;
            tunelamento(l,4)=implantados(cont,5);
            atual=atual-passo;
            l=l+1;
        end
    end
    %Andando em Y
    if implantados(cont,5)<implantados(cont,3)
        atual=implantados(cont,5);
        while atual<implantados(cont,3)
            tunelamento(l,1)=implantados(cont,2);
            tunelamento(l,2)=atual;
            tunelamento(l,3)=implantados(cont,2);
            tunelamento(l,4)=atual+passo;
            atual=atual+passo;
            l=l+1;
        end
    else
        atual=implantados(cont,5);
        while atual>implantados(cont,3)
            tunelamento(l,1)=implantados(cont,2);
            tunelamento(l,2)=atual;
            tunelamento(l,3)=implantados(cont,2);
            tunelamento(l,4)=atual-passo;
            atual=atual-passo;
            l=l+1;
        end
    end
    custo=0;
    for h=1:1:size(tunelamento,1)
        aux_exis=0;
        for j=1:1:size(passado,1)
            if ((tunelamento(h,1)==passado(j,1)&&tunelamento(h,2)==passado(j,2)&&tunelamento(h,3)==passado(j,3)&&tunelamento(h,4)==passado(j,4))||...
                    (tunelamento(h,1)==passado(j,3)&&tunelamento(h,2)==passado(j,4)&&tunelamento(h,3)==passado(j,1)&&tunelamento(h,4)==passado(j,2)))               
                aux_exis=1;
                
            end
        end
            if aux_exis==1;
                custo=custo+0;
            else
                custo=custo+1;
                passado(aux_passa,1)=tunelamento(h,1);
                passado(aux_passa,2)=tunelamento(h,2);
                passado(aux_passa,3)=tunelamento(h,3);
                passado(aux_passa,4)=tunelamento(h,4);
                aux_passa=aux_passa+1;
            end
    end
    implantados(cont,10)=custo*(cano/2);
end
    %############################################################
    %############################################################
    %Apago o costs e incremento o implantados
    costs(b,:)=[];
    mataux_temp(b,:)=[];
    cont=cont+1;
    %############################################################
    %############################################################
%     %recalculo o trenching para a matriz mataux_temp!! De TODOS MATAUX_TEMP PARA
%     TODOS IMPLANTADOS
    aux_passa_temp=1;
    custo_tunelamento_temp=zeros(1,5);
     for j=1:1:size(mataux_temp,1)
        for k=1:1:size(implantados,1)
         l=1;
           tunelamento=zeros(1,4);
            %Andando em X
            if mataux_temp(j,1)<implantados(k,4)
                atual=mataux_temp(j,1);
                while atual<implantados(k,4)
                    tunelamento(l,1)=atual;
                    tunelamento(l,2)=mataux_temp(j,2);
                    tunelamento(l,3)=atual+passo;
                    tunelamento(l,4)=mataux_temp(j,2);
                    atual=atual+passo;
                    l=l+1;
                end
            else
                 atual=mataux_temp(j,1);
                while atual>implantados(k,4)
                    tunelamento(l,1)=atual;
                    tunelamento(l,2)=mataux_temp(j,2);
                    tunelamento(l,3)=atual-passo;
                    tunelamento(l,4)=mataux_temp(j,2);
                    atual=atual-passo;
                    l=l+1;
                end
            end
            %Andando em Y
            if mataux_temp(j,2)<implantados(k,5)
                atual=mataux_temp(j,2);
                while atual<implantados(k,5)
                    tunelamento(l,1)=implantados(k,4);
                    tunelamento(l,2)=atual;
                    tunelamento(l,3)=implantados(k,4);
                    tunelamento(l,4)=atual+passo;
                    atual=atual+passo;
                    l=l+1;
                end
            else
                atual=mataux_temp(j,2);
                while atual>implantados(k,5)
                    tunelamento(l,1)=implantados(k,4);
                    tunelamento(l,2)=atual;
                    tunelamento(l,3)=implantados(k,4);
                    tunelamento(l,4)=atual-passo;
                    atual=atual-passo;
                    l=l+1;
                end
            end
            custo_temp=0;
            for h=1:1:size(tunelamento,1)
                aux_exis=0;
                for s=1:1:size(passado,1)
                    if ((tunelamento(h,1)==passado(s,1)&&tunelamento(h,2)==passado(s,2)&&tunelamento(h,3)==passado(s,3)&&tunelamento(h,4)==passado(s,4))||...
                            (tunelamento(h,1)==passado(s,3)&&tunelamento(h,2)==passado(s,4)&&tunelamento(h,3)==passado(s,1)&&tunelamento(h,4)==passado(s,2)))               
                        aux_exis=1;
                    end
                end
                if aux_exis==1;
                    custo_temp=custo_temp+0;
                 else
                    custo_temp=custo_temp+1;
                end
            end
                custo_tunelamento_temp(aux_passa_temp,1)=custo_temp;
                custo_tunelamento_temp(aux_passa_temp,2)=mataux_temp(j,1);
                custo_tunelamento_temp(aux_passa_temp,3)=mataux_temp(j,2);
                custo_tunelamento_temp(aux_passa_temp,4)=implantados(k,4);
                custo_tunelamento_temp(aux_passa_temp,5)=implantados(k,5);
                aux_passa_temp=aux_passa_temp+1;
%            end
       end
     end
    %############################################################
    %############################################################
    %RECALCULO OS CUSTOS
    for j=1:1:size(mataux_temp,1)
        for k=1:1:size(implantados,1)
            for m=1:1:size(custo_tunelamento_temp,a)
                %Procura na tabela de trenching
                if (custo_tunelamento_temp(m,2)==mataux_temp(j,1)&&custo_tunelamento_temp(m,3)==mataux_temp(j,2)&&custo_tunelamento_temp(m,4)==implantados(k,4)...
                        &&custo_tunelamento_temp(m,5)==implantados(k,5))
                    trenching=custo_tunelamento_temp(m,1);
                end
            end
            taxicab=((abs(mataux_temp(j,1)-implantados(k,4))+abs(mataux_temp(j,2)-implantados(k,5))));
            costs_temp=(taxicab*fibra)+trenching*(cano/2);
            if (costs_temp<costs(j,11)&&~((mataux_temp(j,1)==implantados(k,4))&&(mataux_temp(j,2)==implantados(k,5))))
                costs(j,1)=Value_Cost/costs(j,6);
                %guardo a quem ele se conectou
                costs(j,2)= implantados(k,4);
                costs(j,3)= implantados(k,5);
                %e quem estou adicionando
                costs(j,4)= mataux_temp(j,1);
                costs(j,5)= mataux_temp(j,2);
                costs(j,6)= costs(j,6);
                costs(j,7)= taxicab;
                costs(j,8)= taxicab*fibra;
                costs(j,9)= costs(j,9);
                costs(j,10)= trenching*(cano/2);
                costs(j,11)=costs_temp;
            end
       end
    end
 %############################################################
costs=sortrows(costs,7);
mataux_temp(:,1)=costs(:,4);
mataux_temp(:,2)=costs(:,5);
mataux_temp(:,3)=costs(:,7);
end
%########################################################################
%########################################################################