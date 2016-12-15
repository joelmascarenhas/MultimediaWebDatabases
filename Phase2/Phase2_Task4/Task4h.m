%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Video = input('Enter index of Video of input subsequence (V):- ','s');                
Frames = input('Enter Frame Range in the format - FirstFrame,LastFrame:- ','s');
FrameRange = str2double(strsplit(Frames,','));
k = input('Enter number of output Frame sequences required (k)','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase2_output\';
InputPathSift = fullfile(InputDir,'in_file_d.cpca');             

InputHist = fileread(InputPathSift);                 
AllVectorHist = strsplit(InputHist,'\n');
AllVectorHist = AllVectorHist';
lenVectorCountHist = size(AllVectorHist)-1;
InputMatrixHist = zeros(lenVectorCountHist(1),1);
lenEachVectorHist = 0;
for eachvectorHist = 1:lenVectorCountHist(1)
    eachVectorListHist = strsplit(char(AllVectorHist(eachvectorHist)),',');
    lenEachVectorHist = size(eachVectorListHist);
    for matrix = 1:lenEachVectorHist(2)
        value = eachVectorListHist{matrix};
        InputMatrixHist(eachvectorHist,matrix) = str2double(value);
    end
end

InputMatrixSizeHist = size(InputMatrixHist);
startVHist = 0;endVHist =0 ;
for vectorHist = 1:InputMatrixSizeHist(1)
    if (InputMatrixHist(vectorHist,1) == str2double(Video)) && ((InputMatrixHist(vectorHist,2) == FrameRange(1,1)))
        if(startVHist == 0)
            startVHist = vectorHist;
        end    
    end
    if (InputMatrixHist(vectorHist,1) == str2double(Video)) && ((InputMatrixHist(vectorHist,2) == (FrameRange(1,2) + 1)))
        if(endVHist == 0)
            endVHist = vectorHist - 1;
        end    
    end
end   

Matrix1Hist = InputMatrixHist(startVHist:endVHist,1:end);
TotalVideoHist = InputMatrixHist(InputMatrixSizeHist(1),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          HISTOGRAM COMPUTATION                                  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CovarianceMatrix = cov(InputMatrixHist(1:end,4:end));
InvCovarianceMatrix = pinv(CovarianceMatrix);
binlength = size(CovarianceMatrix);

ksimhist = zeros(TotalVideoHist,3);
for eachvideo = 1:TotalVideoHist
    startVHist = 0;countVHist = 0 ;
    for vectorHist = 1:InputMatrixSizeHist(1)
        if (InputMatrixHist(vectorHist,1) == eachvideo)
           if (startVHist == 0)
                startVHist = vectorHist;
           end 
           countVHist = countVHist + 1;
        end
    end  
    
    Matrix2Hist = InputMatrixHist(startVHist:(startVHist + countVHist - 1),1:end);
    lenSubSequenceHist = size(Matrix1Hist);
    SimilarityMatrixHist = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2Hist(countVHist,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    start = 1;cellno = 1;i = 1;j = 1;
    while (start < lenSubSequenceHist(1))
        for eachcellM1 = 1:Matrix1Hist(lenSubSequenceHist(1),3)
            cellvectorM1 = Matrix1Hist(start + eachcellM1 - 1,4:end);
            for eachcellM2 = 1:countVHist
                if (Matrix2Hist(eachcellM2,3) == eachcellM1)
                    cellvectorM2 = Matrix2Hist(eachcellM2,4:end);
                    
                    len = size(cellvectorM1);
                    sim = 0;max = -1;
                    for it = 1:len(2)
                        val=abs(cellvectorM1(it) - cellvectorM2(it));
                        if max<val
                            max=val;
                        end
                    end
                    SimilarityMatrixHist(i,j) = SimilarityMatrixHist(i,j) + max;
                    j = j + 1;
                end    
            end
            j = 1;
        end    
        start = start + Matrix1Hist(lenSubSequenceHist(1),3);
        i = i + 1;
    end
    SimilarityMatrixHist = SimilarityMatrixHist/Matrix1Hist(lenSubSequenceHist(1),3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSimHist = size(SimilarityMatrixHist);
    frameMatrixHist = zeros(1,sizeSimHist(1));
    minHist = 99999;runningsumHist = 0;
    for i = 1:sizeSimHist(1)
        minHist = 99999;
        for j = 1:sizeSimHist(2)
            if(any(frameMatrixHist == j))
               continue;
            else   
                if(i == 1) && (SimilarityMatrixHist(i,j) < minHist)
                    minHist = SimilarityMatrixHist(i,j);
                    framerefHist = j; 
                end
                sumh = 0;
                if(i ~= 1)
                    fmsh = size(frameMatrixHist);
                    sh = 1;
                    for qh = 1:i-1
                        sumh = sumh + SimilarityMatrixHist(sh,frameMatrixHist(1,qh));
                        sh = sh + 1;
                    end
                end
                sumh = sumh/(i-1);
                if((i ~= 1) && (abs(SimilarityMatrixHist(i,j) - sumh) < minHist))
                    minHist = abs(SimilarityMatrixHist(i,j) - sumh);
                    framerefHist = j; 
                end
            end    
        end
        runningsumHist = runningsumHist + SimilarityMatrixHist(i,framerefHist);
        frameMatrixHist(1,i) = framerefHist;
    end
    
   firstHist = 99999;lastHist = 1;
   lenframeMatrixHist = size(frameMatrixHist);
   for i = 1:lenframeMatrixHist(2)
      if(frameMatrixHist(1,i) > lastHist)
          lastHist = frameMatrixHist(1,i);
      end
      if(frameMatrixHist(1,i) < firstHist)
          firstHist = frameMatrixHist(1,i);
      end
   end 
   
   ksimhist(eachvideo,1) = runningsumHist/(FrameRange(2) - FrameRange(1));
   ksimhist(eachvideo,2) = firstHist;
   ksimhist(eachvideo,3) = lastHist;
   ksimhist(eachvideo,4) = eachvideo;   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          SIFT COMPUTATION                                       %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputPathSift = fullfile(InputDir,'in_file_d.spca');             
InputSift = fileread(InputPathSift);                 

AllVectorSift = strsplit(InputSift,'\n');
AllVectorSift = AllVectorSift';
lenVectorCountSift = size(AllVectorSift)-1;
InputMatrixSift = zeros(lenVectorCountSift(1),1);
lenEachVectorSift = 0;
for eachvectorSift = 1:lenVectorCountSift(1)
    eachVectorListSift = strsplit(char(AllVectorSift(eachvectorSift)),',');
    lenEachVectorSift = size(eachVectorListSift);
    for matrixSift = 1:lenEachVectorSift(2)
        valueSift = eachVectorListSift{matrixSift};
        InputMatrixSift(eachvectorSift,matrixSift) = str2double(valueSift);
    end
end

InputMatrixSize = size(InputMatrixSift);
startVSift = 0;endVSift =0 ;
for vectorSift = 1:InputMatrixSize(1)
    if (InputMatrixSift(vectorSift,1) == str2double(Video)) && ((InputMatrixSift(vectorSift,2) == FrameRange(1,1)))
        if(startVSift == 0)
            startVSift = vectorSift;
        end    
    end
    if (InputMatrixSift(vectorSift,1) == str2double(Video)) && ((InputMatrixSift(vectorSift,2) == (FrameRange(1,2) + 1)))
        if(endVSift == 0)
            endVSift = vectorSift - 1;
        end    
    end
end   

Matrix1Sift = InputMatrixSift(startVSift:endVSift,1:end);
TotalVideoSift = InputMatrixSift(InputMatrixSize(1),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Matrix1SizeSift = size(Matrix1Sift);
countV1Sift = Matrix1SizeSift(1);
countV2Sift = InputMatrixSize(1);

cellcountSift = Matrix1Sift(1, 3);
frameiterSift = 1;
framecountSift = Matrix1Sift(frameiterSift,2);
iter = 1;
celliter1 = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 1                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length1=size(Matrix1Sift);
Newmatrix1Sift = zeros((FrameRange(2)- FrameRange(1)+1),length1(2));
while ( Matrix1Sift(iter,2) == framecountSift)
    Newmatrix1Sift(celliter1,1) = Matrix1Sift(iter,1);
    Newmatrix1Sift(celliter1,2) = Matrix1Sift(iter,2);
    Newmatrix1Sift(celliter1,3) = Matrix1Sift(iter,3);
    cellcountSift = Matrix1Sift(iter,3);
    num_vect_sift = 0;
    while ( Matrix1Sift(iter,3) == cellcountSift )
        num_vect_sift = num_vect_sift +1;
        for iter2 = 4:length1(2)
            Newmatrix1Sift(celliter1,iter2)= Newmatrix1Sift(celliter1,iter2)+Matrix1Sift(iter,iter2);
        end
        if ( iter + 1 > countV1Sift )
            break;
        end
        iter = iter+1;
    end
 
    for iter2 = 4:length1(2)
        Newmatrix1Sift(celliter1,iter2)= Newmatrix1Sift(celliter1,iter2)/num_vect_sift;
    end 
    if (iter+1 > countV1Sift)
            break;
    end
    celliter1 = celliter1+1;
    framecountSift = Matrix1Sift(iter,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 2                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcountSift = InputMatrixSift(1, 3);
frameiterSift = 1;
framecountSift = InputMatrixSift(frameiterSift,2);
iter = 1;
celliter2 = 1;
Newmatrix2Sift = zeros((InputMatrixSift(countV2Sift,2))*InputMatrixSift(countV2Sift,3),length1(2));
while ( InputMatrixSift(iter,2) == framecountSift)
    Newmatrix2Sift(celliter2,1) = InputMatrixSift(iter,1);
    Newmatrix2Sift(celliter2,2) = InputMatrixSift(iter,2);
    Newmatrix2Sift(celliter2,3) = InputMatrixSift(iter,3);
    cellcountSift = InputMatrixSift(iter,3);
    num_vect_sift = 0;
    while ( InputMatrixSift(iter,3) == cellcountSift )
        num_vect_sift = num_vect_sift +1;
        for iter2 = 4:length1(2)
            Newmatrix2Sift(celliter2,iter2)= Newmatrix2Sift(celliter2,iter2)+ InputMatrixSift(iter,iter2);
        end
        if ( iter + 1 > countV2Sift )
            break;
        end
        iter = iter+1;
    end

    for iter2 = 4:length1(2)
        Newmatrix2Sift(celliter2,iter2)= Newmatrix2Sift(celliter2,iter2)/num_vect_sift;
    end     
    if (iter+1 > countV2Sift)
            break;
    end
    celliter2 = celliter2+1;
    framecountSift = InputMatrixSift(iter,2);
end  
NewInputMatrixSize = size(Newmatrix2Sift);

ksimsift = zeros(TotalVideoSift,3);
for eachvideosift = 1:TotalVideoSift
    startVSift = 0;countVSift = 0 ;
    for vectorSift = 1:NewInputMatrixSize(1)
        if (Newmatrix2Sift(vectorSift,1) == eachvideosift)
           if (startVSift == 0)
                startVSift = vectorSift;
           end 
           countVSift = countVSift + 1;
        end
    end  
    
    Matrix2Sift = Newmatrix2Sift(startVSift:(startVSift + countVSift - 1),1:end);
    lenSubSequenceSift = size(Newmatrix1Sift);
    SimilarityMatrixSift = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2Sift(countVSift,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    start = 1;i = 1;j = 1;p =1;
    while (start < lenSubSequenceSift(1))
            fr = Newmatrix1Sift(start +p - 1,2);
            while ((start + p -1) < lenSubSequenceSift(1))
                if (Newmatrix1Sift(start + p - 1,2) == fr)
                   p = p+1;
                else 
                    break;
                end   
            end    
            for eachcellM1Sift = 1:p-1
                cellvectorM1Sift = Newmatrix1Sift(start + eachcellM1Sift - 1,4:end);
                for eachcellM2Sift = 1:countVSift
                    if (Matrix2Sift(eachcellM2Sift,3) == eachcellM1Sift)
                        cellvectorM2Sift = Matrix2Sift(eachcellM2Sift,4:end);
                        len=size(cellvectorM1Sift);
                        sim=0;maxSift=-1;
                        for it=1:len(2)
                            val=abs(cellvectorM1Sift(it)-cellvectorM2Sift(it));
                            if maxSift<val
                                maxSift=val;
                            end
                        end
                        sim=sim+maxSift;
                        SimilarityMatrixSift(i,j) = SimilarityMatrixSift(i,j) + sim ;
                        j = j + 1;
                    end    
                end
                j = 1;
            end
        start = start + p - 1;
        p = 1;
        i = i + 1;   
    end
    SimilarityMatrixSift = SimilarityMatrixSift/4;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSim = size(SimilarityMatrixSift);
    frameMatrixSift = zeros(1,sizeSim(1));
    minSift = 99999;runningsumSift = 0;
    for i = 1:sizeSim(1)
        minSift = 99999;
        for j = 1:sizeSim(2)
            if(any(frameMatrixSift == j))
               continue;
            else   
                if(i == 1) && (SimilarityMatrixSift(i,j) < minSift)
                    minSift = SimilarityMatrixSift(i,j);
                    framerefSift = j; 
                end
                sums = 0;
                if(i ~= 1)
                    fmsh = size(frameMatrixSift);
                    sh = 1;
                    for qh = 1:i-1
                        sums = sums + SimilarityMatrixSift(sh,frameMatrixSift(1,qh));
                        sh = sh + 1;
                    end
                end
                sums = sums/(i-1);
                if((i ~= 1) && (abs(SimilarityMatrixSift(i,j) - sums) < minSift))
                    minSift = abs(SimilarityMatrixSift(i,j) - sums);
                    framerefSift = j; 
                end
            end    
        end
        runningsumSift = runningsumSift + SimilarityMatrixSift(i,framerefSift);
        frameMatrixSift(1,i) = framerefSift;
    end 

   firstSift = 99999;lastSift = 1;
   lenframeMatrixSift = size(frameMatrixSift);
   for i = 1:lenframeMatrixSift(2)
      if(frameMatrixSift(1,i) > lastSift)
          lastSift = frameMatrixSift(1,i);
      end
      if(frameMatrixSift(1,i) < firstSift)
          firstSift = frameMatrixSift(1,i);
      end
   end 
   
   ksimsift(eachvideosift,1) = runningsumSift/(FrameRange(2) - FrameRange(1));
   ksimsift(eachvideosift,2) = firstSift;
   ksimsift(eachvideosift,3) = lastSift;
   ksimsift(eachvideosift,4) = eachvideosift;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                        MOTION VECTOR COMPUTATION                                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputPathmvect = fullfile(InputDir,'in_file_d.mpca');             
Inputmvect = fileread(InputPathmvect);                 

AllVectormvect = strsplit(Inputmvect,'\n');
AllVectormvect = AllVectormvect';
lenVectorCountmvect = size(AllVectormvect)-1;
InputMatrixmvect = zeros(lenVectorCountmvect(1),1);
lenEachVectormvect = 0;
for eachvectormvect = 1:lenVectorCountmvect(1)
    eachVectorListmvect = strsplit(char(AllVectormvect(eachvectormvect)),',');
    lenEachVectormvect = size(eachVectorListmvect);
    for matrixmvect = 1:lenEachVectormvect(2)
        valuemvect = eachVectorListmvect{matrixmvect};
        InputMatrixmvect(eachvectormvect,matrixmvect) = str2double(valuemvect);
    end
end

InputMatrixSizemvect = size(InputMatrixmvect);
startVmvect = 0;endVmvect =0 ;
for vectormvect = 1:InputMatrixSizemvect(1)
    if (InputMatrixmvect(vectormvect,1) == str2double(Video)) && ((InputMatrixmvect(vectormvect,2) == FrameRange(1,1)))
        if(startVmvect == 0)
            startVmvect = vectormvect;
        end    
    end
    if (InputMatrixmvect(vectormvect,1) == str2double(Video)) && ((InputMatrixmvect(vectormvect,2) == (FrameRange(1,2) + 1)))
        if(endVmvect == 0)
            endVmvect = vectormvect - 1;
        end    
    end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Matrix1mvect = InputMatrixmvect(startVmvect:endVmvect,1:end);
lengthmvect=size(Matrix1mvect);
i=(FrameRange(2)-FrameRange(1))*(Matrix1mvect(lengthmvect(1),3));
Mat1mvect=zeros(i,lengthmvect(2));
frame_it=1;
frame_no_mvect=Matrix1mvect(frame_it,2);
it=1;
cell_it=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (Matrix1mvect(it,2)==frame_no_mvect)
    Mat1mvect(cell_it,1)=Matrix1mvect(it,1);
    Mat1mvect(cell_it,2)=Matrix1mvect(it,2);
    Mat1mvect(cell_it,3)=Matrix1mvect(it,3);
    cell_num=Matrix1mvect(it,3);
    num_vec_mvect=0;
    while (Matrix1mvect(it,3)==cell_num)
        num_vec_mvect=num_vec_mvect+1;
        for it2=4:lengthmvect(2)            
            Mat1mvect(cell_it,it2)=Mat1mvect(cell_it,it2)+Matrix1mvect(it,it2);
        end
        if (it+1 > lengthmvect(1))
            break;
        end
        it=it+1;
    end
    for it2=5:lengthmvect(2)
        x=Mat1mvect(cell_it,it2);
        Mat1mvect(cell_it,it2)=x/num_vec_mvect;
    end
    
    if (it+1 >lengthmvect(1))
            break;
    end
    cell_it=cell_it+1;
    frame_no_mvect=Matrix1mvect(it,2);
end
Matrix1mvect=Mat1mvect;
TotalVideomvect = InputMatrixmvect(InputMatrixSizemvect(1),1);

ksimmvect = zeros(TotalVideomvect,3);
for eachvideomvect = 1:TotalVideomvect
    startVmvect = 0;countVmvect = 0 ;
    for vectormvect = 1:InputMatrixSizemvect(1)
        if (InputMatrixmvect(vectormvect,1) == eachvideomvect)
           if (startVmvect == 0)
                startVmvect = vectormvect;
           end 
           countVmvect = countVmvect + 1;
        end
    end  
    
    Matrix2mvect = InputMatrixmvect(startVmvect:(startVmvect + countVmvect - 1),1:end);
    lengthmvect=size(Matrix2mvect);
    Mat2mvect=zeros(Matrix2mvect(lengthmvect(1),3)*Matrix2mvect(lengthmvect(1),3),lengthmvect(2));
    frame_it=1;
    frame_no_mvect=Matrix2mvect(frame_it,2);
    it=1;
    cell_it=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    while (Matrix2mvect(it,2)==frame_no_mvect)
        Mat2mvect(cell_it,1)=Matrix2mvect(it,1);
        Mat2mvect(cell_it,2)=Matrix2mvect(it,2);
        Mat2mvect(cell_it,3)=Matrix2mvect(it,3);
        cell_num=Matrix2mvect(it,3);
        num_vec_mvect=0;
        while (Matrix2mvect(it,3)==cell_num)
            num_vec_mvect=num_vec_mvect+1;
            for it2=4:lengthmvect(2)            
                Mat2mvect(cell_it,it2)=Mat2mvect(cell_it,it2)+Matrix2mvect(it,it2);
            end
            if (it+1 > lengthmvect(1))
                break;
            end
            it=it+1;
        end
        for it2=5:lengthmvect(2)
            x=Mat2mvect(cell_it,it2);
            Mat2mvect(cell_it,it2)=x/num_vec_mvect;
        end
        if (it+1 >lengthmvect(1))
                break;
        end
        cell_it=cell_it+1;
        frame_no_mvect=Matrix2mvect(it,2);
    end
    Matrix2mvect=Mat2mvect;
    lenSubSequencemvect = size(Matrix1mvect);
    lenVideomvect=size(Matrix2mvect);
    SimilarityMatrixmvect = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2mvect(lenVideomvect(1),2)-1);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    start = 1;i = 1;j = 1;
    while (start < lenSubSequencemvect(1))
        for eachcellM1 = 1:Matrix1mvect(lenSubSequencemvect(1),3)
            cellvectorM1 = Matrix1mvect(start + eachcellM1 - 1,5:end);
            for eachcellM2 = 1:lenVideomvect
                if (Matrix2mvect(eachcellM2,3) == eachcellM1)
                    cellvectorM2 = Matrix2mvect(eachcellM2,5:end);
                    sim = 0;
                    len=size(cellvectorM1);
                    for it=5:len(2)
                        sim=sim+abs(cellvectorM1(it)-cellvectorM2(it));
                    end
                    SimilarityMatrixmvect(i,j) = SimilarityMatrixmvect(i,j) + sim;
                    j = j + 1;
                end    
            end
            j = 1;
        end    
        start = start + Matrix1mvect(lenSubSequencemvect(1),3);
        i = i + 1;
    end
    append_matrix=zeros(i-1,1);
    append_matrix=append_matrix+9999;
    Sim_mat=horzcat(append_matrix,SimilarityMatrixmvect);
    SimilarityMatrixmvect=Sim_mat/Matrix1mvect(lenSubSequencemvect(1),3);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSimmvect = size(SimilarityMatrixmvect);
    frameMatrixmvect = zeros(1,sizeSimmvect(1));
    minmvect = 99999;runningsummvect = 0;
    for i = 1:sizeSimmvect(1)
        minmvect = 99999;
        for j = 1:sizeSimmvect(2)
            if(any(frameMatrixmvect == j))
               continue;
            else   
                if(i == 1) && (SimilarityMatrixmvect(i,j) < minmvect)
                    minmvect = SimilarityMatrixmvect(i,j);
                    framerefmvect = j; 
                end
                summ = 0;
                if(i ~= 1)
                    fmsh = size(frameMatrixmvect);
                    sh = 1;
                    for qh = 1:i-1
                        summ = summ + SimilarityMatrixmvect(sh,frameMatrixmvect(1,qh));
                        sh = sh + 1;
                    end
                end
                summ = summ/(i-1);
                if((i ~= 1) && (abs(SimilarityMatrixmvect(i,j) - summ) < minmvect))
                    minmvect = abs(SimilarityMatrixmvect(i,j) - summ);
                    framerefmvect = j; 
                end
            end    
        end
        runningsummvect = runningsummvect + SimilarityMatrixmvect(i,framerefmvect);
        frameMatrixmvect(1,i) = framerefmvect;
    end
    
   firstmvect = 99999;lastmvect = 1;
   lenframeMatrixmvect = size(frameMatrixmvect);
   for i = 1:lenframeMatrixmvect(2)
      if(frameMatrixmvect(1,i) > lastmvect)
          lastmvect = frameMatrixmvect(1,i);
      end
      if(frameMatrixmvect(1,i) < firstmvect)
          firstmvect = frameMatrixmvect(1,i);
      end
   end 
   
   ksimmvect(eachvideomvect,1) = runningsummvect/(FrameRange(2) - FrameRange(1));
   ksimmvect(eachvideomvect,2) = firstmvect;
   ksimmvect(eachvideomvect,3) = lastmvect;
   ksimmvect(eachvideomvect,4) = eachvideomvect; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Code to find k most similar                            %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kscSize = size( ksimhist );
kscUlt = zeros(kscSize(1),kscSize(2));
for ik = 1:kscSize(1)
    if((ksimhist(ik,1) == 0) || (ksimmvect(ik,1) == 0) || (ksimsift(ik,1) == 0))
        flagh = 0;flags = 0;flagm = 0;
        if((ksimhist(ik,1) == 0))
            histdist = 0;
            flagh = 1;
        end
        if((ksimsift(ik,1) == 0))
            siftdist = 0;
            flags = 1;
        end
        if((ksimmvect(ik,1) == 0))
            mvectdist = 0;
            flagm = 1;
        end
        if(flagh == 0)
            histdist = (1 - abs(1/ksimhist(ik,1)));
        end 
        if(flags == 0)
            siftdist = (1 - abs(1/ksimsift(ik,1)));
        end 
        if(flagm == 0)
            mvectdist = (1 - abs(1/ksimmvect(ik,1)));
        end 
               
        kscdist = ((histdist + mvectdist + siftdist)/3)*100;
        
        histstart = ksimhist(ik,2);
        siftstart = ksimsift(ik,2);
        mvectstart = ksimmvect(ik,2);
        kscstart = ceil((histstart + mvectstart + siftstart)/3);
    
        histend = ksimhist(ik,3);
        siftend = ksimsift(ik,3);
        mvectend = ksimmvect(ik,3);
        kscend = floor((histend + mvectend + siftend)/3);
        
        kscUlt(ik,1) = kscdist;
        kscUlt(ik,2) = kscstart;
        kscUlt(ik,3) = kscend;
        kscUlt(ik,4) = ik;
        if(ik == Video)
            kscUlt(ik,1) = 0;
            kscUlt(ik,2) = ksimhist(ik,2);
            kscUlt(ik,3) = ksimhist(ik,3);
            kscUlt(ik,4) = ik;
        end
    else
        histdist = (1 - abs(1/ksimhist(ik,1)));
        siftdist = (1 - abs(1/ksimsift(ik,1)));
        mvectdist = (1 - abs(1/ksimmvect(ik,1)));
        
        kscdist = ((histdist + mvectdist + siftdist)/3)*100;
        
        histstart = ksimhist(ik,2);
        siftstart = ksimsift(ik,2);
        mvectstart = ksimmvect(ik,2);
        kscstart = ceil((histstart + mvectstart + siftstart)/3);
    
        histend = ksimhist(ik,3);
        siftend = ksimsift(ik,3);
        mvectend = ksimmvect(ik,3);
        kscend = floor((histend + mvectend + siftend)/3);
        
        kscUlt(ik,1) = kscdist;
        kscUlt(ik,2) = kscstart;
        kscUlt(ik,3) = kscend;
        kscUlt(ik,4) = ik;
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%               Code to return k most similar frame sequences                     %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kscUlt = sortrows(kscUlt,1);
disp('Most Matching Sequence in Descending order -');
for ikc = 1:str2double(k)
    eachvideoK = kscUlt(ikc,4);
    firstK = kscUlt(ikc,2);
    lastK = kscUlt(ikc,3);
    distK = kscUlt(ikc,1);
    result = ['Video ',num2str(eachvideoK),' with Frames ranging from :- ',num2str(firstK),' - ',num2str(lastK)];
    disp(result);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Code to visualise output                               %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VideoPath = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\InputVideo\';
VideoFiles = dir(fullfile(VideoPath,'*mp4'));
for i = 1:str2double(k)
    eachvideo = kscUlt(i,4);
    first = kscUlt(i,2);
    last = kscUlt(i,3);
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
