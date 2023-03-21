function [link_num] = Path2linknum(G,path)
    if length(path) == 1
        link_num = [];
    else
        link_num = zeros(1,length(path)-1);
        for i = 1:length(path)-1
            link_num(i) = find(G(:,2)==path(i) & G(:,3)==path(i+1));
        end
    end
end