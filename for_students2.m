G=create_non_automaton_multi_ini(...
            {'0','a','2';'0','u','1';'0','c','5';
            '1','a','3'; '1','b','5';
            '2','b','1';'2','u','4';
            '3','c','2';'3','b','3';   
             '4','a','3';
            },...
            {'0'},... %initial state
            {'1','6'},... %opaque
            {'a','b','c',}...%observable events
            );

Estimator = estimator2(G,'standard_observer')
% fig_automaton(G,['Estimator'],2)