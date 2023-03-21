%% Prototyping RMSA algorithm with real project data
%  clear
%  clc
%  close all

%% Project settings, load & reformat data

% Parameters we can choose
% n = "German";   % 'German' or 'Italian' topology
% n_request_integer = 1; % Integer 1 to 5. 1 chooses traffic matrix 1 and so on.
K = 1; % As in K-shortest paths

% Load and reformat data
% load topology and traffic matrices and extract topology data
switch n
    case "German"
        load Germany-7nodes/G7-topology.txt
        topology_data = G7_topology;   
        disp('Case: German Topology')

        path = 'Germany-7nodes/';
        for i=1:5           % load all traffic data files
            filename = [path 'G7-matrix-' num2str(i) '.txt'];
            load (filename)
        end
        
        switch n_request_integer
            case 1
                Traffic_matrix = G7_matrix_1;
            case 2
                Traffic_matrix = G7_matrix_2;
            case 3
                Traffic_matrix = G7_matrix_3;
            case 4
                Traffic_matrix = G7_matrix_4;
            case 5
                Traffic_matrix = G7_matrix_5;
        end
        
    case "Italian"
        load Italian-10nodes/IT10-topology.txt
        topology_data = IT10_topology;  
        disp('Case: Italian Topology')

        path = 'Italian-10nodes/';
        for i=1:5       % load all traffic data files
            filename = [path 'IT10-matrix-' num2str(i) '.txt'];
            load (filename)
        end
        
        switch n_request_integer
            case 1
                Traffic_matrix = IT10_matrix_1;
            case 2
                Traffic_matrix = IT10_matrix_2;
            case 3
                Traffic_matrix = IT10_matrix_3;
            case 4
                Traffic_matrix = IT10_matrix_4;
            case 5
                Traffic_matrix = IT10_matrix_5;
        end
end

%%%%
% 1. request sorting: output-request in different order(matrix), 3 column (source, dest, request size), row num - number of requests
% 2. Routing: output(cell,size(number_of_requests,2), 2- the first column Linknum(vector), the second column distance(km))
% 3. Modulation Assignment: output(row vector (1*num_of_request)), total_cost(a scalar)
% 4. Spectrum Assignment: LinkStates_metrix(number_of_link*320),’0’ means unoccupied, ‘1’ means occupied, guard slot-’1’

% if matrix, name the variable 'name_matrix',if cell, name the variable 'name_cell'
[topology_matrix, linkID_matrix] = ReformatData(topology_data); % can use linkID to convert between linkID and the source and destination of a link, the linkIDs are stored in the exact same format as the topology

% Purpose of the following part is to fit the structure to the agreed
% request format matrix(NrOfFSUs,3) <-> [source dest request_size]

% This also avoids unnecessary computation and may enable us to use minimum
% FSUs needed in the routing policy.

IsRequest = (Traffic_matrix>0);
NrOfNodes = length(topology_matrix);
NrOfRequest = sum(double(IsRequest),'all');
NrOfLinks = length(topology_data);


% The unordered requests. Row i represents request i.
% row structure: [source dest requestsize]
RequestList = zeros(NrOfRequest,3);

% Sorted requests. Row i represents request i. 
% Output: [source dest requestsize]
% The input nr indicates how many of the KSP are considerered when calc difficulty. Sorting is based on mean value of path difficulty so if nr=1
% then only the shortest path is considered. 
%[~, I] = getSortByDifficulty(Traffic_matrix, topology_matrix, 1); 


% Distances of the K-shortest paths. Row i has the distances of the
% K-shortest paths for request i.
% row structure [shortest path distance.... longest path distance] [km]
ShortestDist = zeros(NrOfRequest,1);

% Nodes traversed by the K-shortest paths
% row structure [shortest path (nodes) ... longest path (nodes)]
Shortest_PathNodes = cell(NrOfRequest,1);
Shortest_PathLink = cell(NrOfRequest,1);

% Go through the traffic matrix. Element (i,j) is request from i to j. Find
% KSP from i to j and store the path and the distance in the formats
% specified above. 
index = 1;
for i=1:NrOfNodes
    for j=1:NrOfNodes
        if IsRequest(i,j)
            RequestList(index,:) = [i j Traffic_matrix(i,j)];
            [ShortestDist(index,:),Shortest_PathNodes(index,:)] = KSP(topology_matrix,i,j,K);
            path = getLinkID(linkID_matrix,Shortest_PathNodes{index,1});
            Shortest_PathLink{index,1} = path(:,3)';
            index = index+1;
        end
    end
end

% Min number of slots needed.
% Element (i,j) is the min number of FSUs needed for the jth shortest path
% for request i. 
slots_needed=zeros(NrOfRequest,1);
cost = zeros(NrOfRequest,1);
[slots_needed(:,1),cost(:,1)] = ModulationAssignment(RequestList(:,3),ShortestDist(:,1));


% Sort in terms of slot_need*distance product. Save sorting order (I).
% Only use the shortest path to sort.
% Can take log() of distances for it to be less impactful.
[~,I] = sort(slots_needed(:,1).*log(ShortestDist(:,1)),'descend');

% Everything in order of slot_need*Distance product. :)
RequestList = RequestList(I,:);
slots_needed = slots_needed(I,:);
cost = cost(I,:);

% Now everything is ready for routing and SA
[Routes_cellarray,totalcost_scalar] = Routing_objA(Shortest_PathLink,slots_needed,ShortestDist,NrOfLinks,cost);
% FirstFitSA
linkstate_matrix_firstfit = FirstFitSA(Routes_cellarray,NrOfLinks);
% output para FirstFitSA
[FSU_highest, FSU_total,link_usage,utilization_entropy,shannon_entropy] = Performance_para(linkstate_matrix_firstfit);
FSU_highest_firstfit = max(FSU_highest);

% concrete a matrix to store all the information needed for function
% 'Writedata2excel.m'
data_stored_matrix_C = nan(100,7);
data_stored_matrix_C(1:length(FSU_highest),1) = FSU_highest;
data_stored_matrix_C(1:length(FSU_total),2) = FSU_total;
data_stored_matrix_C(1:length(link_usage),3) = link_usage;
data_stored_matrix_C(1:length(totalcost_scalar),4) = totalcost_scalar;
data_stored_matrix_C(1:length(utilization_entropy),5) = utilization_entropy;
data_stored_matrix_C(1:length(shannon_entropy),6) = shannon_entropy;
data_stored_matrix_C(1:length(ShortestDist),7) = ShortestDist;
