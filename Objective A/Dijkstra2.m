function [dist,SP] = Dijkstra2(G,S,D)
% This script returns the shortest path between S and D.
% G topology of network. (i,j) is weighted distance between node i and j.
% S source node. 
% D destination node.
% This one also exploits vector algebra for faster computation.

Size = size(G);
NumNodes = Size(1); % Number of nodes
unvisited = (1:NumNodes).'; % Unvisited nodes.

PreviousNode = S*ones(NumNodes,1); % Keeps track of the previous node of every node.
PreviousNode(S) = S;
CurrentNode = S;
Tentative = inf*ones(NumNodes,1);
Tentative(S) = 0;
noPath = false;

G = G.'; % To work with column vector
while ~isempty(unvisited)
    CurrentDist = Tentative(CurrentNode); % Distance current node to source node
    Neighbors = G(:,CurrentNode); % Distance current node to all neighbors
    
    % Distance source node to unvisited neighbors through current node
    Neighbors = Neighbors(unvisited)+CurrentDist;
    
    % Tentatives should be minimum of what it was and what we calculated.
    [Tentative(unvisited),inx] = min([Tentative(unvisited) Neighbors],[],2);
    
    % inx either 1 or 2. If 1 PreviousNode remains the same.
    % If 2 PreviousNode becomes the current node. 
    PreviousNode(unvisited) = PreviousNode(unvisited).*(2-inx)+(inx-1)*CurrentNode;
    
    [noPathTest,I] = min(Tentative(unvisited));
    if ~isfinite(noPathTest)
        noPath = true;
        break
    end
    OldNode = CurrentNode;
    CurrentNode = unvisited(I);
    unvisited = unvisited(unvisited ~= OldNode);
end

if noPath
    dist = inf;
    SP = [S D];
else
    PreviousNode = PreviousNode.';
    dist = Tentative(D);
    SP = D;
    while true
        if SP(1) == S
            break
        end
        SP = [PreviousNode(SP(1)),SP];
    end
end

end