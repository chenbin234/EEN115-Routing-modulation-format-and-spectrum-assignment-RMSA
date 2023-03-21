function [FSU_highest, FSU_total,link_usage,utilization_entropy,shannon_entropy] = Performance_para(linkstate_matrix)
    size_link = size(linkstate_matrix);
    link_number = size_link(1);
    
    % solt_info_matrix stores how many times 0/1/2 appear in each row
    solt_info_matrix = zeros(link_number,3);

    for i = 1:link_number
        solt_info_matrix(i,:) = [sum(linkstate_matrix(i,:)==0) sum(linkstate_matrix(i,:)==1) sum(linkstate_matrix(i,:)==2)];
    end
    
    FSU_highest = solt_info_matrix(:,2);
    FSU_total = sum(sum(solt_info_matrix(:,[2 3])));
    link_usage = (solt_info_matrix(:,2)+solt_info_matrix(:,3))/320;
    
    % utilization_entropy needs to be modified
    utilization_entropy = ((solt_info_matrix(:,3)-1)*2+1)/319;
    
    % shannon entropy
    linkstate_matrix_transfer = linkstate_matrix;
    linkstate_matrix_transfer(linkstate_matrix_transfer(:)==2) = 0;
    shannon_entropy = zeros(link_number,1);
    for j = 1:link_number
        block = []
        left = 1;
        for right = 2:320
            if linkstate_matrix_transfer(j,right) ~= linkstate_matrix_transfer(j,left)
                block = [block right-left];
                left = right;
            end
        end
        block = [block right-left+1];
        H_frag_j = -1.*(block./320).*log(block./320);
        shannon_entropy(j,1) = sum(H_frag_j);
    end
end