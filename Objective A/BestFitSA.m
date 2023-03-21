function LinkStates_metrix = BestFitSA(Routes_cellarray,NrOfLinks)
%function LinkStates_metrix = BestFitSA(sorted_request_matrix,linkID_cell,link_num)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The objective of this function is to implement Best Fit Assignment

    % Input
        % 1. Routes_cellarray - 
        % 2. NrOfLinks - 

    % Output
        % 1. LinkStates_metrix - the matrix is of size number_of_link * 320,
        %    in this matrix, '0' means the slot is not occupied, '1' means the
        %    slot has been occupied.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % store the state of each slot in LinkStates_metrix
    LinkStates_metrix = zeros(NrOfLinks,320);

    num_requests = length(Routes_cellarray);
    
    % start from the first request,since we have sort the request before in
    % function 'RequestSort.m'.
    for i = 1:num_requests
        linkID_needed = Routes_cellarray{i,1};       
        [block_size, index] = LinkUnoccupiedCheck(LinkStates_metrix(linkID_needed,:));
        unoccupied_slots_matrix = [block_size;index]';

        % first check if the slots needed can be put in the end of matrix,
        % if yes, no guard slots will be consumed.
        if isempty(block_size)
            disp("The resoures is not enough for request No." + num2str(i));
            continue;
        end 
        if (index(end)==320-block_size(end)+1 && block_size(end)==Routes_cellarray{i,3})
            LinkStates_metrix(linkID_needed,index(end):320) = 1;
            continue;
        end

        % If the above conditions do not hold,that means we have to pay a guard slot :)
        % sort the unoccupied block, and choose the minimum one that fit the request
        % For sorted_unoccupied_slots_matrix, the first column is block_size, the second column is index
        sorted_unoccupied_slots_matrix = sortrows(unoccupied_slots_matrix);
        [rows,~] = find(sorted_unoccupied_slots_matrix(:,1) > Routes_cellarray{i,3});

        if isempty(rows)
            disp("The resoures is not enough for request No." + num2str(i));
            continue;
        else
            % set the best fit slots to 1
            start_index = sorted_unoccupied_slots_matrix(rows(1),2);
            LinkStates_metrix(linkID_needed,start_index:start_index+Routes_cellarray{i,3}) = 1;    
        end
    end
end