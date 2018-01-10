function [vetor_results] = medias (usuario)

        mdr = 0; 
        mdr2 = 0;
        msinr = 0; 
        uc = length(usuario);
        uncovered = 0;
        jain = 0;
        
        for i = 1:length(usuario)
            mdr = mdr + usuario(i).dataRate;
            msinr = msinr + usuario(i).SINR;
            mdr2 = mdr2 + (usuario(i).dataRate)^2;
            if (usuario(i).connected)
            uc = uc - 1;
            end
        end
        
        for i=1:length(usuario) 
            if (usuario(i).dataRate < usuario(i).reqDataRate && usuario(i).connected == true)
                uncovered = uncovered + 1;
            end
        end
        
        mdr = mdr/length(usuario);
        msinr = msinr/length(usuario);
        jain = mdr^2 / length(usuario)*mdr2;
        
        vetor_results = [uc mdr msinr uncovered jain];

end