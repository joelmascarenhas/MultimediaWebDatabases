%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Enter Videos Numbers to be compared
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';    %PATH TO BE CHANGED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          Reading from in_file.hist                               %%%%%%%%%%%%%%% 
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
%%%%%%%%%%%%%%%%%                          Reading from in_file.sift                              %%%%%%%%%%%%%%%% 
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
%%%%%%%%%%%%%%%%%                          Reading from in_file.mvect                              %%%%%%%%%%%%%%%
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

TotalFrameV1 = MatrixHist1(counthistV1,2);
TotalFrameV2 = MatrixHist2(counthistV2,2);
flag = 0;diff = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (TotalFrameV1 == TotalFrameV2)
    disp('Both videos have equal number of frames');
else
    if (TotalFrameV1 >= TotalFrameV2)
        flag = 1;
    else
        flag = 2;
    end
end
switch(flag)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing Histogram Similarity in Progress');
        tot_histsim = 0;
        for vector = 1:counthistV1
                vectorHistV1 = MatrixHist1(vector,4:end);
                vectorHistV2 = MatrixHist2(vector,4:end);
                len=size(vectorHistV1);
                sim=0;max=-1;
                for it=1:len(2)
                    val=abs(vectorHistV1(it)-vectorHistV2(it));
                    if max<val
                        max=val;
                    end
                end
                tot_histsim=tot_histsim+max;
        end
        tot_histsim = tot_histsim/counthistV1;
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        ExtraFrames = TotalFrameV1 - TotalFrameV2;
        BestDist = 99999;BestVect = 0;Dist = 0;
        vect = 1;
        while (vect < (ExtraFrames*(counthistV1/TotalFrameV1)))
            vectorHistV1 = MatrixHist1(vect,4:end);
            vectorHistV2 = MatrixHist2(1,4:end);
            len=size(vectorHistV1);
            sim=0;
            for it=1:len(2)
                diff=vectorHistV1(it) - vectorHistV2(it);
                sim=sim+(diff*diff);
            end
            Dist = Dist + sqrt(sim);
            if (BestDist > Dist)
                BestDist = Dist;
                BestVect = vect;
            end
            vect = vect + counthistV1/TotalFrameV1;
        end
        tot_histsim = 0;
        for vector = 1:counthistV2
                vectorHistV1 = MatrixHist1((vector + BestVect - 1),4:end);
                vectorHistV2 = MatrixHist2(vector,4:end);
                len=size(vectorHistV1);
                sim=0;max=-1;
                for it=1:len(2)
                    val=abs(vectorHistV1(it)-vectorHistV2(it));
                    if max<val
                        max=val;
                    end
                end
                tot_histsim=tot_histsim+max;
        end
        tot_histsim = tot_histsim/counthistV2;
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing Histogram Similarity in Progress');
        ExtraFrames = TotalFrameV2 - TotalFrameV1;
        BestDist = 99999;BestVect = 0;Dist = 0;
        vect = 1;
        while (vect < (ExtraFrames*(counthistV2/TotalFrameV2)))
            vectorHistV1 = MatrixHist1(1,4:end);
            vectorHistV2 = MatrixHist2(vect,4:end);
            len = size(vectorHistV1);
            sim=0;
            for it=1:len(2)
                diff=vectorHistV1(it) - vectorHistV2(it);
                sim=sim+(diff*diff);
            end
            Dist = Dist + sqrt(sim);
            if (BestDist > Dist)
                BestDist = Dist;
                BestVect = vect;
            end
            vect = vect + counthistV2/TotalFrameV2;
        end
        tot_histsim = 0;
        for vector = 1:counthistV1
                vectorHistV1 = MatrixHist1((vector),4:end);
                vectorHistV2 = MatrixHist2(vector + BestVect - 1,4:end);
                len=size(vectorHistV1);
                sim=0;max=-1;
                for it=1:len(2)
                    val=abs(vectorHistV1(it)-vectorHistV2(it));
                    if max<val
                        max=val;
                    end
                end
                tot_histsim=tot_histsim+max;
        end
        tot_histsim = tot_histsim/counthistV1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          SIFT COMPUTATION                                       %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TotalFrameV1 = MatrixSift1(countsiftV1,2);
