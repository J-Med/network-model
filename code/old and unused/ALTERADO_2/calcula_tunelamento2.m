function [tunelamento2] = calcula_tunelamento2(dist, tunelamento_temp, passo)

tunelamento2 = [];
l=1;

[taxicab,posi]= min(dist);

%Salvo o caminho até ele
%Andando no X
if dist(posi(1),4) < dist(posi(1),2)
    atual=dist(posi(1),4);
    while atual < dist(posi(1),2)
        tunelamento2(l,1)=atual;
        tunelamento2(l,2)=dist(posi(1),5);
        tunelamento2(l,3)=atual+passo;
        tunelamento2(l,4)=dist(posi(1),5);
        atual=atual+passo;
        l=l+1;
    end
else
    atual=dist(posi(1),4);
    while atual > dist(posi(1),2)
        tunelamento2(l,1)=atual;
        tunelamento2(l,2)=dist(posi(1),5);
        tunelamento2(l,3)=atual-passo;
        tunelamento2(l,4)=dist(posi(1),5);
        atual=atual-passo;
        l=l+1;
    end
end
%Andando no Y
if dist(posi(1),5) < dist(posi(1),3)
    atual=dist(posi(1),5);
    while atual < posi(1,3)
        tunelamento2(l,1)=dist(posi(1),4);
        tunelamento2(l,2)=atual;
        tunelamento2(l,3)=dist(posi(1),4);
        tunelamento2(l,4)=atual+passo;
        atual=atual+passo;
        l=l+1;
    end
else
    atual=dist(posi(1),5);
    while atual > dist(posi(1),3)
        tunelamento2(l,1)=dist(posi(1),4);
        tunelamento2(l,2)=atual;
        tunelamento2(l,3)=dist(posi(1),4);
        tunelamento2(l,4)=atual-passo;
        atual=atual-passo;
        l=l+1;
    end
end
end