function position = next_position(predecessor_pos, direction, distance)
% this function calculates new N-dimensional position vector based on a
% neighboring vector (predecessor_pos) and a distance
% INPUTS
% predecessor_pos ...   N-dim vector of a position relative to which will
%                       the next position (position) calculated
% direction       ...   whether left, right and so on in a form of a N-dim
%                       vector (not necessarily normalized - normalization 
%                       will take place here)
% distance        ...   distance of new pos relative to predecessor_pos
% 
% OUTPUT
% position        ...   N-dimensional vector of a position determined by inputs
    if norm(direction)==0
        normalized_direction = 0;
    else
        normalized_direction = direction/norm(direction);
    end
    position = predecessor_pos+normalized_direction*distance;
end