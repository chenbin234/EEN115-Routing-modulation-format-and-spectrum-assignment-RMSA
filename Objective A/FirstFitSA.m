function LinkStates_matrix = FirstFitSA(Routes_cellarray,NrOfLinks_scalar)
    % Assume Routing has already been done. N requests in total.
    
    % INPUTS:
    % Routes_cellarray: N-by-3 cell array containing routed paths in
    % terms of linkIDs. Row i handles request i. Column 1 is the route in
    % terms of links. Column 2 is the distance of the route. Column 3 is
    % the number of FSUs needed for the route & request.
    
    % NrOfLinks_scalar: Scalar/integer of how many links there are in total.
    
    % OUTPUTS:
    % LinkStates_matrix: NrOfLinks_scalar-by-320 matrix. If element
    % (i,j)==0 then frequency slot j is free on link i. If element (i,j)==1
    % then frequency slot j is occupied on link i. 
    
    NrOfRequests = length(Routes_cellarray);
    NrOfFSUs = 320; 
    LinkStates_matrix = zeros(NrOfLinks_scalar,NrOfFSUs);  
    
    % For every request
    for i=1:NrOfRequests
        % The path/distance has been determined in routing.
        % The minimum number of needed FSUs/request has been determined in
        % modulation assignment. Used as inputs.
        
        SlotNeed = Routes_cellarray{i,3};
        LinkPath = Routes_cellarray{i,1};
        
        % Loop over the possible frequency slots (request has to fit)
        for j = 1:(NrOfFSUs-SlotNeed+1)
            if j<(NrOfFSUs-SlotNeed+1)
                
                % If the frequency slots are free in all the links
                % traversed. Fill the slots and add guard slot. 
                if sum(LinkStates_matrix(LinkPath,j:(j+SlotNeed)),'all')==0
                    LinkStates_matrix(LinkPath,j:(j+SlotNeed)) = 1;
                    break
                end
            
            % If we are at the last step.
            else
                
                % If slots are free in all the links traversed. Fill the
                % slots without adding a guard slot. 
                if sum(LinkStates_matrix(LinkPath,j:(j+SlotNeed-1)),'all')==0
                    LinkStates_matrix(LinkPath,j:(j+SlotNeed-1)) = 1;                

                % If it does not fit. Display it. Fix later. 
                else
                    disp(append('Request ',num2str(i),' doesnt fit!'))
                end
                
            end
        end     
    end
end
