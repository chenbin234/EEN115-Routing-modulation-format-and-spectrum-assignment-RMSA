function [block_size, index] = LinkUnoccupiedCheck(linkID_needed_matrix)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The objective of this function is to check the linkID_needed_matrix
    % unoccupied slots, return the block size and its start location, 
    % the output can be used by Best_Fit_SA or First_FIT_SA.

    % Input
        % 1. linkID_needed_matrix -  size n*320, n is the number of linkID
        %    selected

    % Output
        % 1. block_size - it is a Vector, each element shows how many
        %    continous unoccupied slots found
        % 2. index - it is a Vector too, the same size of block_size, each
        %    element shows the start location of the block.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    num_rows = length(linkID_needed_matrix(:,1));
    
    % add each row of linkID_needed_matrix as a vector
    if num_rows == 1
        sum_vector = linkID_needed_matrix;
    else
        sum_vector = sum(linkID_needed_matrix);
    end
    
    block_size = [];
    index = [];
    left = 1;
    for right = 2:length(sum_vector)
        if sum_vector(left) ~=0
            left = left+1;   
        elseif (sum_vector(left) == 0 & sum_vector(right) > 0) 
            block_size = [block_size right-left];
            index = [index left];
            left = right+1;
        elseif (sum_vector(left) == 0 & sum_vector(right) == 0 & right == length(sum_vector))
            block_size = [block_size right-left+1];
            index = [index left];
            break;
        else
            continue;
        end
    end
end