function [] = fig_automaton(automaton, filename_no_ext, L)
% L = 1. parallelogram; 2. box.  default = circle
if nargin < 2
    filename_no_ext = inputname(1);
    L = 0;
end
if nargin == 2
    L = 0;
end
if isempty(automaton.trans)
    fprintf('empty %s \n', filename_no_ext)
    if exist([filename_no_ext,'.svg'],'file')
        delete([filename_no_ext '.svg']);
    end
    return
end
fig_automaton_dot(automaton, filename_no_ext, L)
system(['dot -Tsvg ', filename_no_ext, '.dot -o ', filename_no_ext, '.svg']);
%system(['dot -Tpng ' filename_no_ext '.dot -o ' filename_no_ext '.png']);
delete([filename_no_ext '.dot']);
end





function [] = fig_automaton_dot(automaton, filename_no_ext, L)
% L 1. parallelogram; 2. box
%   fig  Generates a png-figure from an automaton.
%   Requires installation of Graphviz (http://www.graphviz.org).
%   Add Graphviz bin folder to the system path.
%   fig_automaton=fig_automaton_multi
%   L represents shapes of states
% if nargin == 3

% end
% if nargin < 2
%         filename_no_ext = inputname(1);
%         SHAPE='circle';
% end
SHAPE =Shape_graph(uint8(L));
fid = fopen([filename_no_ext '.dot'], 'w');
fprintf(fid, 'digraph G {\n');
if ~isfield(automaton,'opaque_states')
    automaton.opaque_states = {};
end
S = setdiff(automaton.states, automaton.opaque_states);
if ~isempty(S)
    for i = 1:size(S,2)
        state = S(i);
%         if contains(state,'+')%K-transformation identify Q- 20210224
%             fprintf(fid, '\t"%s" [shape=trapezium];\n', state{1});
%         else
%             fprintf(fid, '\t"%s" [shape=%s];\n', state{1},SHAPE);
%         end
         fprintf(fid, '\t"%s" [shape=%s];\n', state{1},SHAPE);
    end
end
if isfield(automaton,'opaque_states')
    for state = automaton.opaque_states
        if isempty(state)
            break;
        end
        fprintf(fid, '\t"%s" [shape=%s, color=red];\n', state{1},SHAPE); %hotpink
        %         fprintf(fid, '\t"%s" [shape=parallelogram, color=red];\n', state{1});
    end
end
%%%%%%%%%%%%%%%%%%%%%%if non_opaque_states  2021 0222 19:10  for
%%%%%%%%%%%%%%%%%%%%%%transformation
if isfield(automaton,'non_opaque_states')
    for state = automaton.non_opaque_states
        if isempty(state)
            break;
        end
        fprintf(fid, '\t"%s" [shape=%s, color=gold1];\n', state{1},SHAPE);
        %         fprintf(fid, '\t"%s" [shape=parallelogram, color=red];\n', state{1});
    end
end
%%%%%%%%%%%%%%%%%%%%%%for dynamical released projection 2021 0130 2:04
if isfield(automaton,'fire_states')
    S = automaton.fire_states(~ismember( automaton.fire_states(1,:),automaton.opaque_states(1,:)));
    for state = S
        fprintf(fid, '\t"%s" [shape=%s];\n', state{1},'box');
    end
    S1 = automaton.fire_states(ismember( automaton.fire_states(1,:),automaton.opaque_states(1,:)));
    for state =  S1
        fprintf(fid, '\t"%s" [shape=%s, color=greenyellow];\n', state{1},'box');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for test if two automaton has the same language% Masopust's paper
if isfield(automaton,'deadlock_states')
    for state = automaton.deadlock_states
        if isempty(state)
            continue;
        end
        fprintf(fid, '\t"%s" [shape=%s, color=blue];\n', state{1},SHAPE);
        %         fprintf(fid, '\t"%s" [shape=parallelogram, color=red];\n', state{1});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for t = automaton.trans'   %?2019年7月9日 20:39:36 '  转置的意思
    fprintf(fid, '\t"%s" -> "%s" [label="%s"];\n', t{1}, t{3}, t{2});
end
%     fprintf(fid, '\tinit [shape=plaintext, label=""];\n');
%
type_element=class(automaton.init);
if strcmp(type_element,'cell')
    if size(automaton.init,2)~=size(automaton.states,2)
        for i=1:size(automaton.init,2)
            fprintf(fid, '\tinit [shape=plaintext, label=""];\n');
            fprintf(fid, '\tinit -> "%s";\n', automaton.init{i});
        end
    end
else
    fprintf(fid, '\tinit [shape=plaintext, label=""];\n');
    fprintf(fid, '\tinit -> "%s";\n', automaton.init);
end
fprintf(fid, '}');
fclose(fid);
end

function SHAPE = Shape_graph(L)
switch L
    case  0
        SHAPE='circle';
    case 1
        SHAPE='parallelogram';
    case 2
        SHAPE = 'box';
    otherwise
        error('Unknown shape for the states. Only  0 circle; 1 parallelogram; 2 box \n');
end
end

function  T = contains(str,c)
T=0;
if  isempty(str)
    return
end
str = str{1};
    for i=1:size(str,2)
        if strcmp(str(i),c)
            T = 1;
            return
        end
    end
end