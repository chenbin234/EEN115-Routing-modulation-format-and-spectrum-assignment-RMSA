function SP = Dijkstra(G,S,D)
% G topology of network. (i,j) is weighted distance between node i and j.
% S source node. 
% D destination node.
% Returns shortest path between S and D as a row vector.

Size = size(G);
NumNodes = Size(1); % Number of nodes
unvisited = 1:NumNodes; % Unvisited nodes.

PreviousNode = zeros(1,NumNodes); % Keeps track of the previous node of every node.
PreviousNode(S) = S;
CurrentNode = S;
Tentative = inf*ones(1,NumNodes);
Tentative(S) = 0;

while ~isempty(unvisited)
    CurrentDist = Tentative(CurrentNode); % Distance current node to source node
    Neighbors = G(CurrentNode,:); % Distance current node to all neighbors
    
    % Distance source node to unvisited neighbors through current node
    Neighbors = Neighbors(unvisited)+CurrentDist;
    
    for k = 1:length(unvisited)
        p = unvisited(k);
        if Neighbors(k) < Tentative(p)
            PreviousNode(p) = CurrentNode;
            Tentative(p) = Neighbors(k);
        end
    end
    [~,I] = min(Tentative(unvisited));
    OldNode = CurrentNode;
    CurrentNode = unvisited(I);
    unvisited = unvisited(unvisited ~= OldNode);
end

SP = D;
while true
    if SP(1) == S
        break
    end
    SP = [PreviousNode(SP(1)),SP];
end
end