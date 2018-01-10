function [ usuario, micro, custo_final] = selectionBs_5Gpaper( usuario, micro, frequency, passo, l )
x = 0;
y = 0;
tunelamento=[];

for i = 1:length(micro)
    microT(i) = micro(i);
end

for i = 1:length(usuario)
    usuarioT(i) = usuario(i);
end

%dbstop in calcula_custo_5Gpaper
[ costs ] = calcula_custo_5Gpaper( usuarioT, microT, tunelamento, passo);

%aux=size(costs,1);

%while (aux>0)
uncoveredT = 0;

i=1;
custo_final = 0;
while (i <= size(costs,1))
    if (microT(costs(i,9)).check == 0)
        for z = 1:size(usuarioT,2)
            usuarioT(z).dataRate = 0;
            usuarioT(z).antenna = 0;
        end
        
        
        microT(costs(i,9)).deployed = false;
        microT(costs(i,9)).check = 1;

        [usuarioT microT uncovered] = updateScenario(usuarioT, microT, frequency);
        
        if(uncovered == 0)
            [usuario micro] = atualizationBs(usuarioT, microT);
        
        else
            microT(costs(i,9)).deployed = true;
            %dbstop in calcula_tunelamento
            [tunelamento l] = calcula_tunelamento(micro, l, tunelamento, costs, i, passo);
            %#############################################
            %#############################################
            %Só transformo em FAPS depois senão ele conta com o cara
            microT(costs(i,9)).faps = true;
            microT(costs(i,9)).implantacao = costs(i,1);
            [usuario micro] = atualizationBs(usuarioT, microT);
            custo_final = custo_final + costs(i,1);
        end
        %dbstop in calcula_custo;
        %[ costs ] = calcula_custo( usuario, micro, tunelamento, passo);
        i = 1;
    else
        i = i + 1;
    end
    % break;
end
end