function pathlinks = getLinkID(linkID, path) 

    % initialize storage for source, destination, linkid
    m = zeros(length(path)-1,1);
    pathlinks = repmat(m,1,3);
    
    % find linkid based on the stored linkIDs that were formatted in same manner as topology data with index being source and destination of links
    for i=1:length(path)-1
        pathlinks(i,1:2) = path(i:i+1);        
        pathlinks(i,3) = linkID(pathlinks(i,1),pathlinks(i,2));
    end
end




