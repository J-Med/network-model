function [ vet_CQI ] = graphCQI( users )

for i = 1:15
    vet_CQI(i) = 0;
    vet_pos(i) = i;
    
end

for i = 1:length(users)
    if(users(i).CQI > 15)
        vet_CQI(15) = vet_CQI(15) + 1;
    else
        vet_CQI(users(i).CQI) = vet_CQI(users(i).CQI) + 1; 
    end
end

end

