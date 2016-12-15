%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Enter Videos Numbers to be compared
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';                    %PATH TO BE CHANGED
InputPath = fullfile(InputDir,'in_file.chst');             

Input = fileread(InputPath);                 
AllVector = strsplit(Input,'\n');
AllVector = AllVector';
lenVectorCount = size(AllVector)-1;
InputMatrix = zeros(lenVectorCount(1),1);
lenEachVector = 0;
for eachvector = 1:lenVectorCount(1)
    eachVectorList = strsplit(char(AllVector(eachvector)),',');
    lenEachVector = size(eachVectorList);
    for matrix = 1:lenEachVector(2)
        value = eachVectorList{matrix};
        InputMatrix(eachvector,matrix) = str2double(value);
    end
end

InputMatrixSize = size(InputMatrix);
countV1 = 0;startV1 = 0;countV2 = 0;startV2 = 0;
for Vector = 1:InputMatrixSize(1)
    if (InputMatrix(Vector,1) == str2double(Video1))
        if(startV1 == 0)
            startV1 = Vector;
        end    
        countV1 = countV1 + 1;
    end
    if (InputMatrix(Vector,1) == str2double(Video2))
        if(startV2 == 0)
            startV2 = Vector;
        end
        countV2 = countV2 + 1;
    end 
end   

Matrix1 = InputMatrix(startV1:(startV1+countV1-1),1:end);
Matrix2 = InputMatrix(startV2:(startV2+countV2-1),1:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CovarianceMatrix = cov(InputMatrix(1:end,4:end));
InvCovarianceMatrix = pinv(CovarianceMatrix);
binlength = size(CovarianceMatrix);
TotalFrameV1 = Matrix1(countV1,2);
TotalFrameV2 = Matrix2(countV2,2);
flag = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (TotalFrameV1 == TotalFrameV2)
    disp('Both videos have equal number of frames');
else
    if (TotalFrameV1 >= TotalFrameV2)
        flag = 1;
    else
        disp('Video 2 has more frames than Video 1, comparison made w.r.t to Video1');
        flag = 2;
    end
end
switch(flag)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing Histogram Similarity in Progress');
        totalDist = 0;
        for vector = 1:countV1
                vectorV1 = Matrix1(vector,4:end);
                vectorV2 = Matrix2(vector,4:end);
                vectorVmain = zeros(1,binlength(1));
                for iter = 1:binlength(1)
                    vectorVmain(1,iter) = abs(vectorV1(1,iter)) - abs(vectorV2(1,iter));
                end
                vectorVmainT = vectorVmain';
                MahaDist = sqrt(vectorVmain * InvCovarianceMatrix * vectorVmainT);
                totalDist = totalDist + MahaDist;
        end
        result = ['Color Histogram Similarity between ',Video1,' and ',Video2,' using Mahanalobis Distance = ',num2str(totalDist/countV1)];
        disp(result);
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        disp('Video 1 has more frames than Video 2, comparison made w.r.t to Video2');
        ExtraFrames = TotalFrameV1 - TotalFrameV2;
        BestDist = 99999;BestVect = 0;tot_sim = 0;
        vect = 1;
        while (vect < (ExtraFrames*(countV1/TotalFrameV1)))
            vectorV1 = Matrix1(vect,4:end);
            vectorV2 = Matrix2(1,4:end);
            len=size(vectorV1);
                sim=0;max=-1;
                for it=1:len(2)
                    val=abs(vectorV1(it)-vectorV2(it));
                    if max<val
                        max=val;
                    end
                end
                tot_sim=tot_sim+max;
            if (BestDist > tot_sim)
                BestDist = tot_sim;
                BestVect = vect;
            end
            vect = vect + 4;
        end
        totalDist = 0;
        for vector = 1:countV2
                vectorV1 = Matrix1((vector + BestVect - 1),4:end);
                vectorV2 = Matrix2(vector,4:end);
                vectorVmain = zeros(1,binlength(1));
                for iter = 1:binlength(1)
                    vectorVmain(1,iter) = abs(vectorV1(1,iter)) - abs(vectorV2(1,iter));
                end
                vectorVmainT = vectorVmain';
                MahaDist = sqrt(vectorVmain * InvCovarianceMatrix * vectorVmainT);
                totalDist = totalDist + MahaDist;
        end
        result = ['Color Histogram Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' using Mahanalobis Distance = ',num2str(totalDist/countV2)];
        disp(result);
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        disp('Video 2 has more frames than Video 1, comparison made w.r.t to Video1');
        ExtraFrames = TotalFrameV2 - TotalFrameV1;
        BestDist = 99999;BestVect = 0;tot_sim = 0;
        vect = 1;
        while (vect < (ExtraFrames*(countV2/TotalFrameV2)))
            vectorV1 = Matrix1(1,4:end);
            vectorV2 = Matrix2(vect,4:end);
            len=size(vectorV1);
            sim=0;max=-1;
            for it=1:len(2)
                val=abs(vectorV1(it)-vectorV2(it));
               if max<val
                   max=val;
               end
            end
            tot_sim = tot_sim + max;
            if (BestDist > tot_sim)
                BestDist = tot_sim;
                BestVect = vect;
            end
            vect = vect + 4;
        end
        totalDist = 0;
        for vector = 1:countV1
                vectorV1 = Matrix1(vector,4:end);
                vectorV2 = Matrix2((vector + BestVect - 1),4:end);
                vectorVmain = zeros(1,binlength(1));
                for iter = 1:binlength(1)
                    vectorVmain(1,iter) = abs(vectorV1(1,iter)) - abs(vectorV2(1,iter));
                end
                vectorVmainT = vectorVmain';
                MahaDist = sqrt(vectorVmain * InvCovarianceMatrix * vectorVmainT);
                totalDist = totalDist + MahaDist;
        end
        result = ['Color Histogram Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' using Mahanalobis Distance = ',num2str(totalDist/countV1)];
        disp(result);    
end


