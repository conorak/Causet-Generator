%===========================================================
% No Holes Program (Classical)
% Date Created: June 28, 2018
% Direct Copy of Holes Script, Transition replaced with code from May 5 No
% Holes Script (and adjusted for readability of variables)
%===========================================================
countlimit=m*10;

%-- Adjacency matrix --
adjMat = zeros(m,m);
%----------------------

%-- Matrix enumerating allowed transitions --
allowed=ones(m,m);
for i=1:m
    allowed(i,i)=0;
end
availCol = [1:m];
availRow = [1:m];
%--------------------------------------------

%--Create initial set--
adjMat(1,2) = 1;
adjMat(2,1) = -1;
allowed(1,2) = 0;
allowed(2,1) = 0;
%----------------------

%--Relation Matrix--
relMat = adjMat;
%-------------------

count=1;
while count<countlimit
    %--Removes saturated points from allowed matrix--
    for i=1:m
        if sum(abs(adjMat(i,:)))>2
            allowed(i,:)=zeros(1,m);
            availRow(i)=0;
        end
        if sum(abs(adjMat(:,i)))>2
            allowed(:,i)=zeros(m,1);
            availCol(i)=0;
        end
    end
    availRow=availRow(availRow~=0);
    availCol=availCol(availCol~=0);
    if length(availRow)<2
        break
    end
    %-----------------------------------------------
    
    %--If there are no more allowed transitions, break--
    if sum(sum(abs(allowed)))<2
        break
    end
    %----------------------------------------------------
    
    %--Distance Matrix--
    distMat = adjMat;
    distMat(distMat~=1)=0;
    distMat = distances(digraph(distMat));
    %-------------------
    
    %--Selects a transition, checks for conditions, then accepts or rejects--
    success=0;
    while success==0
        %--Additional check for finished construction--
        if sum(sum(allowed))<2 || length(availRow)<2 || sum(sum(allowed(availCol,availRow)))==0
            count = countlimit+1;
            break
        end
        %----------------------------------------------
        if count>countlimit
            break
        end
        %--Picks random transition--
        addOne = availRow(randi(length(availRow)));
        addTwo = addOne;
        while addTwo==addOne
            addTwo = availCol(randi(length(availCol)));
        end
        %---------------------------
        
        %--Pick random direction--
        direction=randi([0,1],1);
        %-------------------------
        
        %--Avoids adding extraneous links--
        if abs(distMat(addOne,addTwo))>1 && isinf(distMat(addOne,addTwo))==0 && abs(relMat(addOne,addTwo))==1
            allowed(addOne,addTwo)=0;
            allowed(addTwo,addOne)=0;
            continue
        end
        %----------------------------------
        
        %--Avoids Holes--
        if sum(adjMat(addOne,:))>1
            direction=1;
            free=0;
            allowed(addOne,:) = zeros(1,m);
            if sum(adjMat(:,addTwo))<-1
                allowed(addTwo,:) = zeros(1,m);
                continue
            end
        elseif sum(adjMat(addOne,:))<-1
            direction=0;
            free=0;
            if sum(adjMat(:,addTwo))>1
                allowed(:,addTwo)=zeros(m,1);
                continue
            end
        elseif sum(adjMat(addTwo,:))>1
            direction=0;
            free=0;
            allowed(addTwo,:)=zeros(1,m);
        elseif sum(adjMat(addTwo,:))<-1
            direction=1;
            free=0;
            allowed(:,addTwo)=zeros(m,1);
        else
            direction=randi([0,1],1);
            free=1;
        end
        %--Holes avoided--
        
        %--Avoid Loops--
        if free==1 && relMat(addTwo,addOne)==-1
            direction=1;
        elseif free==1 && relMat(addTwo,addOne)==-1
            direction=0;
        elseif free==0 && direction==1 && relMat(addTwo,addOne)==-1
            allowed(addTwo,addOne)=0;
            continue
        elseif free==0 && direction==0 && relMat(addTwo,addOne)==1
            allowed(addOne,addTwo)=0;
            continue
        end
            %---------------
        success=1;
    end
    
    %--Add links--
    if success==1
        if direction==0
            adjMat(addOne,addTwo) = 1;
            adjMat(addTwo,addOne) = -1;
            relMat(addOne,addTwo) = 1;
            relMat(addTwo,addOne) = -1;
            allowed(addOne,addTwo) = 0;
            allowed(addTwo,addOne) = 0;
        elseif direction==1
            adjMat(addOne,addTwo) = -1;
            adjMat(addTwo,addOne) = 1;
            relMat(addOne,addTwo) = -1;
            relMat(addTwo,addOne) = 1;
            allowed(addOne,addTwo) = 0;
            allowed(addTwo,addOne) = 0;
        end
    end
    %--Links added--
    
    %--Add in transitivity--
    if direction==0
        a = addOne;
        b = addTwo;
    else
        a = addTwo;
        b = addOne;
    end
    for i=1:m
        if relMat(i,a)==1 && relMat(i,b)~=1
            relMat(i,b) = 1;
            relMat(b,i) = -1;
            for j=1:m
                if relMat(b,j)==1 && relMat(i,j)~=1
                    relMat(i,j)=1;
                    relMat(j,i)=-1;
                end
            end
        end
        if relMat(b,i)==1 && relMat(a,i)~=1
            relMat(a,i)=1;
            relMat(i,a) = -1;
        end
    end
    count= count+1;
    if makesMany==0
        count
    end
