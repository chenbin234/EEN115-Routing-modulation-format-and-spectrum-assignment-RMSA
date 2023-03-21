function [topology_formatted, linkId_table] = ReformatData(topology_data)
% outputs: 
% - topology data formatted in a matrix where the indices determine source
% and destination of links
% - link data formatted in the same which can be used to extract linkid

    % extract topology, distance and link data
    s = topology_data(:,4);
    t = topology_data(:,5);
    distance = topology_data(:,6);
    link_data = topology_data(:,1);
    topology_data = [s t distance link_data];
    
    % initialization
    nodes_nr = max(topology_data(:,1));
    topology_formatted = ones(nodes_nr, nodes_nr)*inf;
    linkId_table = topology_formatted;
    topology_formatted(1:1+size(topology_formatted,1):end) = 0;
    
    % find index of outgoing links from a source and store topology and linkid data
    for i = 1:nodes_nr
        index = find(topology_data(:,1)==i);
        topology_formatted(i,topology_data(index(:),2)) = topology_data(index(:),3);
        linkId_table(i,topology_data(index(:),2)) = topology_data(index(:),4);
    end 

end