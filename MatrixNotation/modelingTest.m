%% Test of modeling network graphs
% based on https://se.mathworks.com/help/matlab/ref/graph.plot.html
% and https://se.mathworks.com/help/matlab/math/graph-plotting-and-customization.html
% probably good idea to put the original topologies into containers in
% structures or something and then keep records of status separate
clear all
clc

%% Undirected graph

s = [1 1 2 2 3 3 4 5];   % source
t = [2 3 4 3 4 5 6 6];   % destination
G = graph(s,t)           % create undirected graph

figure()
plot(G)
title('Undirected graph')

%% Undirected graph with weights

s = [1 1 2 2 3 3 4 5];
t = [2 3 4 3 4 5 6 6];
weights = [15 10 20 50 90 10 30 20];
G = graph(s,t,weights)

figure()
plot(G,'EdgeLabel',G.Edges.Weight)
title('Undirected graph with weights')

%% Undirected graph with weights (lines changing with weight)

s = [1 1 2 2 3 3 4 5];
t = [2 3 4 3 4 5 6 6];
weights = [15 10 20 50 90 10 30 20];
G = graph(s,t,weights)

% if you want linewidt to change with weight

LWidths = 8*G.Edges.Weight/max(G.Edges.Weight);   % the nr before multiplication decides how large the linewidth can be

figure()
plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths)
title('Undirected graph with weights (lines changing with weight)')


%% Directed graph

s = [1 1 2 2 3 3 4 5 2 3 4 3 4 5 6 6];
t = [2 3 4 3 4 5 6 6 1 1 2 2 3 3 4 5];   
G = digraph(s,t)            % create directed graph

figure()
plot(G)
title('Directed graph')


%% Directed graph with weights

s = [1 1 2 2 3 3 4 5 2 3 4 3 4 5 6 6];
t = [2 3 4 3 4 5 6 6 1 1 2 2 3 3 4 5];   
weights = [15 10 20 50 90 10 30 20 15 20 30 50 150 10 40 20];

G = digraph(s,t,weights)            

figure()
plot(G,'EdgeLabel',G.Edges.Weight)
title('Directed graph with weights')

%% Directed graph with weights (testing)

s = [1 1 2 2 3 3 4 5 2 3 4 3 4 5 6 6];
t = [2 3 4 3 4 5 6 6 1 1 2 2 3 3 4 5];   
weights = [15 10 20 50 90 10 30 20 15 20 30 50 150 10 40 20];

G = digraph(s,t,weights)            

figure()
p = plot(G,'EdgeLabel',G.Edges.Weight)
title('Directed graph with weights, testing settings')

G.Edges.LWidths = 7*G.Edges.Weight/max(G.Edges.Weight);
p.LineWidth = G.Edges.LWidths;


%% Testing display styles

s = [1 1 2 2 3 3 4 5 2 3 4 3 4 5 6 6];
t = [2 3 4 3 4 5 6 6 1 1 2 2 3 3 4 5];   
weights = [17 80 14 50 80 10 24 30 15 20 30 50 114 75 40 20];

G = digraph(s,t,weights)            

figure()
p = plot(G,'EdgeLabel',G.Edges.Weight)
title('Directed graph with weights, settings testing')

p.NodeColor = 'red';
p.NodeLabel = {'A', 'B','C','D','E','F'};
p.MarkerSize = 7;
p.ArrowSize=15;


G.Edges.LWidths = 7*G.Edges.Weight/max(G.Edges.Weight);
p.LineWidth = G.Edges.LWidths;

%% Testing highlighting paths

s = [1 1 2 2 3 3 4 5 2 3 4 3 4 5 6 6 7];
t = [2 3 4 3 4 5 6 6 1 1 2 2 3 3 4 5 6];   
weights = [17 80 14 60 80 10 78 30 15 20 30 50 114 75 40 20 60];

G = digraph(s,t,weights)            

figure()
p = plot(G,'EdgeLabel',G.Edges.Weight)
title('Directed graph with weights, settings testing')


p.NodeColor = 'k';
p.NodeLabel = {'1', '2','3','4','5','6', '7'};   % could be nice to have access to node nr from their corresponding labels
p.MarkerSize = 7;
p.ArrowSize=15;
p.NodeFontWeight = 'bold';

G.Edges.LWidths = 7*G.Edges.Weight/max(G.Edges.Weight);
p.LineWidth = G.Edges.LWidths;

% Highlight paths
path1 = shortestpath(G,1,5)   % perhaps not something we should use in project but good to see how we can format in order to highlight a path
highlight(p,path1,'EdgeColor','m')

path2 = shortestpath(G,5,1)   % perhaps not something we should use in project but good to see how we can format in order to highlight a path
highlight(p,path2,'EdgeColor','b')


highlight(p,[4 6],[6 5],'EdgeColor','g')


% Highlight nodes
highlight(p,[1 2 3],'NodeColor','r')


%% Test with project topologies
%clear all
%clc

%# LinkID	ContactA	ContactB	NodeA	NodeB	Length 
% Had to remove text header in order to load data easily

%load Germany-7nodes/G7-topology.txt
%load Italian-10nodes/IT10-topology.txt

% German topology
s_g = G7_topology(:,4);
t_g = G7_topology(:,5);
weights_g = G7_topology(:,6);

G_g = digraph(s_g,t_g,weights_g)            

figure()
p_g = plot(G_g,'EdgeLabel',G_g.Edges.Weight)
title('German Topology')

p_g.NodeColor = 'k';
p_g.NodeLabel = {'1','2','3','4','5','6','7'};  
%p_g.EdgeLabel
%={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22'};%edgelabel
%makes the weights not show
p_g.MarkerSize = 7;
p_g.ArrowSize=15;
p_g.NodeFontWeight = 'bold';

G_g.Edges.LWidths = 7*G_g.Edges.Weight/max(G_g.Edges.Weight);
p_g.LineWidth = G_g.Edges.LWidths;


% Italian topology
s_i = IT10_topology(:,4);
t_i = IT10_topology(:,5);
weights_i = IT10_topology(:,6);

G_i = digraph(s_i,t_i,weights_i)            

figure()
p_i = plot(G_i,'EdgeLabel',G_i.Edges.Weight)
title('Italian Topology')

p_i.NodeColor = 'k';
p_i.NodeLabel = {'1','2','3','4','5','6','7','8','9','10'};  
%p_i.EdgeLabel
%={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30'};%edgelabel
%makes the weights not show
p_i.MarkerSize = 7;
p_i.ArrowSize=15;
p_i.NodeFontWeight = 'bold';

G_i.Edges.LWidths = 7*G_i.Edges.Weight/max(G_i.Edges.Weight);
p_i.LineWidth = G_i.Edges.LWidths;

%%  attempt at loading the load matrices
clc
clear all

x = 1 % which load
path = ['Germany-7nodes/']
filename = [path 'G7-matrix-' num2str(x) '.txt']

load (filename)



