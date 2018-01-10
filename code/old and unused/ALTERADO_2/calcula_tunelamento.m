function [tunelamento l] = calcula_tunelamento(micro, l, tunelamento, costs, i, passo)
%Calculo a distancia ao elemento mais proximo e guardo ele
temp(1,1) = 10000000000000000000000000000000000000000000000000;

for k=1:length(micro)
    if micro(k).faps == 1
       % distance = (((micro(costs(i,9)).x - micro(k).x)^2) + ((micro(costs(i,9)).y-micro(k).y)^2))^0.5;
        distance = ((abs(micro(costs(i,9)).x - micro(k).x) + abs(micro(costs(i,9)).y - micro(k).y)));
        if distance < temp(1,1)
            temp(1,1) = distance;
            temp(1,2) = micro(k).id;
        end
    end
end

%Salvo o caminho até ele
%Andando no X
if micro(costs(i,9)).x < micro(temp(1,2)).x
    atual=micro(costs(i,9)).x;
    while atual < micro(temp(1,2)).x
        tunelamento(l,1)=atual;
        tunelamento(l,2)=micro(costs(i,9)).y;
        tunelamento(l,3)=atual+passo;
        tunelamento(l,4)=micro(costs(i,9)).y;
        atual=atual+passo;
        l=l+1;
    end
else
    atual=micro(costs(i,9)).x;
    while atual > micro(temp(1,2)).x
        tunelamento(l,1)=atual;
        tunelamento(l,2)=micro(costs(i,9)).y;
        tunelamento(l,3)=atual-passo;
        tunelamento(l,4)=micro(costs(i,9)).y;
        atual=atual-passo;
        l=l+1;
    end
end
%Andando no Y
if micro(costs(i,9)).y < micro(temp(1,2)).y
    atual=micro(costs(i,9)).y;
    while atual < micro(temp(1,2)).y
        tunelamento(l,1)=micro(temp(1,2)).x;
        tunelamento(l,2)=atual;
        tunelamento(l,3)=micro(temp(1,2)).x;
        tunelamento(l,4)=atual+passo;
        atual=atual+passo;
        l=l+1;
    end
else
    atual=micro(costs(i,9)).y;
    while atual > micro(temp(1,2)).y
        tunelamento(l,1)=micro(temp(1,2)).x;
        tunelamento(l,2)=atual;
        tunelamento(l,3)=micro(temp(1,2)).x;
        tunelamento(l,4)=atual-passo;
        atual=atual-passo;
        l=l+1;
    end
end
end