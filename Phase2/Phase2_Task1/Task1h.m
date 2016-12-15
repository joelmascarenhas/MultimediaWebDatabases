%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Enter Videos Numbers to be compared
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';     %PATH TO BE CHANGED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Reading from in_file.hist                               %%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InputPath = fullfile(InputDir,'in_file.chst');             
Input = fileread(InputPath);                 
AllVector = strsplit(Input,'\n');
AllVector = AllVector';
lenVectorCount = size(AllVector)-1;
InputMatrixHist = zeros(lenVectorCount(1),1);
lenEachVector = 0;
for eachvector = 1:lenVectorCount(1)
    eachVectorList = strsplit(char(AllVector(eachvector)),',');
    lenEachVector = size(eachVectorList);
    for matrix = 1:lenEachVector(2)
        value = eachVectorList{matrix};
        InputMatrixHist(eachvector,matrix) = str2double(value);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Reading from in_file.sift                               %%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputPath = fullfile(InputDir,'in_file.sift');             
Input = fileread(InputPath);                 
AllVector = strsplit(Input,'\n');
AllVector = AllVector';
lenVectorCount = size(AllVector)-1;
InputMatrixSift = zeros(lenVectorCount(1),1);
lenEachVector = 0;
for eachvector = 1:lenVectorCount(1)
    eachVectorList = strsplit(char(AllVector(eachvector)),',');
    lenEachVector = size(eachVectorList);
    for matrix = 1:lenEachVector(2)
        value = eachVectorList{matrix};
        InputMatrixSift(eachvector,matrix) = str2double(value);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Reading from in_file.mvect                              %%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputPath = fullfile(InputDir,'in_file.mvect');             
Input = fileread(InputPath);                 
AllVector = strsplit(Input,'\n');
AllVector = AllVector';
lenVectorCount = size(AllVector)-1;
InputMatrixMvect = zeros(lenVectorCount(1),1);
lenEachVector = 0;
for eachvector = 1:lenVectorCount(1)
    eachVectorList = strsplit(char(AllVector(eachvector)),',');
    lenEachVector = size(eachVectorList);
    for matrix = 1:lenEachVector(2)
        value = eachVectorList{matrix};
        InputMatrixMvect(eachvector,matrix) = str2double(value);
    end
end

counthistV1 = 0;starthistV1 = 0;counthistV2 = 0;starthistV2 = 0;
countsiftV1 = 0;startsiftV1 = 0;countsiftV2 = 0;startsiftV2 = 0;
countmvectV1 = 0;startmvectV1 = 0;countmvectV2 = 0;startmvectV2 = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Creating Matrix for Video 1 and Video 2 for Histogram                  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputMatrixSize = size(InputMatrixHist);
for Vector = 1:InputMatrixSize(1)
    if (InputMatrixHist(Vector,1) == str2double(Video1))
        if(starthistV1 == 0)
            starthistV1 = Vector;
        end    
        counthistV1 = counthistV1 + 1;
    end
    if (InputMatrixHist(Vector,1) == str2double(Video2))
        if(starthistV2 == 0)
            starthistV2 = Vector;
        end
        counthistV2 = counthistV2 + 1;
    end 
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Creating Matrix for Video 1 and Video 2 for SIFT                       %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputMatrixSize = size(InputMatrixSift);
for Vector = 1:InputMatrixSize(1)
    if (InputMatrixSift(Vector,1) == str2double(Video1))
        if(startsiftV1 == 0)
            startsiftV1 = Vector;
        end    
        countsiftV1 = countsiftV1 + 1;
    end
    if (InputMatrixSift(Vector,1) == str2double(Video2))
        if(startsiftV2 == 0)
            startsiftV2 = Vector;
        end
        countsiftV2 = countsiftV2 + 1;
    end 
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Creating Matrix for Video 1 and Video 2 for Motion Vector              %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputMatrixSize = size(InputMatrixMvect);
for Vector = 1:InputMatrixSize(1)
    if (InputMatrixMvect(Vector,1) == str2double(Video1))
        if(startmvectV1 == 0)
            startmvectV1 = Vector;
        end    
        countmvectV1 = countmvectV1 + 1;
    end
    if (InputMatrixMvect(Vector,1) == str2double(Video2))
        if(startmvectV2 == 0)
            startmvectV2 = Vector;
        end
        countmvectV2 = countmvectV2 + 1;
    end 
