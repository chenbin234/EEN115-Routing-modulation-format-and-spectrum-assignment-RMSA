function [dists,ProtectPaths] = PathProtection(G,path,S,D,K)
    % Assume there are N nodes in a network
    % INPUTS:
    % G: N-by-N matrix. Topology matrix of the network.
    % S: Scalar/Integer: Source node
    % D: Scalar/Integer: Destination node
    % path: A vector of a path through the network in terms of nodes
    % from S = path(1) to D = path(end).
    
    % OUTPUTS:
    % ProtectPaths: 1-by-K cell array. A set of paths in terms of
    % nodes not sharing any links with the input "path".
    
    path = path(:).';
    for i=1:length(path)-1
        G(path(i),path(i+1)) = inf;
    end
    [dists,ProtectPaths] = KSP(G,S,D,K);
end