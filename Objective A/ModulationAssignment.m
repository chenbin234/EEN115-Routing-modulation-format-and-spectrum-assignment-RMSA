function [slots_needed_matrix, cost_matrix,ModsNeeded_matrix] = ModulationAssignment(requests_matrix,distance_matrix)
    [NrOfRequests,K] = size(requests_matrix);
    slots_needed_matrix = zeros(NrOfRequests,K);
    cost_matrix = zeros(NrOfRequests,K);
    requests_matrix = ceil(0.1*requests_matrix); % in terms of 100 Gbps
    
    ModsNeeded_matrix = cell(NrOfRequests,K);
    
    n1 = 4;
    n2 = 7;
    
    for r=1:NrOfRequests
        for k=1:K
            if distance_matrix(r,k) > 700
                
                % SC-DP-QPSK need 4 slots per 100 Gbps
                slots_needed_matrix(r,k) = requests_matrix(r,k)*n1-1;
                cost_matrix(r,k) = requests_matrix(r,k)*1.5;
                ModsNeeded_matrix{r,k} = [requests_matrix(r,k) 0 0];
                
            elseif (distance_matrix(r,k) > 500) && (distance_matrix(r,k) <= 700) 
                
                % Never use SC-DP-QPSK if DP-QPSK is possible
                slots_needed_matrix(r,k) = ceil(requests_matrix(r,k)/2)*n1 - 1;
                cost_matrix(r,k) = ceil(requests_matrix(r,k)/2)*2;
                ModsNeeded_matrix{r,k} = [0 ceil(requests_matrix(r,k)/2) 0];
                
            elseif distance_matrix(r,k) <= 500
                % Check how many times we can use DP-16QAM
                DP_16QAM_num = floor(requests_matrix(r,k)/4);
                ModsNeeded_matrix{r,k} = [0 0 DP_16QAM_num];
                
                % Whats left? 
                % Integer from 0 to 3. (0 to 300 Gbps)
                remainder = requests_matrix(r,k)-DP_16QAM_num*4;
                
                % If 300 Gbps left
                if remainder == 3
                    % Use one more DP-16QAM
                    slots_needed_matrix(r,k) = (DP_16QAM_num+1)*n2 - 1;
                    cost_matrix(r,k) = (DP_16QAM_num+1)*3.7;
                    ModsNeeded_matrix{r,k} = ModsNeeded_matrix{r,k} + [0 0 1];
                
                % If nothing left
                elseif remainder == 0
                    % Add nothing more
                    slots_needed_matrix(r,k) = DP_16QAM_num*n2 - 1;
                    cost_matrix(r,k) = DP_16QAM_num*3.7;
                    
                % Otherwise its 100 or 200 Gbps left
                else
                    % Then add 1 DP-QPSK
                    slots_needed_matrix(r,k) = DP_16QAM_num*n2 + n1 - 1;
                    cost_matrix(r,k) = DP_16QAM_num*3.7 + 2;
                    ModsNeeded_matrix{r,k} = ModsNeeded_matrix{r,k}+[0 1 0];
                end
            end
        end
    end
end