TotalFrameV2 = MatrixSift2(countsiftV2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 1                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcount = MatrixSift1(1, 3);
frameiter = 1;
framecount = MatrixSift1(frameiter,2);
iter = 1;
celliter1 = 1;
NewmatrixSift1 = zeros((MatrixSift1(countsiftV1,2))*MatrixSift1(countsiftV1,3),135);
while ( MatrixSift1(iter,2) == framecount)
    NewmatrixSift1(celliter1,1) = MatrixSift1(iter,1);
    NewmatrixSift1(celliter1,2) = MatrixSift1(iter,2);
    NewmatrixSift1(celliter1,3) = MatrixSift1(iter,3);
    cellcount = MatrixSift1(iter,3);
    num_vect = 0;
    while ( MatrixSift1(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:135
            NewmatrixSift1(celliter1,iter2)= NewmatrixSift1(celliter1,iter2)+MatrixSift1(iter,iter2);
        end
        if ( iter + 1 > countsiftV1 )
            break;
        end
        iter = iter+1;
    end
    for iter2 = 4:135
        NewmatrixSift1(celliter1,iter2)= NewmatrixSift1(celliter1,iter2)/num_vect;
    end 
    if (iter+1 > countsiftV1)
            break;
    end
    celliter1 = celliter1+1;
    framecount = MatrixSift1(iter,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 2                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcount = MatrixSift2(1, 3);
frameiter = 1;
framecount = MatrixSift2(frameiter,2);
iter = 1;
celliter2 = 1;
NewmatrixSift2 = zeros((MatrixSift2(countsiftV2,2))*MatrixSift2(countsiftV2,3),135);
while ( MatrixSift2(iter,2) == framecount)
    NewmatrixSift2(celliter2,1) = MatrixSift2(iter,1);
    NewmatrixSift2(celliter2,2) = MatrixSift2(iter,2);
    NewmatrixSift2(celliter2,3) = MatrixSift2(iter,3);
    cellcount = MatrixSift2(iter,3);
    num_vect = 0;
    while ( MatrixSift2(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:135
            NewmatrixSift2(celliter2,iter2)= NewmatrixSift2(celliter2,iter2)+MatrixSift2(iter,iter2);
        end
        if ( iter + 1 > countsiftV2 )
            break;
        end
        iter = iter+1;
    end
    for iter2 = 4:135
        NewmatrixSift2(celliter2,iter2)= NewmatrixSift2(celliter2,iter2)/num_vect;
    end     
    if (iter+1 > countsiftV2)
            break;
    end
    celliter2 = celliter2+1;
    framecount = MatrixSift2(iter,2);
end  
countm1 = size(NewmatrixSift1);
countm2 = size(NewmatrixSift2);
Counts = abs(countm1(1)-countm2(1));
if ( countm1(1) > countm2(1) )
	Counts = countm2(1);
else
	Counts = countm1(1); 
end
if ( Counts == 0 )
    Counts = TotalFrameV2*cellcount;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag = 0;
if (TotalFrameV1 == TotalFrameV2)
    %disp('Both videos have equal number of frames');
else
    if (TotalFrameV1 >= TotalFrameV2)
        flag = 1;
    else
        flag = 2;
    end
end

switch(flag)
    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp ('Computing SIFT Similarity in Progress');
        ExtraFrames = abs(TotalFrameV1 - TotalFrameV2);
        BestVect = 1;
        vector = 1;
        totalDist = 0;
        while (vector < Counts)
            if ( NewmatrixSift1(vector,1) ~= 0)
              if (NewmatrixSift2(vector,1) ~=0)  
                    vectorV1 = NewmatrixSift1(vector,4:end);
                    vectorV2 = NewmatrixSift2(vector,4:end);
                    Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                    totalDist = totalDist + Dist;
               end 
            end 
            vector = vector + 1;
        end
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        ExtraFrames = abs(TotalFrameV1 - TotalFrameV2);
        BestDist = 99999;BestVect = 0;
        vect = 1;
        while (vect < ExtraFrames)
            if (NewmatrixSift1(vect,1) ~= 0) 
                vectorV1 = NewmatrixSift1(1,4:end);
                vectorV2 = NewmatrixSift2(vect,4:end);
                Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                if (BestDist > Dist)
                    BestDist = Dist;
                    BestVect = vect;
                end
                vect = vect + 1;
            end   
        end
        vector = 1;
        totalDist = 0;
        while (vector < ExtraFrames)
            if (NewmatrixSift1(vector+BestVect-1,1) ~=0)
             if ( NewmatrixSift2(vector,1) ~= 0)
                    vectorV1 = NewmatrixSift1((vector + BestVect - 1),4:end);
                    vectorV2 = NewmatrixSift2(vector,4:end);
                    Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                    totalDist = totalDist + Dist;

             end     
            end  
            vector = vector + 1;
        end
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        ExtraFrames = abs(TotalFrameV2 - TotalFrameV1);
        BestDist = 99999;BestVect = 1;
        vect = 1;
        while (vect < ExtraFrames)
            if (NewmatrixSift2(vect,1) ~= 0)
                vectorV1 = NewmatrixSift1(1,4:end);
                vectorV2 = NewmatrixSift2(vect,4:end);
                Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                if (BestDist > Dist)
                    BestDist = Dist;
                    BestVect = vect;
                end
                vect = vect + 1;
            end   
        end
        totalDist = 0;
        vector = 1;
        while (vector < TotalFrameV1)
            if (NewmatrixSift2(vector+BestVect-1,1) ~= 0)
               if (NewmatrixSift1(vector,1) ~= 0)
                        vectorV1 = NewmatrixSift1(vector,4:end);
                        vectorV2 = NewmatrixSift2(vector + BestVect - 1,4:end);
                        Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                        totalDist = totalDist + Dist;
               end
            end
            vector = vector + 1;
        end
end           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                        MOTION VECTOR COMPUTATION                                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frame_it=1;
Mat1=zeros((MatrixMvect1(countmvectV1,2))*MatrixMvect1(countmvectV1,3),10);
numberofframes1 = MatrixMvect1(countmvectV1,3);
Mat2=zeros((MatrixMvect2(countmvectV2,2))*MatrixMvect2(countmvectV2,3),10);
numberofframes2 = MatrixMvect2(countmvectV2,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    for it2 = 5:10
        Mat1(cell_it,it2) = Mat1(cell_it,it2)/num_vec;
    end
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
    for it2 = 5:10
        Mat2(cell_it,it2) = Mat2(cell_it,it2)/num_vec;
    end
    if (it+1 >countmvectV2)
            break;
    end
    cell_it=cell_it+1;
    frame_no=MatrixMvect2(it,2);
end

TotalFrameV1 = MatrixMvect1(countmvectV1,2);
TotalFrameV2 = MatrixMvect2(countmvectV2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag = 0;
if (TotalFrameV1 > TotalFrameV2)
   flag = 1;
end
if (TotalFrameV1 < TotalFrameV2)
   flag = 2;
end
abs1 = norm(Mat1);
abs2 = norm(Mat2);
total_abs = abs1*abs2;
len1=size(Mat1);
sim = 0;
sim1 = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag==0)
    disp('Computing MotionVector Similarity in Progress');
    total_msim = 0;
    for vector = 1:len1(1)
       for move = 1:10
          sim1 = pdist2(Mat1(vector,5:10),Mat2(vector,5:10),'minkowski',2);
          sim = sim + sim1;
       end    
       total_msim = (sim*10000)/total_abs;
    end
    Overallsimilarity = tot_histsim + total_msim + (totalDist/10);
end
if(flag==2)
    buffer=Mat1;
    Mat1=Mat2;
    Mat2=buffer;
end
len1=size(Mat1);
len2=size(Mat2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag~=0)
    disp('Computing SIFT Similarity in Progress');
    disp('Videos have unequal frames');
    ExtraFrames = abs(TotalFrameV1 - TotalFrameV2);
    BestDist = 99999;BestVect = 0;
    vect=1;
    while ( Mat1(len1(1),3) == 0)
        len1(1) = len1(1)-1;
    end 
    no_cells=Mat1(len1(1),3);
    while(vect<=ExtraFrames)
        it=1;
        Dist=0;
            Dist = Dist + ( 10000*pdist2(Mat1(1,5:10),Mat2(vect,5:10),'minkowski',2) );
        if (BestDist > Dist)
            BestDist = Dist;
            BestVect = vect;
        end
        vect = vect + 1;
        Dist=0;
    end
    total_msim = 0;
    for vector = 1:len2(1)
       if (Mat1(vector+BestVect-1,3) ~= 0)
          sim1 =  pdist2(Mat1(vector+BestVect-1,5:10),Mat2(vector,5:10),'minkowski',2);
          sim = sim + sim1;
          total_msim = (sim*1000000)/total_abs; 
       end
    end
end

Overallsimilarity = (tot_histsim/100) + total_msim + (totalDist/100);
result = ['Overall Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is ',num2str(Overallsimilarity)];
disp (result);