end

MatrixHist1 = InputMatrixHist(starthistV1:(starthistV1+counthistV1-1),1:end);
MatrixHist2 = InputMatrixHist(starthistV2:(starthistV2+counthistV2-1),1:end);
MatrixSift1 = InputMatrixSift(startsiftV1:(startsiftV1+countsiftV1-1),1:end);
MatrixSift2 = InputMatrixSift(startsiftV2:(startsiftV2+countsiftV2-1),1:end);
MatrixMvect1 = InputMatrixMvect(startmvectV1:(startmvectV1+countmvectV1-1),1:end);
MatrixMvect2 = InputMatrixMvect(startmvectV2:(startmvectV2+countmvectV2-1),1:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          Histogram COMPUTATION                                  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CovarianceMatrix = cov(InputMatrixHist(1:end,4:end));
InvCovarianceMatrix = pinv(CovarianceMatrix);
binlength = size(CovarianceMatrix);
TotalFrameHistV1 = MatrixHist1(counthistV1,2);
TotalFrameHistV2 = MatrixHist2(counthistV2,2);
flaghist = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (TotalFrameHistV1 == TotalFrameHistV2)
    %disp('Both videos have equal number of frames');
else
    if (TotalFrameHistV1 >= TotalFrameHistV2)
        flaghist = 1;
    else
        flaghist = 2;
    end
end
switch(flaghist)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing Histogram Similarity in Progress');
        totalDistHist = 0;
        for vectorHist = 1:counthistV1
                vectorHistV1 = MatrixHist1(vectorHist,4:end);
                vectorHistV2 = MatrixHist2(vectorHist,4:end);
                vectorHistVmain = zeros(1,binlength(1));
                for iterHist = 1:binlength(1)
                    vectorHistVmain(1,iterHist) = abs(vectorHistV1(1,iterHist)) - abs(vectorHistV2(1,iterHist));
                end
                vectorHistVmainT = vectorHistVmain';
                MahaDist = sqrt(vectorHistVmain * InvCovarianceMatrix * vectorHistVmainT);
                totalDistHist = totalDistHist + MahaDist;
        end
        resultHist=totalDistHist/counthistV1;
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        ExtraFramesHist = TotalFrameHistV1 - TotalFrameHistV2;
        BestDistHist = 99999;BestVectHist = 0;tot_simHist = 0;
        vectHist = 1;
        while (vectHist < (ExtraFramesHist*(counthistV1/TotalFrameHistV1)))
            vectorHistV1 = MatrixHist1(vectHist,4:end);
            vectorHistV2 = MatrixHist2(1,4:end);
            len=size(vectorHistV1);
                sim=0;max=-1;
                for it=1:len(2)
                    val=abs(vectorHistV1(it)-vectorHistV2(it));
                    if max<val
                        max=val;
                    end
                end
                tot_simHist=tot_simHist+max;
            if (BestDistHist > tot_simHist)
                BestDistHist = tot_simHist;
                BestVectHist = vectHist;
            end
            vectHist = vectHist + 4;
        end
        totalDistHist = 0;
        for vectorHist = 1:counthistV2
                vectorHistV1 = MatrixHist1((vectorHist + BestVectHist - 1),4:end);
                vectorHistV2 = MatrixHist2(vectorHist,4:end);
                vectorHistVmain = zeros(1,binlength(1));
                for iterHist = 1:binlength(1)
                    vectorHistVmain(1,iterHist) = abs(vectorHistV1(1,iterHist)) - abs(vectorHistV2(1,iterHist));
                end
                vectorHistVmainT = vectorHistVmain';
                MahaDist = sqrt(vectorHistVmain * InvCovarianceMatrix * vectorHistVmainT);
                totalDistHist = totalDistHist + MahaDist;
        end
        resultHist=totalDistHist/counthistV2;
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        ExtraFramesHist = TotalFrameHistV2 - TotalFrameHistV1;
        BestDistHist = 99999;BestVectHist = 0;tot_simHist = 0;
        vectHist = 1;
        while (vectHist < (ExtraFramesHist*(counthistV2/TotalFrameHistV2)))
            vectorHistV1 = MatrixHist1(1,4:end);
            vectorHistV2 = MatrixHist2(vectHist,4:end);
            len=size(vectorHistV1);
            sim=0;max=-1;
            for it=1:len(2)
                val=abs(vectorHistV1(it)-vectorHistV2(it));
               if max<val
                   max=val;
               end
            end
            tot_simHist = tot_simHist + max;
            if (BestDistHist > tot_simHist)
                BestDistHist = tot_simHist;
                BestVectHist = vectHist;
            end
            vectHist = vectHist + 4;
        end
        totalDistHist = 0;
        for vectorHist = 1:counthistV1
                vectorHistV1 = MatrixHist1(vectorHist,4:end);
                vectorHistV2 = MatrixHist2((vectorHist + BestVectHist - 1),4:end);
                vectorHistVmain = zeros(1,binlength(1));
                for iterHist = 1:binlength(1)
                    vectorHistVmain(1,iterHist) = abs(vectorHistV1(1,iterHist)) - abs(vectorHistV2(1,iterHist));
                end
                vectorHistVmainT = vectorHistVmain';
                MahaDist = sqrt(vectorHistVmain * InvCovarianceMatrix * vectorHistVmainT);
                totalDistHist = totalDistHist + MahaDist;
        end
        resultHist=totalDistHist/counthistV1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          SIFT COMPUTATION                                       %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TotalFrameV1Sift = MatrixSift1(countsiftV1,2);
TotalFrameV2Sift = MatrixSift2(countsiftV2,2);

SIFT1=InputMatrixSift(startsiftV1:(startsiftV1+countsiftV1-1),2:end);
SIFT2=InputMatrixSift(startsiftV2:(startsiftV2+countsiftV2-1),2:end);

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

countn1Sift = size(SIFT1_sum);
countn2Sift = size(SIFT2_sum);
if (countn1Sift(1)>countn2Sift(1))
    SIFT2_sum=[SIFT2_sum ; zeros(countn1Sift(1)-countn2Sift(1),134)];
end
if (countn1Sift(1)<countn2Sift(1))
    SIFT1_sum=[SIFT1_sum ; zeros(countn2Sift(1)-countn1Sift(1),134)];
end
CountsSift = abs(countn1Sift(1)-countn2Sift(1));
if ( CountsSift == 0 )
    CountsSift = TotalFrameV2Sift*4;
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flagSift = 0;
if (TotalFrameV1Sift == TotalFrameV2Sift)
    %disp('Both videos have equal number of frames');
else
    if (TotalFrameV1Sift >= TotalFrameV2Sift)
        flagSift = 1;
    else
        flagSift = 2;
    end
end
switch(flagSift)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing SIFT Similarity in Progress');
        totalDistSift = 0;
        for vector = 1:CountsSift
               vectorV1Sift = SIFT1_sum(vector,3:end);
               vectorV2Sift = SIFT2_sum(vector,3:end);
               Dist=norm(vectorV1Sift-vectorV2Sift,Inf);
               totalDistSift = totalDistSift+Dist;
        end
        resultSift=totalDistSift/countsiftV1;
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        ExtraFramesSift = TotalFrameV1Sift - TotalFrameV2Sift;
        BestDistSift = 99999;BestVect = 0;
        vectSift = 1;
        while (vectSift < ExtraFramesSift)
            vectorV1Sift = SIFT1_sum(vectSift,3:end);
            vectorV2Sift = SIFT2_sum(1,3:end);
            Dist=vectorV1Sift-vectorV2Sift;
            if (BestDistSift > Dist)
                    BestDistSift = Dist;
                    BestVect = vectSift;
            end
            vectSift = vectSift + 1;
        end
        vector=1;
        totalDistSift=0;
        while (vector < ExtraFramesSift)
             vectorV1Sift = SIFT1_sum((vector + BestVect - 1),3:end);
             vectorV2Sift = SIFT2_sum(vector,3:end);
             Dist = norm(vectorV1Sift-vectorV2Sift,Inf);
             totalDistSift = totalDistSift + Dist;
             vector=vector+1;
        end
        resultSift=totalDistSift/countsiftV2;
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        ExtraFramesSift = TotalFrameV2Sift - TotalFrameV1Sift;
        BestDistSift = 99999;BestVect = 1;
        vectSift = 1;
        while (vectSift < ExtraFramesSift)
            vectorV1Sift = SIFT1_sum(vectSift,3:end);
            vectorV2Sift = SIFT2_sum(1,3:end);
            Dist=vectorV1Sift-vectorV2Sift;
            if (BestDistSift > Dist)
                BestDistSift = Dist;
                BestVect = vectSift;
            end
            vectSift = vectSift + 1;
        end
        vector=1;
        totalDistSift=0;
        while (vector<TotalFrameV1Sift)
             vectorV2Sift = SIFT2_sum((vector + BestVect - 1),3:end);
             vectorV1Sift = SIFT1_sum(vector,3:end);
             Dist = norm(vectorV1Sift-vectorV2Sift,Inf);
             totalDistSift = totalDistSift + Dist;
             vector=vector+1;
        end
        resultSift=totalDistSift/countsiftV2;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                        MOTION VECTOR COMPUTATION                                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frame_it=1;
no_of_cells=MatrixMvect1(countmvectV1,3);
Mat1=zeros((MatrixMvect1(countmvectV1,2)-1)*MatrixMvect1(countmvectV1,3),12);
Mat2=zeros((MatrixMvect2(countmvectV2,2)-1)*MatrixMvect2(countmvectV2,3),12);
disp('Computing Motion Vector Similarity in Progress');
frame_no=MatrixMvect1(frame_it,2);
it=1;
cell_it=1;
while (MatrixMvect1(it,2)==frame_no)
    Mat1(cell_it,1)=MatrixMvect1(it,1);
    Mat1(cell_it,2)=MatrixMvect1(it,2);
    Mat1(cell_it,3)=MatrixMvect1(it,3);
    cell_num=MatrixMvect1(it,3);
    num_vec=0;
    while (MatrixMvect1(it,3)==cell_num)
        num_vec=num_vec+1;
        for it2=4:10            
            Mat1(cell_it,it2)=Mat1(cell_it,it2)+MatrixMvect1(it,it2);
        end
        if (it+1 >countmvectV1)
            break;
        end
        it=it+1;
    end
    for it2=5:10
        x=Mat1(cell_it,it2);
        Mat1(cell_it,it2)=x/num_vec;
    end
    x=Mat1(cell_it,9)-Mat1(cell_it,7);
    y=Mat1(cell_it,10)-Mat1(cell_it,8);
    if y==0
        angle=0;
    else
        angle=y/x;
    end
    Mat1(cell_it,11)=atand(angle);
    if (it+1 >countmvectV1)
            break;
    end
    cell_it=cell_it+1;
    frame_no=MatrixMvect1(it,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 2                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frame_it=1;
frame_no=MatrixMvect2(frame_it,2);
it=1;
cell_it=1;
while (MatrixMvect2(it,2)==frame_no)
    Mat2(cell_it,1)=MatrixMvect2(it,1);
    Mat2(cell_it,2)=MatrixMvect2(it,2);
    Mat2(cell_it,3)=MatrixMvect2(it,3);
    cell_num=MatrixMvect2(it,3);
    num_vec=0;
    while (MatrixMvect2(it,3)==cell_num)
        num_vec=num_vec+1;
        for it2=4:10            
            Mat2(cell_it,it2)=Mat2(cell_it,it2)+MatrixMvect2(it,it2);
        end
        if (it+1 >countmvectV2)
            break;
        end
        it=it+1;
    end
    for it2=5:10
        x=Mat2(cell_it,it2);
        Mat2(cell_it,it2)=x/num_vec;
    end
    x=Mat2(cell_it,9)-Mat2(cell_it,7);
    y=Mat2(cell_it,10)-Mat2(cell_it,8);
    if y==0
        angle=0;
    else
        angle=y/x;
    end
    Mat2(cell_it,11)=atand(angle);
    if (it+1 >countmvectV2)
            break;
    end
    cell_it=cell_it+1;
    frame_no=MatrixMvect2(it,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalFrameV1 = MatrixMvect1(countmvectV1,2);
TotalFrameV2 = MatrixMvect2(countmvectV2,2);
flagmvect = 0;
if (TotalFrameV1 > TotalFrameV2)
   flagmvect = 1;
end
if (TotalFrameV1 < TotalFrameV2)
   flagmvect = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len1=size(Mat1);
if(flagmvect==0)
    total_sim = 0;sim=0;
    len2=size(Mat2);
    it1=1;it2=1;      
    for vector = 1:len1(1)
        sim=0;
        for it1=5:10
            sim=sim+abs(Mat1(vector,it1)-Mat2(vector,it1));
        end
        sim=sim+abs(Mat1(vector,11)-Mat2(vector,11))/180;
        total_sim=total_sim+sim;
    end
    resultMvect=total_sim/4;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flagmvect==2)
    buffer=Mat1;
    Mat1=Mat2;
    Mat2=buffer;
end
len1=size(Mat1);
len2=size(Mat2);
if(flagmvect~=0)
    ExtraFrames = TotalFrameV1 - TotalFrameV2;
    BestDist = 99999;BestVect = 0;
    vect=1;
    while ( Mat1(len1(1),3) == 0)
        len1(1) = len1(1)-1;
    end
    while ( Mat2(len2(1),3) == 0)
        len2(1) = len2(1)-1;
    end
    while(vect<=abs(ExtraFrames))
        it=1;
        Dist=0;
        while (it<=no_of_cells)
            dist1=0;
            for it1=5:10
                dist1=dist1+abs(Mat1((vect-1)*no_of_cells+it,it1)-Mat2(it,it1));
            end
            dist1=dist1+abs(Mat1((vect-1)*no_of_cells+it,11)-Mat2(it,11))/180;
            Dist =Dist+dist1;
            it=it+1;
        end
        if (BestDist > Dist)
            BestDist = Dist;
            BestVect = vect;
        end
        vect = vect + 1;
        Dist=0;
    end
    minlen = 0;
    if ( len1(1) < len2(1))
        minlen = len1(1);
    else 
        minlen = len2(1);
    end
    total_sim = 0;
    for vector = 1:minlen(1)
        dist=0;
        for it=5:10
            dist=dist+abs(Mat1(vector+BestVect,it)-Mat2(vector,it));
        end
        dist=dist+abs(Mat1(vector+BestVect,11)-Mat2(vector,11))/180;
        total_sim=total_sim+dist;
    end
    resultMvect=total_sim/4;
end
Overall_Sim=resultHist + resultSift*10 + resultMvect/10;
result = ['Overall Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is ',num2str(Overall_Sim)];
disp (result);
