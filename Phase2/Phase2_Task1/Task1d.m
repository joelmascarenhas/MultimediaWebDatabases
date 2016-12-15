%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';
InputPath = fullfile(InputDir,'in_file.sift');             

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
countV1 = 0;
startV1 = 0;
countV2 = 0;
startV2 = 0;
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
%%%1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalFrameV1 = Matrix1(countV1,2);
TotalFrameV2 = Matrix2(countV2,2);

SIFT1=InputMatrix(startV1:(startV1+countV1-1),2:end);
SIFT2=InputMatrix(startV2:(startV2+countV2-1),2:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 1                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[v1,v11,idx1]=unique(SIFT1(:,1:2),'rows');
nu1=size(v1);
SIFT1_sum=zeros(nu1(1),size(SIFT1,2));
for i1=1:nu1(1)
    SIFT1_sum(i1,1)=v1(i1,1);
    SIFT1_sum(i1,2)=v1(i1,2);
    SIFT1_sum(i1,3:size(SIFT1,2)) = mean(SIFT1(idx1==i1,3:size(SIFT1,2)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 2                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[v2,v22,idx2]=unique(SIFT2(:,1:2),'rows');
nu2=size(v2);
SIFT2_sum=zeros(nu2(1),size(SIFT2,2));
for i2=1:nu2(1)
    SIFT2_sum(i2,1)=v2(i2,1);
    SIFT2_sum(i2,2)=v2(i2,2);
    SIFT2_sum(i2,3:size(SIFT2,2)) = mean(SIFT2(idx2==i2,3:size(SIFT2,2)));
end

countn1 = size(SIFT1_sum);
countn2 = size(SIFT2_sum);
if (countn1(1)>countn2(1))
    SIFT2_sum=[SIFT2_sum ; zeros(countn1(1)-countn2(1),134)];
end
if (countn1(1)<countn2(1))
    SIFT1_sum=[SIFT1_sum ; zeros(countn2(1)-countn1(1),134)];
end
Counts = abs(countn1(1)-countn2(1));
if ( Counts == 0 )
    Counts = TotalFrameV2*4;
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag = 0;
if (TotalFrameV1 == TotalFrameV2)
    disp('Both videos have equal number of frames');
else
    if (TotalFrameV1 >= TotalFrameV2)
        disp('Video1 had more frames');
        flag = 1;
    else
        disp('Video2 had more frames');
        flag = 2;
    end
end

switch(flag)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing SIFT Similarity in Progress');
        totalDist = 0;
        for vector = 1:Counts
           vectorV1 = SIFT1_sum(vector,3:end);
           vectorV2 = SIFT2_sum(vector,3:end);
           Dist=norm(vectorV1-vectorV2,Inf);
           totalDist = totalDist+Dist;
        end
        result = ['SIFT Similarity between ',Video1,' and ',Video2,' is = ',num2str(totalDist/countV1)];
        disp(result);
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        disp('Video 1 has more vectors than Video 2, comparison made w.r.t to Video2');
        ExtraFrames = TotalFrameV1 - TotalFrameV2;
        BestDist = 99999;BestVect = 0;
        vect = 1;
        while (vect < ExtraFrames)
            vectorV1 = SIFT1_sum(vect,3:end);
            vectorV2 = SIFT2_sum(1,3:end);
            Dist=vectorV1-vectorV2;
             if (BestDist > Dist)
                    BestDist = Dist;
                    BestVect = vect;
            end
            vect = vect + 1;
        end
        vector=1;
        totalDist=0;
        while (vector < ExtraFrames)
             vectorV1 = SIFT1_sum((vector + BestVect - 1),3:end);
             vectorV2 = SIFT2_sum(vector,3:end);
             Dist = norm(vectorV1-vectorV2,Inf);
             totalDist = totalDist + Dist;
             vector=vector+1;
        end
       
        result = ['SIFT Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is = ',num2str(totalDist/countV2)];
        disp(result);
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        disp('Video 2 has more vectors than Video 1, comparison made w.r.t to Video2');
        ExtraFrames = TotalFrameV2 - TotalFrameV1;
        BestDist = 99999;BestVect = 0;
        vect = 1;
        while (vect < ExtraFrames)
            vectorV1 = SIFT1_sum(vect,3:end);
            vectorV2 = SIFT2_sum(1,3:end);
            Dist=vectorV1-vectorV2;
            if (BestDist > Dist)
                BestDist = Dist;
                BestVect = vect;
            end
            vect = vect + 1;
        end
        vector=1;
        totalDist=0;
        while (vector<TotalFrameV1)
            vectorV2 = SIFT2_sum((vector + BestVect - 1),3:end);
            vectorV1 = SIFT1_sum(vector,3:end);
            Dist = norm(vectorV1-vectorV2,Inf);
            totalDist = totalDist + Dist;
            vector=vector+1;
        end
        result = ['SIFT Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is = ',num2str(totalDist/countV2)];
        disp(result);
end
        