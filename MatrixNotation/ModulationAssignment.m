function [slots_needed_matrix, total_cost_scalar] = ModulationAssignment(requests_matrix,distance_matrix)
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The objective of this function is to minimize the use of bandwidth
    % Under the premise of meeting the request. In order to minimize the 
    % use of bandwidth, multiple modulations can be added together for one
    % request.

    % Input
        % 1. requests_matrix - the request matrix
        % 2. distance_matrix - the length of the path distributed to the request

    % Output
        % 1. slots_needed_matrix - the matrix is of needed slot for requests,
        %    it has the same size with requests_matrix
        % 2. total_cost_scalar - the total cost for all the requests.

    % Question?
    % if one request is distributed multiple modulations, is one guard slot
    % needed in the intersection of different modulation?
    % currently, I don't think it needs a guard between different modulation.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    requests_matrix = 10.*requests_matrix;
    size_requests = size(requests_matrix);
    node_number = size_requests(1);

    % store slots needed for each requests in slots_needed_matrix
    slots_needed_matrix = zeros(size_requests);
    % store cost in cost_matrix
    cost_matrix = zeros(size_requests);
    
    request_to_next_hundred = ceil(requests_matrix./100).*100;
    
    % for path longer than 700km, choose SC-DP-QPSK
    [a,b] = find(distance_matrix>700);
    slots_needed_matrix(a,b) =  request_to_next_hundred(a,b)./100.*3;
    cost_matrix(a,b) = request_to_next_hundred(a,b)./100.*1.5;

    % for path 500<length<=700, choose from SC-DP-QPSK and SC-DP-16QAM
    [c,d] = find(distance_matrix>500 & distance_matrix<=700);
    slots_needed_matrix(c,d) = floor(request_to_next_hundred(c,d)./200).*3 + mod(request_to_next_hundred(c,d),200)./100.*3;
    cost_matrix(c,d) = floor(request_to_next_hundred(c,d)./200).*2 + mod(request_to_next_hundred(c,d),200)./100.*1.5;

    % for path 0<length<=500, choose from SC-DP-QPSK, SC-DP-16QAM and DP-16QAM
    [e,f] = find(distance_matrix>0 & distance_matrix<=500);
    DP_16QAM_num = floor(request_to_next_hundred(e,f)./400);
    SC_DP_16QAM_num = floor(mod(request_to_next_hundred(e,f),400)./200);
    remain_request = request_to_next_hundred(e,f) - DP_16QAM_num.*400 - SC_DP_16QAM_num.*200;
    SC_DP_QPSK_num = remain_request./100;
    slots_needed_matrix(e,f) = DP_16QAM_num.*6 + SC_DP_16QAM_num.*3 + SC_DP_QPSK_num.*3;
    cost_matrix(e,f) = DP_16QAM_num.*3.7 + SC_DP_16QAM_num.*2 + SC_DP_QPSK_num.*1.5;

    % total_cost is the sum of cost_matrix
    total_cost_scalar = sum(cost_matrix,'all');
     
end