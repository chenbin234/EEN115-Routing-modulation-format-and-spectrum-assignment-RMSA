function [dists,paths] = KSP(G,S,D,K)
% Returns K-shortest paths and distanes
% paths - the K-shortest paths in a cell array
% dists - the distances of the corresponding paths (row vector)
% G: Network matrix. element (i,j) is the link distance between node i and
% j. If no link (i,j)==inf. If i==j (i,j) = 0;
% S source node.
% D destination node.

paths = {}; % Paths
dists = []; % Distances
[dists(1),paths{1}] = Dijkstra2(G,S,D); % Find shortest path.
G_alt = G; % A dummy matrix since the network will be altered in the algorithm.

B_paths = {}; % A cell array to store candidates of shortest paths.
B_dists = []; % A vector to store the distances of the candidate.

for k = 2:K
    Ak = paths{k-1}; % Take the path of the previous shortest path.
    
    for i = 1:length(Ak)-1 % Every node in that path (except destination)
        SpurNode = Ak(i); % A given node.
        RootPath = Ak(1:i); % The path before that node.
        
        % Check if that path is a subpath of any of the previous shortest
        % paths
        for j = 1:k-1
            Aprevlong = paths{j};
            if length(Aprevlong) >= i
                Aprev = Aprevlong(1:i);
            end
            
            if isequal(Aprev,RootPath) % If it is
                % Cut off the links after the given node following the previous
                % shortest paths. Alter the network.
                G_alt(Aprevlong(i),Aprevlong(i+1)) = inf;
            end
        end
        
        % Remove the ability to back-track onto the nodes before the given
        % node 
        if i>1
            G_alt(RootPath(1:end-1),:) = inf;
        end
        
        % Find the shortest path from the given node to the destination
        [dist,SpurPath] = Dijkstra2(G_alt,SpurNode,D);
        
        % Calculate the distance from the given node to the source
        G_alt = G; % Restore the original network for this
        distr = 0;
        for j=1:length(RootPath)-1
            distr = distr+G_alt(RootPath(j),RootPath(j+1));
        end
        
        % Remove the last element of to not take the given node twice.
        RootPath(end) = [];
        TotalPath = [RootPath SpurPath];
        
        % Check the resulting path is indeed unique.
        isNew = true;
        for j=1:length(B_paths)
            if isequal(TotalPath,B_paths{j})
                isNew = false;
            end
        end
        
        % if distance finite, path unique and does not back-track (visit nodes twice)
        if isfinite(distr+dist) && isNew
            % Store it as a possible candidate for the kth shortest path
            B_paths{end+1} = TotalPath;
            B_dists(end+1) = distr+dist;
        end
        G_alt = G; % Restore the network.
    end
    
    % If there are any candidates.
    if ~isempty(B_dists)  
        % Take the one with the minimum distance (source-destination)
        [~,I] = min(B_dists);
        paths{k} = B_paths{I}; % store it as the kth shortest path.
        dists(k) = B_dists(I); % store the distance.
        B_paths(I) = []; % remove the candidate path.
        B_dists(I) = []; % remove the candidate distance.
    else
        % if there arent any candidates. Stop the algorithm.
        return
    end 
end