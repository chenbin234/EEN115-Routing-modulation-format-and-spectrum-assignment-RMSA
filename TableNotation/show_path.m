function [path] = show_path(source,dest,path_metrix)
    path = [];
    temp = dest;
    while path_metrix(temp) ~= -1
        path = [temp path];
        temp = path_metrix(temp);
    end
    path = [source path];
end