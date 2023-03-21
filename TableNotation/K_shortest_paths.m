function [A,A_distance] = K_shortest_paths(G, source, dest, K)

    A = {}; % store the ith shortest path from the source to dest.
    A_distance = [];
    B = {}; % store the potential kth shortest path.
    B_disntance = [];
    [A{1},A_distance(1)] = Dijkstra_Algorithm_2(G,source,dest);
    % G_original = G

    for k = 2:K   
        % set the spur node from source to the node before the last node
        for i = 1:length(A{k-1})-1
            G_original = G;
            spurNode = A{k-1}(i);
            rootPath = A{k-1}(1:i);
            
            % Remove the links
            for j = 1:length(A) 
                if (length(A{j}) >= i & rootPath == A{j}(1:i))
                    index = find(G_original(:,2)==A{j}(i) & G_original(:,3)==A{j}(i+1));
                    % G_original(index,:) = [];
                    G_original(index,4) = inf;
                end
            end
            % remove the node in rootPath expect spurNode
            if i > 1
                for m = 1:(i-1)
                    index_node = find(G_original(:,2)==rootPath(m) | G_original(:,3)==rootPath(m));
                    % G_original(index_node,:) = [];
                    G_original(index_node,4) = inf;
                end
            end
            
            % Calculate the spurPath from the spurnode to dest.
            [spurPath,spurPath_distance]= Dijkstra_Algorithm_2(G_original, spurNode, dest);
            
            if ~isinf(spurPath_distance)
                % total potential path
                totalPath = [rootPath spurPath(2:end)];
                
                % calculate the total length
                rootPath_distance = 0;
                if length(rootPath) > 1
                    for p = 1:length(rootPath)-1
                        index = find(G(:,2)==rootPath(p) & G(:,3)==rootPath(p+1));
                        rootPath_distance = rootPath_distance + G(index,4);
                    end
                end
    
                totalLength = rootPath_distance+spurPath_distance;
    
                % check if total in B
                size_B = size(B);
                check = 0;
                for n = 1:size_B(2)
                    check = isequal(totalPath,B{n});
                    if check == 1
                        break;
                    end
                end
                if check == 0 || size_B(2) == 0
                    B{end+1} = totalPath;
                    B_disntance(end+1) = totalLength;
                end
            end
        end

    	if(isempty(B))
		    return
	    end
        
        % take shortest path from B as kth path, store it into A
        kth_index = find(B_disntance==min(B_disntance));
        A{k} = B{kth_index};
        A_distance(k) = B_disntance(kth_index);
        
        % delete the kth shorest path from B
        B(kth_index) = [];
        B_disntance(kth_index) = [];
    end
end