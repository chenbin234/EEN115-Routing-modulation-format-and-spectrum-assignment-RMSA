
%% load data

% load topology
load Germany-7nodes/G7-topology.txt

% load traffic matrices
load Germany-7nodes/G7-matrix-1.txt

% German topology
link_number = G7_topology(:,1);
source_node = G7_topology(:,4);
dest_node = G7_topology(:,5);
length = G7_topology(:,6);
G = [link_number source_node dest_node length];


% nodes_nr = max(data_topology(:,1));
% topology_formatted = ones(nodes_nr, nodes_nr)*inf;
% topology_formatted(1:1+size(topology_formatted,1):end) = 0

%% toy
% G = [1 1 2 1;2 1 3 6;3 2 1 1;4 2 3 2;5 2 4 1;6 3 1 6;7 3 2 2;8 3 4 2;9 3 5 5;10 4 2 1;11 4 3 2;12 4 5 5;13 5 3 5;14 5 4 5]
% G = [1 1 2 1;2 1 3 6;3 2 1 1;4 2 3 2;5 2 4 1;6 3 1 6;7 3 2 2;8 3 4 2;10 4 2 1;11 4 3 2;13 5 3 5;14 5 4 5]
% [link_num] = Path2linknum(G,[1 3 5 4])


% [path2,distance2] = Dijkstra_Algorithm_2(G,2,5)
[path,distance] = K_shortest_paths(G,3,5,30);


% [path_metrix,distance] = Dijkstra_Algorithm(G,7)
% [path] = show_path(7,1,path_metrix)

%% test first_fit SA

[distance_matrix,link_matrix] = Load2linknumMatrix(G,G7_matrix_1)
[slots_needed_matrix,linkstate_matrix] = First_fit_SA(G,G7_matrix_1)
[FSU_highest, FSU_total,link_usage,utilization_entropy,shannon_entropy] = Performance_para(linkstate_matrix)




