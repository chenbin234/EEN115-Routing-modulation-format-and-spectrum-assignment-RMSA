function [Routes_cellarray,totalcost_scalar] = RandomRouting(PathLinks_cellarray,slots_needed_matrix,Distances_matrix,NrOfRequests,cost_matrix,K)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The objective of this function is to implement Random routing

    % Input
        % 1. PathLinks_cellarray - size of (number_of_requests*K),K shortest path, store the linkID used 
        % 2. slots_needed_matrix - size of (number_of_requests*K)
        % 3. Distances_matrix - size of (number_of_requests*K)
        % 4. NrOfLinks - number of links
        % 5. cost_matrix - size of (number_of_requests*K)
        % 6. K - K shortest paths provided

    % Output
        % 1. Routes_cellarray: Q-by-3 cell array. Column 1 are the chosen routes in
        % terms of traversed links. Column 2 are the distances of the chosen
        % routes. Column 3 is the number of FSUs needed for the route/request.

        % totalcost_scalar: Scalar. Total cost of all requests and their routes.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    random_vector = randi([1 K],1,NrOfRequests);

    Routes_cellarray = cell(NrOfRequests,3);
    totalcost_scalar = 0;

    for i = 1:NrOfRequests
        Routes_cellarray{i,1} = PathLinks_cellarray{i,random_vector(1,i)};
        Routes_cellarray{i,2} = Distances_matrix(i,random_vector(1,i));
        Routes_cellarray{i,3} = slots_needed_matrix(i,random_vector(1,i));
        totalcost_scalar = totalcost_scalar+cost_matrix(i,random_vector(1,i));
    end

end