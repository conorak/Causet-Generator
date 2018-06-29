%-----------------------------------------------------------------------
% Complete Classical Program
% Date Created: June 28, 2018
% Constituent Parts:
% Autorun Program from April 5
%
%
%
%-----------------------------------------------------------------------

%======================================================================
%================== User-Defined Customization ========================
%======================================================================
%--Previous defined values--
% Comment out the next line if you do not have the dim_mat.dat file
%dim_mat = importdata('dim_mat.dat');

%--Specify what type of causet to create--
makeHoles = 1; %Set to 0 to disable Holes Poset
makeNoHoles = 1; %Set to 0 to disable No Holes Poset

%--Specify number of causets to make--
makesMany=1; %Set to 0 to create only one causet
trials = 50; %Input the number of causets to make; only works if makesMany=1

%--Select the cardinality of the posets--
smallSets=1800; %If you make many posets, they will all contain this number of points; only works if makesMany=1
bigSets=5000; %The larger poset will contain this number of points

%--Select whether or not to coarse-grain (NB: Only supported for one poset at a time)
coarseGrain = 1; %Set to 0 to disable coarse-graining
numCoarse = 5; %Enter the number of times you want to coarse-grain
coarseParam = 20; %Enter the number of events to remove for each coarse-graining

%--Select whether or not to use the action principle
useAction = 0; %set to 0 to disable coarse-graining
beta = [0.2 0.4 0.6 0.8 1 1.2 1.4]; %select thermalization temperature(s)
%NB: selecting useAction=1 disables no holes, and makesMany

%--Select whether or not to make graphics (NB: UNSTABLE! WILL NOT WORK!)
makeGraphics=0;
%--At time of writing, all graphs will need to be manually edited and saved

%======================================================================

if useAction==1
    makesMany=0;
    makeNoHoles=0;
end

saveSetup=1;
run('SavingHelper.m');
saveSetup=0;

%--Constant values (Persistent)--
if exist('dim_mat')==0
    dim_mat = [1 1; 0.5 2]; %Saves ordering fraction vs dimension
end
Z_score=1.96;
moe=0.05;
if makesMany==1
    timesToRunTrials=2;
else
    timesToRunTrials=1;
end
if makeHoles==1 && makeNoHoles==1
    timesToRunType=2;
else
    timesToRunType=1;
end
%--------------------------------

%--Initialize coarse-graining parameters--
if coarseGrain == 1
    P=zeros(1,numCoarse+1);
    for i=1:numCoarse
        P(i)=coarseParam;
    end
end
%----------------------------------------

%===========Run Holes Program============
for HNH=1:timesToRunType %run twice if creating holes and no holes
    clearvars -except useAction makeGraphics P newFolder coarseGrain saveSetup HNH SNS timesToRunTrials timesToRunType dim_mat n makeHoles makeNoHoles makesMany trials smallSets bigSets coarseGrain numCoarse coarseParam moe Z_score
    myrheim=0;
    ratio=0;
    for SNS=1:timesToRunTrials %run twice if creating trials
        if timesToRunTrials==1 || (timesToRunTrials==2 && SNS==2)
            m=bigSets;
            rmax = (m*(m-1))/2;
        else
            m=smallSets;
            rmax=(m*(m-1))/2;
        end
        %--This part deals with holes--
        if (timesToRunType==1 && makeHoles==1) || (timesToRunType==2 && HNH==1)
            HolesPass=1;
            NoHolesPass=0;
            if timesToRunTrials==1 || (timesToRunTrials==2 && SNS==2) %single set
                mess= 'Creating a Single Holes Set'
                SingleSet=1;
                Stats=0;
                run('Holes.m')
                run('SavingHelper.m')
            else %multiple trials
                mess= 'Creating Multiple Holes Set'
                SingleSet=0;
                Stats=1;
                specialHasse=0;
                heightTrials=zeros(1,trials);
                volTrials=zeros(1,trials);
                avgratioTrials=zeros(1,trials);
                extTrials=zeros(1,trials);
                totalFTrials=zeros(1,trials);
                for smallTimes=1:trials
                    smallTimes
                    run('Holes.m')
                    run('SavingHelper.m')
                    cd ../../../
                    %save all relevant stuff here
                end
                specialHasse=0;
            end
        %--Otherwise, deal with no holes--
        else
            HolesPass=0;
            NoHolesPass=1;
            if timesToRunTrials==1 || (timesToRunTrials==2 && SNS==2) %single set
                mess= 'Creating a Single No Holes Set'
                SingleSet=1;
                Stats=0;
                run('NoHoles.m')
                run('SavingHelper.m')
            else %multiple trials
                mess= 'Creating a Multiple No Holes Sets'
                SingleSet=0;
                Stats=1;
                specialHasse=0;
                heightTrials=zeros(1,trials);
                volTrials=zeros(1,trials);
                avgratioTrials=zeros(1,trials);
                extTrials=zeros(1,trials);
                totalFTrials=zeros(1,trials);
                for smallTimes=1:trials
                    smallTimes
                    run('NoHoles.m')
                    run('SavingHelper.m')
                    cd ../../../
                    %save all relevant stuff here
                end
                specialHasse=0;
            end
        end
    end
end

if makeGraphics==1
   run('GraphicsHelper.m'); 
end
