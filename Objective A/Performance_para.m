function [FSU_highest, FSU_total,link_usage,utilization_entropy,shannon_entropy] = Performance_para(linkstate_matrix)
    size_link = size(linkstate_matrix);
    link_number = size_link(1);

    % Highest used FSU on any link
    FSU_highest = zeros(link_number,1);
    for j = 1:link_number

    % sum_linkstate_matrix = sum(linkstate_matrix);
        for i = 1:320
            if linkstate_matrix(j,320-i+1) ~=0
                FSU_highest(j,1) = 320-i+1;
                break;
            end
        end
    end
    % Total number of used FSUs
    rows_sum_linkstate_matrix = sum(linkstate_matrix,2);
    FSU_total = sum(rows_sum_linkstate_matrix);
   
    % Link usage distribution
    link_usage = rows_sum_linkstate_matrix./320;

    
    % Path length distribution


    % Distribution of transponder cost

    
    
    % utilization_entropy & shannon_entropy
    utilization_entropy = zeros(link_number,1);
    shannon_entropy = zeros(link_number,1);
    for j = 1:link_number
        block = [];
        left = 1;
        for right = 2:length(linkstate_matrix(1,:))
            if linkstate_matrix(j,right) ~= linkstate_matrix(j,left)
                block = [block right-left];
                left = right;
            end
        end
        block = [block right-left+1];
        num_status_changes = length(block)-1;
        
        % utilization_entropy 
        utilization_entropy(j,1) = num_status_changes/319;
        
        % shannon_entropy
        H_frag_j = -1.*(block./320).*(log(block./320));
        shannon_entropy(j,1) = sum(H_frag_j);
    end



    
end