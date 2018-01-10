function [ usuario micro ] = atualizationBs( usuarioT, microT )

for i = 1:length(microT) %Passa o vetor temporario para o definitivo com os novos valores.
    micro(i) = microT(i);
end

for i = 1:length(usuarioT) %Passa o vetor temporario para a definitiva com os novos valores.
    usuario(i) = usuarioT(i);
end


end

