%==========================================================================
%--Run this program if you have already created sets that you would like to
%coarse-grain and test for locality
%
% Place your matrices in a folder labeled 'SavedMat' in the correct
% subfolders
%==========================================================================

cd SavedMat

for type=1:2
    if type==1
        cd Holes
    else
        cd NoHoles
    end
    link=importdata('translinkmat.dat');
    rel=importdata('transrelmat.dat');
    mkdir Results
    cd Results
    
    linkBin=link;
    linkBin(linkBin~=1)=0;
    relBin=rel;
    relBin(relBin~=1)=0;
    L=digraph(linkBin);
    R=digraph(relBin);
    P=20;
    m=numel(link(:,1));
    N=m;
    %%
    %--Coarse Graining--
    for coarse=1:5
        i=1;
        while i<numnodes(L)
            if randi([1 100],1)<P
                past=predecessors(L,i);
                future=successors(L,i);
                for a=1:length(past)
                    for b=1:length(future)
                        if findedge(L,past(a),future(b))==0
                            L=addedge(L,past(a),future(b),1);
                        end
                    end
                end
                L=rmnode(L,i);
                %----
            else
                i=i+1;
            end
        end
        N = numnodes(L);
        %plot(L,'Layout','layered')
        relBin = full(adjacency(transclosure(L))); 
        linkCoarse=full(adjacency(L));
        R=digraph(relBin);
        linklabel=strcat('linkBin',num2str(coarse),'.dat');
        relLabel=strcat('relBin',num2str(coarse),'.dat');
        save(linklabel,'linkCoarse','-ASCII');
        save(relLabel,'relBin','-ASCII');
        %--Coarse-Graining complete--
        
        %%
        %-- Locality (Rigidity Tests) --
        distMat = distances(L);
        distMat(isfinite(distMat)==0)=0;
        
        %--Create Past and Future matrices--
        future=zeros(N,N);
        past=zeros(N,N);
        for a=1:N
            past(a,1:length(predecessors(R,a))) = predecessors(R,a);
            future(a,1:length(successors(R,a))) = successors(R,a);
        end
        %---------------------------------
        
        %--Create list of all pairs--
        allPairs=zeros(5, numedges(R));
        pair=1;
        for a=1:N
            if sum(future(a,:))~=0
                for b=1:N
                    if relBin(a,b)==1 && distMat(a,b)>1
                        points = intersect(nonzeros(future(a,:)),nonzeros(past(b,:)));
                        pointsGreater = vertcat(points,[a b]');
                        vol = numel(points)+2;
                        numRelations = sum(sum(relBin(pointsGreater,pointsGreater)));
                        rmax = (vol*(vol-1))/2;
                        ratio = numRelations/rmax;
                        allPairs(1:5,pair) = [a b distMat(a,b) vol-2 ratio]';
                        pair=pair+1;
                    end
                end
            end
        end
        sample = allPairs([3:5],1:length(allPairs(1,:)));
        sampleLabel=strcat('sample',num2str(coarse),'.dat');
        save(sampleLabel,'sample','-ASCII');
        
        %%Strong d-rigidity
        flat=zeros(max(allPairs(4,:)),1);
        for i=1:max(allPairs(4,:));
            flat(i) = numel(nonzeros(allPairs(4,:)==i));
        end
        flatLabel = strcat('flat',num2str(coarse),'.dat');
        save(flatLabel,'flat','-ASCII');
       
        
        %%Weak d-rigidity
        subList=allPairs;
        
        %--Condition for sampling subintervals--
        maxVol=max(allPairs(4,:));
        max_vol_min=maxVol-sqrt(maxVol);
        max_vol_max = maxVol+sqrt(maxVol);
        TF1=subList(4,:)<max_vol_min;
        TF2=subList(4,:)>max_vol_max;
        TF3=subList(4,:)==maxVol;
        TF4=subList(4,:)==0;
        %---------------------------------
        
        %--List of all intervals to sample--
        subList(:,(TF3==0 & (TF1==1 | TF2==1) | TF4==1))=[];
        %-----------------------------------
        
        %--Stores abundances for sample of intervals--
        curveMean = zeros(3,maxVol); %row 1: mean, row 2: min, row 3: max
        curve = zeros(numel(subList(1,:)),maxVol); %each row is a sampled interval
        %---------------------------------------------
        for i=1:numel(subList(1,:))
            points = intersect(nonzeros(future(subList(1,i),:)),nonzeros(past(subList(2,i),:)));
            pointsGreater = vertcat(points,[subList(1,i) subList(2,i)]');
    
            %--finds only the subinterval pairs
            TFsub1=ismember(allPairs(1,:),points);
            TFsub2=ismember(allPairs(2,:),points);
            TF=TFsub1 & TFsub2;
            %----------------------------------
            %include improper subintervals only
            TFreject1=allPairs(1,:)==subList(1,i);
            TFreject2=allPairs(2,:)==subList(2,i);
            TFrej=TFreject1==1 &TFreject2==1;
            %----------------------------------
            interval=allPairs(:,TF==1 & TFrej==0); %this the sub-subintervals
            
            for ii=1:max(interval(4,:))
                curve(i,ii)=numel(nonzeros(interval(4,:)==ii));
            end
            for k=1:length(curve(i,:))
                curveMean(1,k)=mean(curve(:,k));
                curveMean(2,k)=min(curve(:,k));
                curveMean(3,k)=max(curve(:,k));
            end
        end
            curveLabel=strcat('curve',num2str(coarse),'.dat');
            save(curveLabel,'curveMean','-ASCII');
    end
    cd ../../
end