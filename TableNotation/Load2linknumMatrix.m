function [distance_matrix,link_matrix] = Load2linknumMatrix(G,Load)
    size_matrix = size(Load);
    link_matrix = cell(size_matrix(1)); % store the corresponding link number needed of the path
    distance_matrix = zeros(size_matrix); % store the corresponding length
    node_num = size_matrix(1);

    % i is the source node
    for i = 1:node_num
        [path_metrix,distance] = Dijkstra_Algorithm(G,i);
        distance_matrix(i,:) = distance;
        % j is the dest node
        for j = 1:node_num
            [path] = show_path(i,j,path_metrix);
            link_matrix{i,j} = Path2linknum(G,path);
        end
    end

end