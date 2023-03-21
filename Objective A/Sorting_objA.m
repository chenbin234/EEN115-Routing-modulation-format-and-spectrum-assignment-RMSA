function SortOrder_vector = Sorting_objA(slots_needed_matrix,Distances_matrix,LogDist_boolean,average_boolean)
% Assume there are Q requests to be routed.

% INPUTS:
% slots_needed_matrix: Q-by-K matrix. Element (i,j) is the the number of
% FSU slots needed for the jth shortest path for request i.

% Distances_matrix: Q-by-K matrix. Element (i,j) is the the distance of the
% jth shortest path for request i. 

% LogDist_boolean: Boolean (true or false). If you want to sort by
% log(distance) to slotneed product set to true.

% average_boolean: Boolean. If you want to sort through average by average
% distance-slotneed product, set to true.

% OUTPUTS:
% SortOrder_vector: Q-by-1 vector. Sorted order of the requests.

if LogDist_boolean
    Distances_matrix = log(Distances_matrix);
end

if average_boolean
    Sizes = size(slots_needed_matrix);
    K = Sizes(2);
    K_inv = 1/K;
    weights = K_inv.^(0:(K-1));
    
    slots_needed_matrix = slots_needed_matrix.*weights;
    Product_vector = sum(slots_needed_matrix.*Distances_matrix,2);
else
    Product_vector = slots_needed_matrix(:,1).*Distances_matrix(:,1);
end

[~,SortOrder_vector] = sort(Product_vector,'descend');
SortOrder_vector = SortOrder_vector(:);
end