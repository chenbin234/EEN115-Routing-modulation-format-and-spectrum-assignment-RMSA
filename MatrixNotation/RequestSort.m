function sorted_request_matrix = RequestSort(requests_matrix,distance_matrix,slots_needed_matrix)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The objective of this function is to Sort request in descending order
    % by the product of the path distance and bandwidth requirement.

    % Input
        % 1. requests_matrix - the request matrix(need to times 10 later, the unit is Gbit/s) 
        % 2. distance_matrix - the distance matrix is the output of routing
        %    algrithm, which is the length of path distributed to the request
        % 3. slots_needed_matrix - this input is the output of function 'ModulationAssignment'
        % Note: Three input should have the same size.

    % Output
        % 1. Sorted_request_matrix - the matrix is of size (in German
        %    secneriao) is (42-X)*3, 42=7*7-7 requests (we also need to minus X requests 
        %    which value is 0, becaue we don't need to process any spectrum which request is 0),
        %    3 columns are: the first column is source node, 
        %    the second column is destination node, the third column is slots needed.

    % Question ?
    % check with Marija whether we should use Gbit/s or FSUs usage as our
    % bandwidth measurement.
    % Currently, we use Gbit/s as the bandwidth measurement since Marija is the boss.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    size_matrix = size(requests_matrix);
    product_matrix = requests_matrix.*distance_matrix;

    % sort the product_matrix based on its value
    [value,index] = sort(product_matrix(:),'descend');
    [row,col] = ind2sub(size_matrix,index);
    
    % filter the request with value 0
    num_none_zero = nnz(value);

    % store the sorted and filtered request into Sorted_request_matrix
    % Sorted_request_matrix = zeros(num_none_zero,3);
    sorted_request_matrix = [row(1:num_none_zero) col(1:num_none_zero) slots_needed_matrix(row(1:num_none_zero),col(1:num_none_zero))];
    
end