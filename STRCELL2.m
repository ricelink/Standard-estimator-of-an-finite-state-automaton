function s = STRCELL2(C)% {1,3}
if size(C,1)==1
    s = '{';
    if ~isempty(C)
        for i = 1:size(C,2)-1
            s = [s,C{1,i},','];
        end
        s =[s,C{1,size(C,2)}];
    end
    s =[s,'}'];
    return;
end
if size(C,2) ==1
    s = STRCELL2(C');
    return;
end
end
