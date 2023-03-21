%% Prototyping RMSA algorithm with real project data
clear
clc
clf
% close all

%% Project settings, load & reformat data

n = 'German';   % 'German' or 'Italian' topology

% Load and reformat data
% load topology and traffic matrices and extraxt topology data

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
    case 'Italian'
        load Italian-10nodes/IT10-topology.txt
        topology_data = IT10_topology;  
        disp('Case: Italian Topology')

        path = 'Italian-10nodes/';
        for i=1:5       % load all traffic data files
            filename = [path 'IT10-matrix-' num2str(i) '.txt'];
            load (filename)
        end       
end

% reformat data
[topology, linkID] = ReformatData(topology_data) % can use linkID to convert between linkID and the source and destination of a link, the linkIDs are stored in the exact same format as the topology

%% Calc shortest path with Dijkstra 

G = topology;             % topology data formatted where 1:s indicate a path
S = 2;                    % 7 possible nodes for german setup and 10 for the italian 
D = 7;                   

[dist,SP] = Dijkstra2(G,S,D) % Returns the shortest path from node S to D in terms of nodes.   

% get link information of shortest path
pathlinks = getLinkID(linkID, SP)   % the 3rd column is the linkID for the path

% highlight path in graph
figure(1)
plotPath(topology_data, SP)


%% Calc K-shortest paths and visualize

G = topology;
S = 7;
D = 4;
K=5;

% calc K-shortest paths
[distsKSP,pathsKSP] = KSP(G,S,D,K)

% get linkID information for all for all calculated paths from KSP
pathlinksKSP = {};
for i=1:K
    pathlinksKSP{i} = getLinkID(linkID, pathsKSP{i});
end

% plot all KSP with subplots
figure(2)
sgtitle([n ' Topology: KSP from node ' int2str(S) ' to ' int2str(D)])
for i=1:K
    subplot(ceil(K/2),2,i);
    plotPath(topology_data, pathsKSP{i}, i, distsKSP(i)) 
end


%% Use all KSP path lengths to use as input to get request info for difficulty ranking and modulation (naive way for making a dummy input of pathLengths in usable format for testing with KSP)
nodesNr = length(topology);
K = 5;
pathLengths_allKSP = cell(nodesNr,nodesNr);  % makes it ease to store K pathLengths in each cell of a matrix with the standard size
possibleSources = 1:nodesNr; % all possible sources

traffic_data=G7_matrix_3;   % example traffic_data

for i=1:length(topology)   % loop over each source
    currentSource = possibleSources(i);
    possibleDestinations = possibleSources;

    for j=1:length(topology)    % loop over each destination
        if traffic_data(i,j) ~= 0 || possibleDestinations(j) ~= currentSource % check if there is actually a request in traffic matrix
            currentDestination = possibleDestinations(j);

            [distsKSP,pathsKSP] = KSP(topology,currentSource,currentDestination,K);
            pathLengths_allKSP{i,j} = distsKSP;
        
        end
    end 
end

% Test of getRequestInfo and description of the output with examples of how to access
% The input of getRequestInfo is normal traffic_data and pathLengths as
% stored as pathLengths_allKSP (7x7 cells with 5 path values in each)

M=2; % how many of the k-shortest paths to consider when calculating difficulty
[requestSlots, requestDifficulty, sortedRequest_matrix] = getRequestInfo(traffic_data, pathLengths_allKSP, M);

% Examples of how to use the output: 

% requestSlots: Slots for each request and per modulation, (1 ='DP-QPSK'; 2 ='SC-DP-QPSK' ;  3 ='SC-DP-16QAM' ;  4 ='DP-16QAM') 
requestSlots{:};   % each of these 4 matrices refers to a modulation type
requestSlots{2}(1,2);  % this gives nr of slots for request S=1 to D=2 for modulation type 2

% requestModulationMatch: TODO
% should point to a modulation type for each request and each of its paths
% in a similar format as requestDifficulty

% requestDifficulty: Request difficulty metric based on request BW*pathlength
requestDifficulty{1,2};   % difficulty for all KSP for request s=1 and d=2
requestDifficulty{1,2}(1);  % difficulty for the shortest path of the KSP for one request 

%% Sort requests by difficulty and output matrix (nr_of_requests, 3)

traffic_data = G7_matrix_1;
[sortedRequest_matrix] = getSortByDifficulty(traffic_data, topology, 2)

%length(sortedRequest_matrix)











