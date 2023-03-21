function [path,distance] = Dijkstra_Algorithm_2(G,source,dest)
    node = unique(G(:,2));
    size_matrix = size(node);
    num_node = size_matrix(1);
    distance_metrix = zeros(1,num_node) + inf; % store the distance from the source
    path_metrix = zeros(1,num_node) - 1; % store the path    
    unvisited = 1:num_node;

    distance_metrix(source) = 0;
    current_node = source;

    while ~isempty(unvisited)
        index = find(G(:,2)==current_node);
        for i = 1:length(index)
            if ~ismember(G(index(i),3),unvisited)
                continue;
            end
            new_distance = distance_metrix(current_node) + G(index(i),4);
            if  distance_metrix(G(index(i),3)) > new_distance
                distance_metrix(G(index(i),3)) = new_distance;
                path_metrix(G(index(i),3)) = current_node;
            end    
        end
        unvisited(unvisited == current_node) = [];
        if isempty(unvisited)
            break;
        end
        current_node = unvisited(find(distance_metrix(unvisited) == min(distance_metrix(unvisited)),1));
    end
    % show the shorest path 
    path = [];
    temp = dest;
    % temp = find(node==dest);
    
    while path_metrix(temp) ~= -1
        path = [temp path];
        temp = path_metrix(temp);
    end
    path = [source path];
    % show the shorest path's length
    distance = distance_metrix(dest);

end