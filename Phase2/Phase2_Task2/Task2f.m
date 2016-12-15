%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Video = input('Enter index of Video of input subsequence (V):- ','s');                
Frames = input('Enter Frame Range in the format - FirstFrame,LastFrame:- ','s');
FrameRange = str2double(strsplit(Frames,','));
k = input('Enter number of output Frame sequences required (k)','s'); 
InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          Reading from in_file.mvect                              %%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InputPath = fullfile(InputDir,'in_file.mvect');             
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
startV = 0;endV =0 ;
for vector = 1:InputMatrixSize(1)
    if (InputMatrix(vector,1) == str2double(Video)) && ((InputMatrix(vector,2) == FrameRange(1,1)))
        if(startV == 0)
            startV = vector;
        end    
    end
    if (InputMatrix(vector,1) == str2double(Video)) && ((InputMatrix(vector,2) == (FrameRange(1,2) + 1)))
        if(endV == 0)
            endV = vector - 1;
        end    
    end
end   

Matrix1 = InputMatrix(startV:endV,1:end);
TotalVideo = InputMatrix(InputMatrixSize(1),1);
Matrix1Size = size(Matrix1);
countV1 = Matrix1Size(1);
countV2 = InputMatrixSize(1);

cellcount = Matrix1(1, 3);
frameiter = 1;
framecount = Matrix1(frameiter,2);
iter = 1;
celliter1 = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                  creating aggregate matrix for input video                       %%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Newmatrix1 = zeros((FrameRange(2)- FrameRange(1)+1),10);
while ( Matrix1(iter,2) == framecount)
    Newmatrix1(celliter1,1) = Matrix1(iter,1);
    Newmatrix1(celliter1,2) = Matrix1(iter,2);
    Newmatrix1(celliter1,3) = Matrix1(iter,3);
    cellcount = Matrix1(iter,3);
    num_vect = 0;
    while ( Matrix1(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:10
            Newmatrix1(celliter1,iter2)= Newmatrix1(celliter1,iter2)+Matrix1(iter,iter2);
        end
        if ( iter + 1 > countV1 )
            break;
        end
        iter = iter+1;
    end
    
    for iter2 = 4:10
        Newmatrix1(celliter1,iter2)= Newmatrix1(celliter1,iter2)/num_vect;
    end 
    if (iter+1 > countV1)
            break;
    end
    celliter1 = celliter1+1;
    framecount = Matrix1(iter,2);
end

cellcount = InputMatrix(1, 3);
frameiter = 1;
framecount = InputMatrix(frameiter,2);
iter = 1;
celliter2 = 1;
Newmatrix2 = zeros((InputMatrix(countV2,2))*InputMatrix(countV2,3),10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                  creating aggregate matrix all the  input video                       %%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ( InputMatrix(iter,2) == framecount)
    Newmatrix2(celliter2,1) = InputMatrix(iter,1);
    Newmatrix2(celliter2,2) = InputMatrix(iter,2);
    Newmatrix2(celliter2,3) = InputMatrix(iter,3);
    cellcount = InputMatrix(iter,3);
    num_vect = 0;
    while ( InputMatrix(iter,3) == cellcount )
        num_vect = num_vect +1;
        for iter2 = 4:10
            Newmatrix2(celliter2,iter2)= Newmatrix2(celliter2,iter2)+ InputMatrix(iter,iter2);
        end
        if ( iter + 1 > countV2 )
            break;
        end
        iter = iter+1;
    end
    
    for iter2 = 4:10
        Newmatrix2(celliter2,iter2)= Newmatrix2(celliter2,iter2)/num_vect;
    end     
    if (iter+1 > countV2)
            break;
    end
    celliter2 = celliter2+1;
    framecount = InputMatrix(iter,2);
end  
NewInputMatrixSize = size(Newmatrix2);

ksim = zeros(TotalVideo,3);
for eachvideo = 1:TotalVideo
    startV = 0;countV = 0 ;
    for vector = 1:NewInputMatrixSize(1)
        if (Newmatrix2(vector,1) == eachvideo)
           if (startV == 0)
                startV = vector;
           end 
           countV = countV + 1;
        end
    end  
    
    Matrix2 = Newmatrix2(startV:(startV + countV - 1),1:end);
    lenSubSequence = size(Newmatrix1);
    SimilarityMatrix = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2(countV,2)- 1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%                  creating aggregate matrix for each video                        %%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    start = 1;i = 1;j = 1;p =1;
    while (start < lenSubSequence(1))
            fr = Newmatrix1(start +p - 1,2);
            while ((start + p -1) < lenSubSequence(1))
                if (Newmatrix1(start + p - 1,2) == fr)
                   p = p+1;
                else 
                    break;
                end   
            end    
            for eachcellM1 = 1:p-1
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%           Creating similarity Matrix for input video to other videos             %%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                cellvectorM1 = Newmatrix1(start + eachcellM1 - 1,4:end);
                for eachcellM2 = 1:countV
                    if (Matrix2(eachcellM2,3) == eachcellM1)
                        cellvectorM2 = Matrix2(eachcellM2,4:end);
                        len = size(cellvectorM1);
                        sim = 0;tot_sim = 0;
                        for it = 1:len(2)
                         diff = cellvectorM1(it) - cellvectorM2(it);
                         sim = sim +(diff * diff);
                        end
                        SimilarityMatrix(i,j) = SimilarityMatrix(i,j) + sqrt(sim);
                        j = j + 1;
                    end    
                end
                j = 1;
            end
        start = start + p - 1;
        p = 1;
        i = i + 1;   
    end
    SimilarityMatrix = SimilarityMatrix/4;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%   Finding the least common subsequence based on distance measure                 %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sizeSim = size(SimilarityMatrix);
    frameMatrix = zeros(1,sizeSim(1));
    min = 99999;runningsum = 0;
    for i = 1:sizeSim(1)
        min = 99999;
        for j = 1:sizeSim(2)
            if(any(frameMatrix == j))
               continue;
            else   
                if(i == 1) && (SimilarityMatrix(i,j) < min)
                    min = SimilarityMatrix(i,j);
                    frameref = j; 
                end
                sum = 0;
                if(i ~=1)
                    fms = size(frameMatrix);
                    s = 1;
                    for q = 1:i-1
                        sum = sum + SimilarityMatrix(s,frameMatrix(1,q));
                        s = s + 1;
                    end
                end
                sum = sum/(i-1);
                if((i ~= 1) && (abs(SimilarityMatrix(i,j) - sum) < min))
                    min = abs(SimilarityMatrix(i,j) - sum);
                    frameref = j; 
                end
            end    
        end
        runningsum = runningsum + SimilarityMatrix(i,frameref);
        frameMatrix(1,i) = frameref;
    end 

   first = 99999;last = 1;
   lenframeMatrix = size(frameMatrix);
   for i = 1:lenframeMatrix(2)
      if(frameMatrix(1,i) > last)
          last = frameMatrix(1,i);
      end
      if(frameMatrix(1,i) < first)
          first = frameMatrix(1,i);
      end
   end 
   
   ksim(eachvideo,1) = runningsum/(FrameRange(2) - FrameRange(1));
   ksim(eachvideo,2) = first;
   ksim(eachvideo,3) = last;
   ksim(eachvideo,4) = eachvideo;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%               Code to return k most similar frame sequences                     %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ksim = sortrows(ksim,1);
disp('Most Matching Sequence in Descending order -');
for i = 1:str2double(k)
    eachvideo = ksim(i,4);
    first = ksim(i,2);
    last = ksim(i,3);
    dist = ksim(i,1);
    result = ['Video ',num2str(eachvideo),' with Frames ranging from :- ',num2str(first),' - ',num2str(last)];
    disp(result);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Code to visualise output                               %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VideoPath = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\InputVideo\';
VideoFiles = dir(fullfile(VideoPath,'*mp4'));
for i = 1:str2double(k)
    eachvideo = ksim(i,4);
    first = ksim(i,2);
    last = ksim(i,3);
    Video = VideoReader(fullfile(VideoPath,VideoFiles(eachvideo).name));
    FrameNo = 0;
    while hasFrame(Video)     
        FrameNo = FrameNo+1;
        FrameInRGB = readFrame(Video);
        Frame = rgb2gray(FrameInRGB);
        if(first <= FrameNo)&&(FrameNo <= last)
            imshow(Frame);
        end
    end
end