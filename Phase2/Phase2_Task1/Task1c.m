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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalFrameV1 = Matrix1(countV1,2);
TotalFrameV2 = Matrix2(countV2,2);

cellcount = Matrix1(1, 3);
frameiter = 1;
framecount = Matrix1(frameiter,2);
iter = 1;
celliter1 = 1;
Newmatrix1 = zeros((Matrix1(countV1,2))*Matrix1(countV1,3),135);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 1                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ( Matrix1(iter,2) == framecount)
    Newmatrix1(celliter1,1) = Matrix1(iter,1);
    Newmatrix1(celliter1,2) = Matrix1(iter,2);
    Newmatrix1(celliter1,3) = Matrix1(iter,3);
    cellcount = Matrix1(iter,3);
    num_vect = 0;
    while ( Matrix1(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:135
            Newmatrix1(celliter1,iter2)= Newmatrix1(celliter1,iter2)+Matrix1(iter,iter2);
        end
        if ( iter + 1 > countV1 )
            break;
        end
        iter = iter+1;
    end
    for iter2 = 4:135
        Newmatrix1(celliter1,iter2)= Newmatrix1(celliter1,iter2)/num_vect;
    end 
    if (iter+1 > countV1)
            break;
    end
    celliter1 = celliter1+1;
    framecount = Matrix1(iter,2);
end

cellcount = Matrix2(1, 3);
frameiter = 1;
framecount = Matrix2(frameiter,2);
iter = 1;
celliter2 = 1;
Newmatrix2 = zeros((Matrix2(countV2,2))*Matrix2(countV2,3),135);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 2                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ( Matrix2(iter,2) == framecount)
    Newmatrix2(celliter2,1) = Matrix2(iter,1);
    Newmatrix2(celliter2,2) = Matrix2(iter,2);
    Newmatrix2(celliter2,3) = Matrix2(iter,3);
    cellcount = Matrix2(iter,3);
    num_vect = 0;
    while ( Matrix2(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:135
            Newmatrix2(celliter2,iter2)= Newmatrix2(celliter2,iter2)+Matrix2(iter,iter2);
        end
        if ( iter + 1 > countV2 )
            break;
        end
        iter = iter+1;
    end
    for iter2 = 4:135
        Newmatrix2(celliter2,iter2)= Newmatrix2(celliter2,iter2)/num_vect;
    end     
    if (iter+1 > countV2)
            break;
    end
    celliter2 = celliter2+1;
    framecount = Matrix2(iter,2);
end  
countm1 = size(Newmatrix1);
countm2 = size(Newmatrix2);
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
        ExtraFrames = abs(TotalFrameV1 - TotalFrameV2);
        BestVect = 1;
        vector = 1;
        totalDist = 0;
        while (vector < Counts)
            if ( Newmatrix1(vector,1) ~= 0)
              if (Newmatrix2(vector,1) ~=0)  
                    vectorV1 = Newmatrix1(vector,4:end);
                    vectorV2 = Newmatrix2(vector,4:end);
                    Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                    totalDist = totalDist + Dist;
              end 
            end 
            vector = vector + 1;
        end
        result = ['SIFT Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' using Minkowski L2 = ',num2str(totalDist/10)];
        disp(result);
        
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        disp('Video 1 has more frames than Video 2, comparison made w.r.t to Video2');
        ExtraFrames = abs(TotalFrameV1 - TotalFrameV2);
        BestDist = 99999;BestVect = 0;
        vect = 1;
        while (vect < ExtraFrames)
            if (Newmatrix1(vect,1) ~= 0) 
                vectorV1 = Newmatrix1(1,4:end);
                vectorV2 = Newmatrix2(vect,4:end);
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
            if (Newmatrix1(vector+BestVect-1,1) ~=0)
                if ( Newmatrix2(vector,1) ~= 0)
                    vectorV1 = Newmatrix1((vector + BestVect - 1),4:end);
                    vectorV2 = Newmatrix2(vector,4:end);
                    Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                    totalDist = totalDist + Dist;
                end 
            end  
             vector = vector + 1;
        end
        result = ['SIFT Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' using Minkowski L2 = ',num2str(totalDist/10)];
        disp(result);
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Computing SIFT Similarity in Progress');
        disp('Video 2 has more frames than Video 1, comparison made w.r.t to Video1');
        ExtraFrames = abs(TotalFrameV2 - TotalFrameV1);
        BestDist = 99999;BestVect = 1;
        vect = 1;
        while (vect < ExtraFrames)
            if (Newmatrix2(vect,1) ~= 0)
                vectorV1 = Newmatrix1(1,4:end);
                vectorV2 = Newmatrix2(vect,4:end);
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
             if (Newmatrix2(vector+BestVect-1,1) ~= 0)
                if (Newmatrix1(vector,1) ~= 0)
                        vectorV1 = Newmatrix1(vector,4:end);
                        vectorV2 = Newmatrix2(vector + BestVect - 1,4:end);
                        Dist = pdist2(vectorV1,vectorV2,'minkowski',2);
                        totalDist = totalDist + Dist;
                end 
             end
             vector = vector + 1;
        end
        result = ['SIFT Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' using Minkowski L2 = ',num2str(totalDist/10)];
        disp(result); 
end           