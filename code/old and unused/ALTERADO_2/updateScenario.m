function [ usuario, micro, uncovered ] = updateScenario( usuario, micro, frequency )

    uncovered = 0;
    aux = 1;
       
    for i=1:length(usuario) %Calcula o dataRate de cada usuario em cada antena e salva o maior. Cria um vetor de usuarios conectados por micro.
        
        for j=1:length(micro)
            if (micro(j).deployed == true && (micro(j).channels - length(micro(j).usuario)>0))
                dbstop calculateChannel
                [dataRate CQI SINR] = calculateChannel(usuario(i), micro(j), frequency, micro); %kbps
                vet(aux,1) = i;
                vet(aux,2) = j;
                vet(aux,3) =  dataRate;
                vet(aux,4) =  SINR;
                aux = aux +1;
%                 if (dataRate > usuario(i).dataRate)
%                     usuario(i).antenna = j;
%                     usuario(i).dataRate = dataRate;
%                     usuario(i).CQI = CQI;
%                     usuario(i).SINR = SINR;
%                 end
            end    
        end 
a = 0;
%         if(usuario(i).antenna ~= 0)
%         %     teste=[];
%              teste = micro(usuario(i).antenna).usuario;
%            if (length(find(teste == i)) == 0)
%                micro(usuario(i).antenna).usuario(length(micro(usuario(i).antenna).usuario)+1) = i;
%                for k=1:length(micro)
%                   if (usuario(i).antenna ~= k && length(micro(k).usuario)>0)
%                         micro(k).usuario(find(micro(k).usuario == i))=[];
%                   end
%                end
%            end
%         end
        
    end  
    
    for k=1:length(micro)
        micro(k).usuario=[];
        micro(k).channelsFREE = micro(k).channels;
    end
    
    for i=1:length(usuario)
        vet3 = [];
        %vet2 = vet(i);
        ind = find(vet(:,1)==i);
        
        for k=1:length(ind)
            vet2 = vet(ind(k),:);
            vet3 = vertcat(vet2,vet3);
        end
        
        vet3 = sortrows(vet3,-3);
        
        assigned = false;
        
        for j=1:size(vet3,1)
            %Calcular o quantitativo de canais necessários
            %ind2 = length(find(vet(:,2)==vet3(j,2)));
            ci = ceil(usuario(i).reqDataRate / vet3(j,3));
            
            if (micro(vet3(j,2)).channelsFREE > ci) 
                %faz a associacao
                assigned = true;
                %ind3 = round(micro(vet3(j,2)).channels / ind2);
                usuario(vet3(j,1)).antenna = vet3(j,2);
                usuario(vet3(j,1)).dataRate = vet3(j,3)*ci;
                usuario(vet3(j,1)).SINR = vet3(j,4);
                usuario(vet3(j,1)).channel = ci;
                usuario(vet3(j,1)).connected = true;
                
                micro(vet3(j,2)).channelsFREE = micro(vet3(j,2)).channelsFREE - ci;
                micro(vet3(j,2)).usuario(length(micro(vet3(j,2)).usuario)+1) = i;
                break;
            end
            %
        end
        %Avaliar se usuario achou ou nao antena pela variável assigned
        if (assigned == false)
            uncovered = uncovered + 1;
        end       
 end
    
    
    
    
%     for i = 1:length(micro) %Define quantos canais vão ter cada usuario.
%         
%         if(length(micro(i).usuario) > 0)
%             
%         if(length(micro(i).usuario) > micro(i).channels)
%             for j = 1:micro(i).channels
%             usuario(micro(i).usuario(j)).channel = 1;
%             usuario(micro(i).usuario(j)).connected = true;
%             end
%         else
%           while micro(i).channelsFREE > 0
%               for j = 1:length(micro(i).usuario)
%                  usuario(micro(i).usuario(j)).channel = usuario(micro(i).usuario(j)).channel + 1;
%                  usuario(micro(i).usuario(j)).connected = true;
%               end
%               micro(i).channelsFREE = micro(i).channelsFREE - length(micro(i).usuario);
%           end
%         end
%         
%         end
%     end

%     for i=1:length(usuario) %atualiza o dataRate de acordo com o número de canais dedicados;
%         usuario(i).dataRate = usuario(i).dataRate * usuario(i).channel;
%     end
      
%     for i=1:length(usuario) %Verifica se o dataRate do usuario está aceitável;
%         if (usuario(i).dataRate < usuario(i).reqDataRate && micro(usuario(i).antenna).deployed == true)
%             uncovered = uncovered + 1;
%         end
%         if (usuario(i).dataRate > usuario(i).reqDataRate && micro(usuario(i).antenna).deployed == 0)
%             uncovered = uncovered + 1;
%         end
%     end
    
    
       
end

