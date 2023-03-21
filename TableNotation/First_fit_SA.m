function [slots_needed_matrix,linkstate_matrix] = First_fit_SA(G,Load)
    size_matrix = size(G);
    size_Load = size(Load);
    node_num = size_Load(1);
    % create a matrix of size(link_number*320) to track the state of all slots
    linkstate_matrix = zeros(size_matrix(1),320);
    % link_matrix store all the link number used - Fixed shortest path 
    [~,link_matrix] = Load2linknumMatrix(G,Load);
    
    % use DP-16QAM modulation
    slots_needed_matrix = ceil(Load*10/400*75/12.5);
    
    for i = 1:node_num
        for j = 1:node_num
            if (~isempty(link_matrix{i,j}) && slots_needed_matrix(i,j)~=0 )
                link_occupied_num = length(link_matrix{i,j});
                slots_needed = slots_needed_matrix(i,j);

                % check for available slots for the request
                for n = 1:(320-slots_needed+1)
                    if n == 1
                        if any(linkstate_matrix(link_matrix{i,j},1:1+slots_needed)) == zeros(1,1+slots_needed)
                            % 1 means the slots are occupied, 2 means guard slots
                            linkstate_matrix(link_matrix{i,j},1:slots_needed) = 1;
                            linkstate_matrix(link_matrix{i,j},1+slots_needed) = 2;
                            break;
                        end
                    elseif (n > 1 && n < 320-slots_needed+1)
                        if any(linkstate_matrix(link_matrix{i,j},n:n+slots_needed)) == zeros(1,1+slots_needed)
                            linkstate_matrix(link_matrix{i,j},n:n+slots_needed-1) = 1;
                            linkstate_matrix(link_matrix{i,j},n+slots_needed) = 2;
                            break;
                        end                        
                    else
                        if any(linkstate_matrix(link_matrix{i,j},1:1+slots_needed)) == zeros(1,1+slots_needed)
                            linkstate_matrix(link_matrix{i,j},1:slots_needed) = 1;
                            break;
                        else
                            disp('Resources is not enough for request'+ num2str([i j]));
                        end                        
                    end
                end
            end
        end
    end
    
end