function Qstr = Str(Q) 
%  Q={   0 ,     2}   Str(Q) =    {2,0}
Qstr = '';
if size(Q,2) == 1
    Qstr=['{', Q{1,1},'}'];
    return
end
Qstr = '{';
for i = 1:size(Q,2)-1
    Qstr = [Qstr,Q{1,i},',',];
end
Qstr = [Qstr,Q{1,size(Q,2)},'}'];
% Qstr = ['{',Qstr,'}'];
end