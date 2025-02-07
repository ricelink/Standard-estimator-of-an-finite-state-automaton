function Q = UR(X, trans, un_events,Xs,K,STR_)
%UR 
if nargin == 3% X = {'2','3','4'}
un_trans = trans(ismember(trans(:,2), un_events),:);
Q = X(1,:);
Qstep = X(1,:);
while 1 
    Rstates = un_trans(ismember(un_trans(:,1), Qstep),3)';
    Qstep = setdiff(Rstates,Q);
    Q = [Q,Qstep];
    if isempty(Qstep)
        break
    end
end
Q = sort(Q);
end

if nargin == 5 %strong, Ma, 
    % X = {'2','3','4';'1','4','4'; '2,1','3,4','4,4' }
    %K=3 
    %trans = {'1','u','3';'3','u','4';'1','u','2';'2','u','3';'2','u','4';'3','u','6';'6','u','7'}
    %Xs = {'3','7'} 
    %un_events={'u'}
   %X = cell(3,*)
    
    Kstraddone = num2str(K+1);
    un_trans = trans(ismember(trans(:,2), un_events),:);
    Xns_un_trans_left = trans(~ismember(trans(:,1),Xs),:); %Xs = {'3'}, '4','u','3'; is kept  '3','u','2' is kept
    
    Qwant = cell(3,0);
    for  i =1:size(X,2)%%%
        state = X(:,i);
        k = state(2);
        RQ = UR(state(1),Xns_un_trans_left, un_events);
        RQXns = setdiff(RQ,Xs);
        RQXs = setdiff(RQ,RQXns);
        if ~isempty(RQXns)
            for j = 1:size(RQXns,2)
                Qwant(:,end+1) = [RQXns(j);k;{  [RQXns{j},',',k{1}]  }];
            end
        end
        
        if ~isempty(RQXs)
            RQt = UR(RQXs,trans,un_events);
            for j=1:size(RQt,2)
                Qwant(:,end+1) = [RQt(j);Kstraddone;{ [  RQt{j},',',Kstraddone] }];
            end
        end
        
    end
     [~,idx] = sort(Qwant(3,:));%202209240016
    Qwant=Qwant(:,idx);%202209240016
    Q = [X,Qwant];
    [~,idx] = unique(Q(3,:));
    Q1 = Q(:,idx);
    Q = Q1;
    
end
%% not useable
%if nargin == 6 % ||strcmp(STR_, 'weak-k-step-liu')%weak, liu 
%     % X = {'2','3','4';'1','4','4'; '2,1','3,4','4,4' }
%     %K=3 
%     %trans = {'1','u','3';'3','u','4';'1','u','2';'2','u','3';'2','u','4';'3','u','6';'6','u','7'}
%     %Xs = {'3','7'} 
%     %un_events={'u'}
%    %X = cell(4,*)
%     
%     Kstraddone = num2str(K+1);
%     un_trans = trans(ismember(trans(:,2), un_events),:);
%     Xns_un_trans_left = trans(~ismember(trans(:,1),Xs),:); %Xs = {'3'}, '4','u','3'; is kept  '3','u','2' is kept
%     
%     Qwant = cell(4,0);
%     for  i =1:size(X,2)%%%
%         state = X(:,i);
%         k = state(2);
%         RQ = UR(state(1),un_trans, un_events);%liu 20221001 2339
%         RQXns = setdiff(RQ,Xs);
%         RQXs = setdiff(RQ,RQXns);
%         if ~isempty(RQXns)
%              state4th = state{4};
%             k=state4th{2,1};
%             k = str2num(k);
%             kwant = max(0,k-1);
%             kwantstr = num2str(kwant);
%             for j = 1:size(RQXns,2)
%                 Qwant(:,end+1) = [RQXns(j);kwantstr;{  [RQXns{j},',',kwantstr]  };state(4)];
%             end
%         end
%         
%         if ~isempty(RQXs)
%             RQt = RQXs;%20221001 2343
%             for j=1:size(RQt,2)
%                 Qwant(:,end+1) = [RQt(j);Kstraddone;{ [  RQt{j},',',Kstraddone] };state(4)];
%             end
%         end
%         
%     end
%      [~,idx] = sort(Qwant(3,:));%202209240016
%     Qwant=Qwant(:,idx);%202209240016
%     Q = [X,Qwant];
%     [~,idx] = unique(Q(3,:));
%     Q1 = Q(:,idx);
%     Q = Q1([1,2,3],:);
%     
% end
end

