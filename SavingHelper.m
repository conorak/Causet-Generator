didMyJob=0;
while didMyJob==0
    if saveSetup==1
        current=pwd;
        newFolder=strcat('Results_',date);
        mkdir(newFolder);
        cd(newFolder);
        if useAction==1
            mkdir Action
        else
            mkdir Holes
            mkdir NoHoles
            mkdir Graphics
            cd Holes
            mkdir Coarse_Graining
            mkdir Single
            mkdir Statistical
            cd ../NoHoles
            mkdir Coarse_Graining
            mkdir Single
            mkdir Statistical
        end
        cd(current)
        didMyJob=1;
        break
    end
    
    if coarseRigidPass==1
        cd(newFolder)
        if HolesPass==1
            cd Holes/Coarse_Graining
        else
            cd NoHoles/Coarse_Graining
        end
        labelAdj = strcat('Adj_Coarse_',num2str(coarseRigid-1),'.dat');
        labelMean = strcat('CurveMean_',num2str(coarseRigid-1),'.dat');
        labelMin = strcat('CurveMin_',num2str(coarseRigid-1),'.dat');
        labelMax = strcat('CurveMax_',num2str(coarseRigid-1),'.dat');
        labelFlat = strcat('Flat_',num2str(coarseRigid-1),'.dat');
        save(labelMean,'curveMean','-ASCII');
        save(labelMin,'curveMin','-ASCII');
        save(labelMax,'curveMax','-ASCII');
        save(labelFlat,'flat','-ASCII');
        save(labelAdj,'adjMat','-ASCII');
        heightCoarse(coarseRigid-1) = height;
        fCoarse(coarseRigid-1) = total_f;
        sampleCoarse(1:length(allPairs(:,1)),:,coarseRigid-1) = allPairs(:,[5 3 4]);
        if coarseRigid==rigidTest
            save('total_f.dat','fCoarse','-ASCII');
            save('height.dat','heightCoarse','-ASCII');
        end
        cd ../../../
        didMyJob=1;
        break
    end
    
    if SingleSet==1
        cd(newFolder)
        if HolesPass==1
            cd Holes
        else
            cd NoHoles
        end
        cd Single
        save('total_f.dat','total_f','-ASCII');
        save('extremal.dat','ext_points','-ASCII');
        save('avglength.dat','avgLength','-ASCII');
        save('height.dat','height','-ASCII');
        save('avgvol.dat','avgVol','-ASCII');
        save('adjmat.dat','adjMat','-ASCII');
        save('relmat.dat','relMat','-ASCII');
        save('avgratio.dat','avgRatio','-ASCII');
        Sample = zeros(3,length(allPairs(:,1)));
        Sample(1,1:length(allPairs(:,1))) = allPairs(:,5);
        Sample(2,1:length(allPairs(:,1))) = allPairs(:,3);
        Sample(3,1:length(allPairs(:,1))) = allPairs(:,4);
        text = 'Sample rows: Ratio(1), Length(2), Volume(3)';
        save('ReadMe.dat','text','-ASCII');
        save('sample.dat','Sample','-ASCII');
        cd ../../../
        didMyJob=1;
        break
    end
    
    if Stats==1
        cd(newFolder)
        if HolesPass==1
            cd Holes
        else
            cd NoHoles
        end
        cd Statistical
        heightTrials(smallTimes) = height;
        volTrials(smallTimes) = avgVol;
        avgratioTrials(smallTimes) = avgRatio;
        extTrials(smallTimes) = ext_points;
        totalFTrials(smallTimes)=total_f;
        if specialHasse==1
            sample = allPairs(:,[3 4 5]);
            save('sample.dat','sample','-ASCII');
            save('specialHasse.dat','hasseForSub','-ASCII');
            specialHasse=0;
        end
        if smallTimes==trials
            save('height.dat','heightTrials','-ASCII');
            save('avgvolume.dat','volTrials','-ASCII');
            save('avgratio.dat','avgratioTrials','-ASCII');
            save('extremal.dat','extTrials','-ASCII');
            save('total_f.dat','totalFTrials','-ASCII');
        end
        didMyJob = 1;
        break
    end
end