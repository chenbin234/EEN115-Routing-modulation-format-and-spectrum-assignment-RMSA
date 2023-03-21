function [] = plotPath(topology_data, path, K, dist) 
% Highlight shortest path in network graph 
% Uses the unformatted topology data to build the graph

    s = topology_data(:,4);
    t = topology_data(:,5);
    G_graph = digraph(s,t);
    
    p = plot(G_graph);
    
    % Find start and end node
    S = path(1);
    D = path(end);
    
    % dynamic titles
    if exist('K','var') && exist('dist','var')
        title(['Path ' int2str(K) ' (distance = ' int2str(dist) ')'])
    elseif exist('K','var') && ~exist('dist','var')
        title(['Path ' int2str(K)])
    else
        title(['Shortest path from node ' int2str(S) ' to ' int2str(D)])
    end

    labeledge(p,s,t,topology_data(:,1))
    
    p.NodeColor = 'k';
    p.MarkerSize = 7;
    p.ArrowSize= 13;
    p.LineWidth = 2;
    
    % Highlight shortest path in graph
    highlight(p,[S D],'NodeColor','r')
    highlight(p,path,'EdgeColor','r')
end