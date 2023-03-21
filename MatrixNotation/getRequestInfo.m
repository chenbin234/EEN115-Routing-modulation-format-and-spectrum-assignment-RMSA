% input: standard traffic_data, lengths of all KSP paths in matrix notation (each cell with K lengths)
% output: matrices in 4 cells for each modulation type that are each
% same size as the given traffic_data where each request is calculated
% according to: ceil(requestsize/modulationrate)*slots per modulation

% Example of how to get data from pathModulation:
% requestModInformation{1}(1,2) where you request the slots matrix info for
% modulation type DP-QPSK and get the info for the request from S=1 and D=2

% requestModulationMatch has same notation as pathLengths with matrix notation cells of K nr:s in  
% but instead stores nr from 1 to 4 depending on modulation type (see ModulationType container)

% requestDifficulty should be of matrix notation 

function [requestSlots, requestDifficulty, sortedRequest_matrix] = getRequestInfo(traffic_data, pathLengths, M)

    % known information about modulation constraints stored in static containers
    ModulationType = containers.Map({1 2 3 4}, {'DP-QPSK' 'SC-DP-QPSK' 'SC-DP-16QAM' 'DP-16QAM'});
    slotsize = 12.5;   % GHz
    traffic_data = 10*traffic_data;  % unit 10 Gbps

    ModulationRate = containers.Map({'DP-QPSK' 'SC-DP-QPSK' 'SC-DP-16QAM' 'DP-16QAM'}, {100 100 200 400});
    ModulationBW = containers.Map({'DP-QPSK' 'SC-DP-QPSK' 'SC-DP-16QAM' 'DP-16QAM'}, {50 37.5 37.5 75});
    ModulationMaxLength = containers.Map({'DP-QPSK' 'SC-DP-QPSK' 'SC-DP-16QAM' 'DP-16QAM'}, {2000 2000 700 500});
    %ModulationCost = containers.Map({'DP-QPSK' 'SC-DP-QPSK' 'SC-DP-16QAM' 'DP-16QAM'}, {1.5 1.5 2 3.7}); 

    %% Calculate nr of slots for each request per modulation type
    requestSlots = cell(1,4);                % store slots depending on modulation type
   
    for i = 1:4   % refers to the keys of the modulationType container
        calcSlots = ceil(traffic_data./ModulationRate(ModulationType(i))).*(ModulationBW(ModulationType(i))/slotsize);
        requestSlots{i} = calcSlots;
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
                tempBW = repmat(traffic_data(i,j),1,5);
                tempDifficulty = tempBW.*tempLength;    % calc request difficulty for KSP of one request

                requestDifficulty{i,j}(:) = tempDifficulty(:);    
            end
        end
    end 

    %% Sort difficulty
    
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
            sortedRequest_matrix(m,4) = mean(requestDifficulty{i,j}(1:M));
            m=m+1;
            end
        end
    end

    sortrows(sortedRequest_matrix,4);  % sort based on column with difficulty size
    sortedRequest_matrix(:,4) = [];  % remove column with difficulty


end







