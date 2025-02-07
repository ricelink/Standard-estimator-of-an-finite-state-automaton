function Q = Nexte(X, trans, e, Xs, K, STR_)
%NEXTE  
if nargin == 3
X_trans = trans(ismember(trans(:,1),X),:);
Q = X_trans(ismember(X_trans(:,2), e), 3 )';
if ~isempty(Q)
    Q = unique(Q);
end
end

if nargin == 5 % strong K-step opacity 
    % X = {'2','3','4';'2','4','4'; '2,2','3,4','4,4' }
    %K=3 
    %trans = {'1','a','3'; '1','a','2';  '2','u','3';  '2','a','4';   '3','u','4';  '3','u','6';   '4','a','8';  '6','a','7'}
    %Xs = {'3','7'} 
    %e = {'a'}
    Kstraddone = num2str(K+1);
    
    Qwant = cell(3,0);
    for  i =1:size(X,2)
        state = X(:,i);
        k = state{2};
        k = str2num(k);
        kwant = max(0,k-1);
        kwantstr = num2str(kwant);
        state_trans = trans(ismember(trans(:,1),state(1,1)),:);
        Qtemp = state_trans(ismember(state_trans(:,2), e), 3 )';%20220924 0004
        QXns = setdiff(Qtemp,Xs);
        QXs = setdiff(Qtemp,QXns);
        if ~isempty(QXns)
            for j = 1:size(QXns,2)
                Qwant(:,end+1) = [QXns(j);kwantstr;{  [QXns{j},',',kwantstr]  }];
            end
        end
        if ~isempty(QXs)
            for j = 1:size(QXs,2)
                Qwant(:,end+1) = [QXs(j);Kstraddone;{  [QXs{j},',',Kstraddone]  }];
            end
        end
    end
    Q = [Qwant];
    [~,idx] = unique(Q(3,:));
    Q1 = Q(:,idx);
    Q = Q1;
end

if nargin == 6 % strong K-step opacity, revised based on ma
    % X = {'2','3','4';'2','4','4'; '2,2','3,4','4,4' }
    %K=3 
    %trans = {'1','a','3'; '1','a','2';  '2','u','3';  '2','a','4';   '3','u','4';  '3','u','6';   '4','a','8';  '6','a','7'}
    %Xs = {'3','7'} 
    %e = {'a'}
    Kstraddone = num2str(K+1);
    
    Qwant = cell(3,0);
    for  i =1:size(X,2)
        state = X(:,i);
        k = state{2};
        k = str2num(k);
        kwant = max(0,k-1);
        kwantstr = num2str(kwant);
        state_trans = trans(ismember(trans(:,1),state(1,1)),:);
        Qtemp = state_trans(ismember(state_trans(:,2), e), 3 )';%20220924 0004
        QXns = setdiff(Qtemp,Xs);
        QXs = setdiff(Qtemp,QXns);
        if ~isempty(Qtemp)
            for j = 1:size(Qtemp,2)
                Qwant(:,end+1) = [Qtemp(j);kwantstr;{  [Qtemp{j},',',kwantstr]  }];
            end
        end
        if ~isempty(QXs)
            for j = 1:size(QXs,2)
                Qwant(:,end+1) = [QXs(j);Kstraddone;{  [QXs{j},',',Kstraddone]  }];
            end
        end
    end
    Q = [Qwant];
    [~,idx] = unique(Q(3,:));
    Q1 = Q(:,idx);
    Q = Q1;
end

%%not useable
% % not useableif nargin == 6 %&& strcmp(STR_,'weak-K-step')  % strong K-step opacity 
%     % X = {'2','3','4';'2','4','4'; '2,2','3,4','4,4' }
%     %K=3 
%     %trans = {'1','a','3'; '1','a','2';  '2','u','3';  '2','a','4';   '3','u','4';  '3','u','6';   '4','a','8';  '6','a','7'}
%     %Xs = {'3','7'} 
%     %e = {'a'}
%     Kstraddone = num2str(K+1);
%     
%     Qwant = cell(4,0);% 20221001 need to remember the parent state
%     for  i =1:size(X,2)
%         state = X(:,i);
%         k = state{2};
%         k = str2num(k);
%         kwant = max(0,k-1);
%         kwantstr = num2str(kwant);
%          
%         QXns = setdiff(Qtemp,Xs);
%         QXs = setdiff(Qtemp,QXns);
%         if ~isempty(QXns)
%             for j = 1:size(QXns,2)
%                 Qwant(:,end+1) = [QXns(j);kwantstr;{  [QXns{j},',',kwantstr]  };{state}];
%             end
%         end
%         if ~isempty(QXs)
%             for j = 1:size(QXs,2)
%                 Qwant(:,end+1) = [QXs(j);Kstraddone;{  [QXs{j},',',Kstraddone]  }; {state}];
%             end
%         end
%     end
%     Q = [Qwant];
%     [~,idx] = unique(Q(3,:));
%     Q1 = Q(:,idx);
%     Q = Q1;
% end

end

