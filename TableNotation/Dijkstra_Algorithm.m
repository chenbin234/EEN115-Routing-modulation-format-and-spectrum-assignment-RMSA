function [path_metrix,distance_metrix] = Dijkstra_Algorithm(G,source)
    size_matrix = size(unique(G(:,2)));
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

end