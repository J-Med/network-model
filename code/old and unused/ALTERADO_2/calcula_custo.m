function [ costs ] = calcula_custo( usuario, micro, tunelamento, passo)
Value_micro=1600;
fibra = 0.16; %por metro
cano = 13; %por metro
Beta=1;

auxcost = false;
m=1;

for i = 1:length(micro)
   if (micro(i).faps==false && micro(i).deployed == true)
    auxcost = true;
    dist = [];
    taxicab = [];
    posi = [];
    k=1;
    
    
    for j = 1:length(micro);
      if (micro(j).faps==true)
       % if (micro(j).deployed == true) 
            %distancia de manhattan
            dist(k,1)=((abs(micro(i).x - micro(j).x)+ abs(micro(i).y - micro(j).y))); 
            %destino - fibra
            dist(k,2)= micro(j).x;
            dist(k,3)= micro(j).y;
            %origem
            dist(k,4)= micro(i).x;
            dist(k,5)= micro(i).y;
      %  end
      k = k+1;
      end
    end
        [taxicab,posi]= min(dist);
        
        tunelamento_temp=[];
        aux_exis=0;
        custo_temp = 0;
        
%dbstop in calcula_tunelamento2        
        [tunelamento_temp] = calcula_tunelamento2(dist, tunelamento_temp, passo);
       
        for h=1:size(tunelamento_temp,1)
            for j=1:size(tunelamento,1)
                if ((tunelamento_temp(h,1)==tunelamento(j,1)&&tunelamento_temp(h,2)==tunelamento(j,2)&&tunelamento_temp(h,3)==tunelamento(j,3)&&tunelamento_temp(h,4)==tunelamento(j,4))||...
                        (tunelamento_temp(h,1)==tunelamento(j,3)&&tunelamento_temp(h,2)==tunelamento(j,4)&&tunelamento_temp(h,3)==tunelamento(j,1)&&tunelamento_temp(h,4)==tunelamento(j,2)))
                        aux_exis=1;
                end
            end
            if aux_exis == 1
                custo_temp = custo_temp+0;
            else
                custo_temp = custo_temp + (passo*cano);
            end
        end
        costs(m,1)= Value_micro/length(micro(i).usuario)+((taxicab(1)*fibra)+(custo_temp))*Beta;
        costs(m,2)= dist(posi(1),2);
        costs(m,3)= dist(posi(1),3);
        costs(m,4)= micro(i).x;
        costs(m,5)= micro(i).y;
        costs(m,6)= length(micro(i).usuario);
        costs(m,7)= taxicab(1);
        costs(m,8)= taxicab(1)*fibra;
        costs(m,9)= custo_temp;
        costs(m,9) = micro(i).id;
        m = m + 1;
   end
end

 if auxcost == true
        costs = sortrows(costs,-1);
 else
    costs = [];
 end
end