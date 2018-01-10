function [ graph ] = gerarGrafico( users, antennas )


    for i=1:length(users)
       ux(i) = users(i).ux;
       uy(i) = users(i).uy;
    end

    antenna = 1;
    for i=1:length(antennas)
       if (antennas(i).deployed == true)
        x(antenna) = antennas(i).x;
        y(antenna) = antennas(i).y;
        antenna = antenna + 1;
       end
        
     end

    graph = figure;

    plot(x,y,'b^', ux,uy,'kx');

    title('Gráfico Usuários x Micro');
    xlabel('Eixo x');
    ylabel('Eixo y');
    


    grid on
    grid minor
    
    
end