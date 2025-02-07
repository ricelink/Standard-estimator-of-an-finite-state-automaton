function Theta_estimator = estimator2(G,Typehere)
%standard_observer
% full observer

if strcmp(Typehere,'standard_observer')
    X = G.states;
    E = G.events;
    Eo = G.observable_events;
    Euo = setdiff(E,Eo);
    Xs = G.opaque_states;
    Xns = setdiff(X,Xs);
    trans = G.trans;

    init = G.init;
    init_ur = UR(init, trans, Euo);
    if isempty(init)
        new_init = cell(2,0);
    else
        new_init =  [{STRCELL2(init_ur)};{init_ur}];%cell(2,1)
    end
    new_states = new_init      ;
    step_states = new_states;
    new_trans = cell(0,6) ;
    while 1
        cre_states = cell(2,0) ;
        for i = 1:size(step_states,2)
            Ex = step_states(:,i)  ;
            Ex_bottom = Ex{2}  ;
            x_obs = Ex_bottom ;

            for ie = 1:size(Eo,2)
                eo = Eo(1,ie);
                x_obs_dot = UR(Nexte(x_obs, trans, eo),trans, Euo)  ;
                if isempty(x_obs_dot)
                    continue
                end

                Ex_dot = [ {STRCELL2(x_obs_dot)} ;
                    {x_obs_dot}  ]   ;
                cre_states(:,end+1) = Ex_dot;
                new_trans(end+1,:) = [ Ex(1),eo,Ex_dot(1)  ,{Ex},eo,{Ex_dot}];
            end

        end
        [~,idx] = unique( cre_states(1,:));
        cre_states = cre_states(:,idx)  ;
        step_states = cre_states (:,~ismember(cre_states(1,:),new_states(1,:) )) ;
        if isempty(step_states)
            break
        end
        new_states = [new_states,step_states ];
    end
    Eestimator.states2 = new_states ;
    Eestimator.states = new_states (1,:) ;
    Eestimator.trans2 = new_trans ;
    Eestimator.trans = new_trans(:,[1:3])  ;
    Eestimator.observable_events = G.observable_events;
    Eestimator.events= Eestimator.observable_events;
    Eestimator.opaque_states = cell(1,0) ;
    Eestimator.opaque_states2 = cell(2,0) ;
    for i =1:size(new_states,2)
        state = new_states{2,i};
        if isempty(setdiff(state,Xs))
            Eestimator.opaque_states(:,end+1) = new_states(1,i);
            Eestimator.opaque_states2(:,end+1) = new_states(:,i);
        end
    end

    Eestimator.init2 = new_init;
    Eestimator.init = new_init(1,:);
    Theta_estimator = Eestimator;
end


if strcmp(Typehere,'full_observer')
    %function full_observer()
    NG = G;
    if isempty(NG.trans)
        epsilon= NG;
        return;
    end
    if isempty( NG.opaque_states)
        NG.opaque_states = cell(1,0);
    end
    if ~isfield(NG,'non_opaque_states')
        NG.non_opaque_states = NG.states(:,~ismember(  NG.states(1,:) ,  NG.opaque_states(1,:)));
    end
    G=accessible_automaton_multi(NG);
    if isempty(G.observable_events)
        G.observable_events=unique([G.trans(:,2)]');
    end

    ob_events = G.observable_events(:,ismember(G.observable_events(1,:),G.events));
    un_events = G.events(:,~ismember(G.events(1,:),ob_events));
    Xs = G.opaque_states;
    X = G.states;
    n = size(X,2);
    power_n =2^n ;
    powerX = cell(2,0);
    for i=1:power_n-1
        biM=logical(de2bi(i,n))   ;
        Xsubset = X(1,biM);
        URinit = UR(Xsubset,G.trans,un_events);
        powerX(:,end+1) =   [Str(URinit);{URinit}];
    end
    [~,idx] = unique(powerX(1,:));
    new_X = powerX(:,idx);
    new_trans = cell(0,6);
    for i =1:size(new_X,2)
        % i
        x = new_X(:,i);
        for j =1:size(ob_events,2)
            e= ob_events(j);
            Qdset=Nexte(x{2,1}, G.trans, e);
            Qstep = UR(   Qdset,  G.trans, un_events  );
            if ~isempty(Qstep)
                new_trans(end+1,:) = [ x(1,1)  , e, Str(Qstep),  x(2,1), e, {Qstep} ]    ;
            end
        end
    end


    epsilon.events = G.observable_events;
    epsilon.observable_events = G.observable_events;
    epsilon.trans = new_trans(:,[1,2,3]);
    epsilon.trans2 = new_trans;
    epsilon.states=new_X(1,:);


    epsilon.states2=new_X;
    epsilon.init = epsilon.states;


    epsilon.opaque_states = cell(1,0);
    Theta_estimator = epsilon;
end




end

