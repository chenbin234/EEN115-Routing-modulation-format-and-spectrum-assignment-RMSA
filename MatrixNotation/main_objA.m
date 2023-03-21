%% Prototyping RMSA algorithm with real project data
clear
clc
% close all

%% Project settings, load & reformat data

% Parameters we can choose
n = 'Italian';   % 'German' or 'Italian' topology
n_request_integer = 5; % Integer 1 to 5. 1 chooses traffic matrix 1 and so on.
K = 3; % As in K-shortest paths

% Load and reformat data
% load topology and traffic matrices and extract topology data
switch n
    case 'German'
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
        
    case 'Italian'
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
NrOfRequests = sum(double(IsRequest),'all');
NrOfLinks = length(topology_data);

% The unordered requests. Row i represents request i.
% row structure: [source dest requestsize]
RequestList_matrix = zeros(NrOfRequests,3);

% Distances of the K-shortest paths. Row i has the distances of the
% K-shortest paths for request i.
% row structure [shortest path distance.... longest path distance] [km]
Distances_matrix = zeros(NrOfRequests,K);

% Nodes traversed by the K-shortest paths
% row structure [shortest path (nodes) ... longest path (nodes)]
PathNodes_cellarray = cell(NrOfRequests,K);
PathLinks_cellarray = cell(NrOfRequests,K);

% Go through the traffic matrix. Element (i,j) is request from i to j. Find
% KSP from i to j and store the path and the distance in the formats
% specified above. 
index = 1;
for i=1:NrOfNodes
    for j=1:NrOfNodes
        if IsRequest(i,j)
            RequestList_matrix(index,:) = [i j Traffic_matrix(i,j)];
            [Distances_matrix(index,:),PathNodes_cellarray(index,:)] = KSP(topology_matrix,i,j,K);
            for k=1:K
                path = getLinkID(linkID_matrix,PathNodes_cellarray{index,k});
                PathLinks_cellarray{index,k} = path(:,3)';
            end
            index = index+1;
        end
    end
end

% Min number of slots needed.
% Element (i,j) is the min number of FSUs needed for the jth shortest path
% for request i. 
slots_needed_matrix = zeros(NrOfRequests,K);

for k=1:K
    [slots_needed_matrix(:,k),~] = ModulationAssignment(RequestList_matrix(:,3),Distances_matrix(:,k));
end

% Sort in terms of slot_need*distance product. Save sorting order (I).
% Only use the shortest path to sort.
% Can take log() of distances for it to be less impactful.
[~,I] = sort(slots_needed_matrix(:,1).*Distances_matrix(:,1),'descend');

% Everything in order of slot_need*Distance product. :)
RequestList_matrix = RequestList_matrix(I,:);
Distances_matrix = Distances_matrix(I,:);
PathNodes_cellarray = PathNodes_cellarray(I,:);
PathLinks_cellarray = PathLinks_cellarray(I,:);
slots_needed_matrix = slots_needed_matrix(I,:);

% Now everything is ready for routing and SA
Routes_cellarray = Routing_objA(PathLinks_cellarray,slots_needed_matrix,Distances_matrix,NrOfLinks);
LinkStates = FirstFitSA(Routes_cellarray,NrOfLinks);

test = sum(LinkStates,2);
plot(test)