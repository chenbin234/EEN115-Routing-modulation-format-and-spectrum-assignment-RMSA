function Routes_cellarray = Routing_objA(PathLinks_cellarray,slots_needed_matrix,Distances_matrix,NrOfLinks)
% Assume there are N nodes in a network
% Assume there are Q requests to be routed.

% INPUTS:
% PathLinks_cellarray: Q-by-K cell array. Element (i,j) is the jth shortest
% path in terms of links for request i.

% slots_needed_matrix: Q-by-K matrix. Element (i,j) is the the number of
% FSU slots needed for the jth shortest path for request i.

% Distances_matrix: Q-by-K matrix. Element (i,j) is the the distance of the
% jth shortest path for request i. 

% NrOfLinks_integer: Integer. Total number of links. 

% OUTPUTS:
% Routes_cellarray: Q-by-2 cell array. Column 1 are the chosen routes in
% terms of traversed links. Column 2 are the distances of the chosen
% routes.

LinkLoads = zeros(NrOfLinks,1); % A vector of the loads on each link. 
DummySize = size(slots_needed_matrix);

NrOfRequests = DummySize(1); % Number of requests
K = DummySize(2); % K as in K-shortest paths.

Routes_cellarray = cell(NrOfRequests,3);

for i=1:NrOfRequests
    paths = PathLinks_cellarray(i,:);
    
    MinMaxLinkLoad = inf; % The min max link load of a path;
    PathChoice = 1; % Assume the shortest path;
    
    % For the K shortest paths
    for j=1:K       
        % Calculate load of the most loaded link
        MaxLinkLoad = max(LinkLoads(paths{j}));
        
        % Store the min max link load path.
        if MinMaxLinkLoad > MaxLinkLoad
            MinMaxLinkLoad = MaxLinkLoad;
            PathChoice = j;
        end
    end
    
    % take that path and update the link loads
    ChosenPath = paths{PathChoice};
    LinkLoads(ChosenPath) = LinkLoads(ChosenPath)+slots_needed_matrix(i,PathChoice);
    Routes_cellarray{i,1} = ChosenPath;
    Routes_cellarray{i,2} = Distances_matrix(i,PathChoice);
    Routes_cellarray{i,3} = slots_needed_matrix(i,PathChoice);
end
end