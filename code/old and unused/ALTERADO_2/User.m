classdef User
         
    properties
        ux;
        uy;
        dataRate = 0;
        reqDataRate; % datarate required by the user
        antenna = 0;
        channel = 0;
        CQI = 0;
        SINR = 0;
        connected = false;
        velocity;
    end
    
    methods
    end
    
end