end
%--Transition complete--

coarseRigidPass=0;
if coarseGrain==1 && SingleSet==1
    rigidTest=numCoarse;
else
    rigidTest=1;
end

for coarseRigid=1:rigidTest
    %--This past coarse-grains the set--
    if coarseRigid~=1
        newlink=adjMat;
        N=m;
        eventsToRemove = round(N*(P(coarseRigid)/100));
        for i=1:eventsToRemove
            adjustEvents=[1:N];
            future=[];
            past=[];
            removeEvent = randi([1 N],1);
            for a=1:N
                if newlink(removeEvent,:)==1
                    future=horzcat(future,a);
                elseif newlink(removeEvent,:)==-1
                    past=horzcat(past,a);
                end
            end
            for aa=1:length(past)
                for bb=1:length(future)
                    newlink(past(aa),future(bb))=1;
                    newlink(future(bb),past(aa))=-1;
                end
            end
            newlink(removeEvent,:)=[];
            newlink(:,removeEvent)=[];
            N=N-1;
        end
        newlinkbin=newlink;
        newlinkbin(newlinkbin~=1)=0;
        relMat=full(adjacency(transclosure(digraph(newlinkbin))));
        %relMat = incidence(digraph(newlinkbin));
        %relMat=full(relMat*relMat');
        adjMat=newlink;
        m=N;
    end
    %--Coarse-graining complete--
    
    %========================================================================
    %================Find height, ratio, volume, length======================
    %========================================================================
    adjBin = adjMat;
    adjBin(adjBin~=1)=0;
    relBin = relMat;
    relBin(relBin~=0)=1;
    L = digraph(adjBin);
    R=digraph(relBin);
    
    %past and future matrices
    future=zeros(m,1);
    past=zeros(m,1);
    for i=1:m
        past(i,1:numel(predecessors(R,i))) = predecessors(R,i);
        future(i,1:numel(successors(R,i))) = successors(R,i);
    end
    %------------------------
    
    %--Distance matrix--
    allowdist = distances(L);
    allowdist(~isfinite(allowdist)==1)=0;
    %-------------------
    
    %--Create list of all pairs--
    allPairs=zeros(sum(sum(relBin)),5);
    i=1;
    for a=1:m
        if sum(future(a,:))~=0
            for b=1:m
                if relBin(a,b)==1
                    vol=numel(intersect(nonzeros(future(a,:)),nonzeros(past(b,:))));
                    r = sum(sum(relBin(nonzeros(future(a,:)),nonzeros(past(b,:)))));
                    relMax = (vol*(vol-1))/2;
                    allPairs(i,1:5) = [a b allowdist(a,b) vol (r/relMax)];
                    if Stats==1 && specialHasse==0
                        if r/relMax<0.6 && vol>15 && vol<30
                            specialHasse=1;
                            hasseForSub=adjBin(intersect(nonzeros(future(a,:)),nonzeros(past(b,:))),intersect(nonzeros(future(a,:)),nonzeros(past(b,:))));
                        end
                    end
                    i=i+1;
                end
            end
        end
    end
    %--------------------------------------
    
    height=max(allPairs(:,3));
    avgLength=mean(allPairs(:,3));
    avgRatio=mean(allPairs(:,5));
    avgVol = mean(allPairs(:,4));
    min_points = sum(indegree(L)==0);
    max_points = sum(outdegree(L)==0);
    ext_points = min_points+max_points;
    r = sum(sum(abs(relBin)));
    total_f=r/rmax;
    
    %--rigidity test--
    if SingleSet==1
        if coarseRigid==1
            heightCoarse=zeros(1,numCoarse);
            fCoarse=zeros(1,numCoarse);
            sampleCoarse=zeros(length(allPairs(:,1)),3,numCoarse);
        end
        subList=allPairs;
        
        %--Condition for sampling subintervals--
        max_vol=max(allPairs(:,4));
        max_vol_min=max_vol-sqrt(max_vol);
        max_vol_max = max_vol+sqrt(max_vol);
        TF1=subList(:,4)<max_vol_min;
        TF2=subList(:,4)>max_vol_max;
        TF3=subList(:,4)==max_vol;
        TF4=subList(:,4)==0;
        %---------------------------------
        
        %--List of all intervals to sample--
        subList((TF3==0 & (TF1==1 | TF2==1) | TF4==1),:)=[];
        %-----------------------------------
        
        %--Stores abundances for sample of intervals--
        curveMean = zeros(max_vol+1,1);
        curveMax= zeros(max_vol+1,1);
        curveMin = zeros(max_vol+1,1);
        curve = zeros(max_vol+1,numel(subList(:,1))); %each column is a sampled interval
        %---------------------------------------------
        for i=1:numel(subList(:,1))
            points=intersect(nonzeros(future(subList(i,1),:)),nonzeros(past(subList(i,2),:)));
            points=vertcat(points, subList(i,1),subList(i,2));
            %--finds only the subinterval pairs
            TFsub1=ismember(allPairs(:,1),points);
            TFsub2=ismember(allPairs(:,2),points);
            TF=TFsub1 & TFsub2;
            %----------------------------------
            %include improper subintervals only
            TFreject1=allPairs(:,1)==subList(i,1);
            TFreject2=allPairs(:,2)==subList(i,2);
            TFrej=TFreject1==1 &TFreject2==1;
            %----------------------------------
            interval=allPairs(TF==1 & TFrej==0,:);
            for ii=1:numel(interval(:,1))
                curve(interval(ii,4)+1,i)=curve(interval(ii,4)+1,i)+1;
            end
        end
        
        for j=1:numel(curve(:,1))
            curveMean(j)=mean(curve(j,:));
            curveMax(j)=max(curve(j,:));
            curveMin(j)=min(curve(j,:));
        end
        
        flat=zeros(max(allPairs(:,4))+1,1);
        for j=1:numel(allPairs(:,4))
            flat(allPairs(j,4)+1)=flat(allPairs(j,4)+1)+1;
        end
        if coarseRigid~=1
            coarseRigidPass=1;
            run('SavingHelper.m');
            coarseRigidPass=0;
        end
    end
end
coarseRigidPass=0;