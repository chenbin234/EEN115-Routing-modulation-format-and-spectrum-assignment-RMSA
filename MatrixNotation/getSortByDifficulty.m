
function [sortedRequest_matrix, sortIndex] = getSortByDifficulty(traffic_data, topology, K)
% If you want to only sort by the shortest path, have K=1
% The difficulty is calculated as the mean of path difficulty of
% K nr of paths for each request and sorted by that metric
    
    traffic_data = 10*traffic_data;

    %% Calc pathlengths - change to an input variable
    nodesNr = length(topology);
    pathLengths = cell(nodesNr,nodesNr);  % makes it ease to store K pathLengths in each cell of a matrix with the standard size
    possibleSources = 1:nodesNr; % all possible sources
        
    for i=1:length(topology)   % loop over each source
        currentSource = possibleSources(i);
        possibleDestinations = possibleSources;
    
        for j=1:length(topology)    % loop over each destination
            if traffic_data(i,j) ~= 0 || possibleDestinations(j) ~= currentSource % check if there is actually a request in traffic matrix
                currentDestination = possibleDestinations(j);
    
                [distsKSP,~] = KSP(topology,currentSource,currentDestination,K);
                pathLengths{i,j} = distsKSP;
            end
        end 
    end

    %% Request difficulty metric 
    % requestBW*pathLength

    requestDifficulty = pathLengths;  % for same format
    requestDifficulty(:) = [];

    for i=1:length(pathLengths)
        for j=1:length(pathLengths)

            if  traffic_data(i,j) == 0 || isempty(pathLengths{i,j})
                % dont consider if there is no request or pathlength is
                % zero which would indicate same source as destination
            else
                tempLength = pathLengths{i,j};
                tempBW = repmat(traffic_data(i,j),1,K);
                tempDifficulty = tempBW.*tempLength;    % calc request difficulty for KSP of one request

                requestDifficulty{i,j}(:) = tempDifficulty(:);    
            end
        end
    end 

    %% Sort difficulty
    % adds request difficulty into a matrix with size based on
    % nr_of_request and includes source and destination [source destination requestSize]
    
    nr_requests = length(traffic_data(traffic_data > 0));
    sortedRequest_matrix = zeros(nr_requests,4);  % 4th col temporary in order to sort by difficulty
    m=1;

    for i=1:length(traffic_data)
        for j=1:length(traffic_data)
            if  traffic_data(i,j) == 0 || isempty(pathLengths{i,j})
                % dont consider if there is no request or pathlength is
                % zero which would indicate same source as destination
            else
            sortedRequest_matrix(m,1) = i;
            sortedRequest_matrix(m,2) = j;
            sortedRequest_matrix(m,3) = traffic_data(i,j);
            sortedRequest_matrix(m,4) = mean(requestDifficulty{i,j}(1:K));
            m=m+1;
            end
        end
    end

    [sortedRequest_matrix, sortIndex] = sortrows(sortedRequest_matrix,4,'descend');  % sort based on column with difficulty size
    sortedRequest_matrix(:,4) = [];  % remove column with difficulty


end







