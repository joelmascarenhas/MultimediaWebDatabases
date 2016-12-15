%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VideoNo = input('Enter index of Video of input subsequence (V):- ','s');                
Frames = input('Enter Frame Range in the format - FirstFrame,LastFrame:- ','s');
FrameRange = str2double(strsplit(Frames,','));
k = input('Enter number of output Frame sequences required (k)','s'); 
 
InputDirHist = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase2_output\';                    %PATH TO BE CHANGED
InputPathHist = fullfile(InputDirHist,'in_file_d.cpca');             

InputHist = fileread(InputPathHist);                 
AllVectorHist = strsplit(InputHist,'\n');
AllVectorHist = AllVectorHist';
lenVectorCountHist = size(AllVectorHist)-1;
InputMatrixHist = zeros(lenVectorCountHist(1),1);
lenEachVectorHist = 0;
for eachvectorHist = 1:lenVectorCountHist(1)
    eachVectorListHist = strsplit(char(AllVectorHist(eachvectorHist)),',');
    lenEachVectorHist = size(eachVectorListHist);
    for matrixHist = 1:lenEachVectorHist(2)
        valueHist = eachVectorListHist{matrixHist};
        InputMatrixHist(eachvectorHist,matrixHist) = str2double(valueHist);
    end
end

InputMatrixSizeHist = size(InputMatrixHist);
startVh = 0;endVh =0 ;
for vectorHist = 1:InputMatrixSizeHist(1)
    if (InputMatrixHist(vectorHist,1) == str2double(VideoNo)) && ((InputMatrixHist(vectorHist,2) == FrameRange(1,1)))
        if(startVh == 0)
            startVh = vectorHist;
        end    
    end
    if (InputMatrixHist(vectorHist,1) == str2double(VideoNo)) && ((InputMatrixHist(vectorHist,2) == (FrameRange(1,2) + 1)))
        if(endVh == 0)
            endVh = vectorHist - 1;
        end    
    end
end   

Matrix1Hist = InputMatrixHist(startVh:endVh,1:end);
TotalVideoHist = InputMatrixHist(InputMatrixSizeHist(1),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          HISTOGRAM COMPUTATION                                       %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ksimh = zeros(TotalVideoHist,3);
for eachvideoh = 1:TotalVideoHist
    startVh = 0;countVh = 0 ;
    for vectorHist = 1:InputMatrixSizeHist(1)
        if (InputMatrixHist(vectorHist,1) == eachvideoh)
           if (startVh == 0)
                startVh = vectorHist;
           end 
           countVh = countVh + 1;
        end
    end  
    
    Matrix2Hist = InputMatrixHist(startVh:(startVh + countVh - 1),1:end);
    lenSubSequenceh = size(Matrix1Hist);
    SimilarityMatrixHist = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2Hist(countVh,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    starth = 1;ih = 1;jh = 1;
    while (starth < lenSubSequenceh(1))
        for eachcellM1h = 1:Matrix1Hist(lenSubSequenceh(1),3)
            cellvectorM1h = Matrix1Hist(starth + eachcellM1h - 1,4:end);
            for eachcellM2h = 1:countVh
                if (Matrix2Hist(eachcellM2h,3) == eachcellM1h)
                    cellvectorM2m = Matrix2Hist(eachcellM2h,4:end);
                    lenh = size(cellvectorM1h);
                    simh = 0;tot_simh = 0;
                    for ith = 1:lenh(2)
                        diffh = cellvectorM1h(ith) - cellvectorM2m(ith);
                        simh = simh +(diffh * diffh);
                    end
                    SimilarityMatrixHist(ih,jh) = SimilarityMatrixHist(ih,jh) + sqrt(simh);
                    jh = jh + 1;
                end    
            end
            jh = 1;
        end    
        starth = starth + Matrix1Hist(lenSubSequenceh(1),3);
        ih = ih + 1;
    end
    SimilarityMatrixHist = SimilarityMatrixHist/Matrix1Hist(lenSubSequenceh(1),3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSimh = size(SimilarityMatrixHist);
    frameMatrixHist = zeros(1,sizeSimh(1));
    minh = 99999;runningsumh = 0;
    for ih = 1:sizeSimh(1)
        minh = 99999;
        for jh = 1:sizeSimh(2)
            if(any(frameMatrixHist == jh))
               continue;
            else   
                if(ih == 1) && (SimilarityMatrixHist(ih,jh) < minh)
                    minh = SimilarityMatrixHist(ih,jh);
                    framerefh = jh; 
                end
                sumh = 0;
                if(ih ~=1)
                    fmsh = size(frameMatrixHist);
                    sh = 1;
                    for qh = 1:ih-1
                        sumh = sumh + SimilarityMatrixHist(sh,frameMatrixHist(1,qh));
                        sh = sh + 1;
                    end
                end
                sumh = sumh/(ih-1);
                if((ih ~= 1) && (abs(SimilarityMatrixHist(ih,jh) - sumh) < minh))
                    minh = abs(SimilarityMatrixHist(ih,jh) - sumh);
                    framerefh = jh; 
                end
            end    
        end
        runningsumh = runningsumh + SimilarityMatrixHist(ih,framerefh);
        frameMatrixHist(1,ih) = framerefh;
    end
    
   firsth = 99999;lasth = 1;
   lenframeMatrixh = size(frameMatrixHist);
   for ih = 1:lenframeMatrixh(2)
      if(frameMatrixHist(1,ih) > lasth)
          lasth = frameMatrixHist(1,ih);
      end
      if(frameMatrixHist(1,ih) < firsth)
          firsth = frameMatrixHist(1,ih);
      end
   end 

   ksimh(eachvideoh,1) = runningsumh/(FrameRange(2) - FrameRange(1));
   ksimh(eachvideoh,2) = firsth;
   ksimh(eachvideoh,3) = lasth;
   ksimh(eachvideoh,4) = eachvideoh; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%               Code to return k most similar frame sequences                     %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ih = 1:str2double(k)
    eachvideoh = ksimh(ih,4);
    firsth = ksimh(ih,2);
    lasth = ksimh(ih,3);
    dist = ksimh(ih,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                          SIFT COMPUTATION                                       %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase2_output\';                    %PATH TO BE CHANGED
InputPathSift = fullfile(InputDir,'in_file_d.spca');             

InputSift = fileread(InputPathSift);                 
AllVectorSift = strsplit(InputSift,'\n');
AllVectorSift = AllVectorSift';
lenVectorCountSift = size(AllVectorSift)-1;
InputMatrixSift = zeros(lenVectorCountSift(1),1);
lenEachVectorSift = 0;
for eachvectorS = 1:lenVectorCountSift(1)
    eachVectorListS = strsplit(char(AllVectorSift(eachvectorS)),',');
    lenEachVectorSift = size(eachVectorListS);
    for matrixS = 1:lenEachVectorSift(2)
        valueS = eachVectorListS{matrixS};
        InputMatrixSift(eachvectorS,matrixS) = str2double(valueS);
    end
end

InputMatrixSizeSift = size(InputMatrixSift);
startVs = 0;endVs =0 ;
for vectorS = 1:InputMatrixSizeSift(1)
    if (InputMatrixSift(vectorS,1) == str2double(VideoNo)) && ((InputMatrixSift(vectorS,2) == FrameRange(1,1)))
        if(startVs == 0)
            startVs = vectorS;
        end    
    end
    if (InputMatrixSift(vectorS,1) == str2double(VideoNo)) && ((InputMatrixSift(vectorS,2) == (FrameRange(1,2) + 1)))
        if(endVs == 0)
            endVs = vectorS - 1;
        end    
    end
end   

Matrix1Sift = InputMatrixSift(startVs:endVs,1:end);
TotalVideoSift = InputMatrixSift(InputMatrixSizeSift(1),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Matrix1SizeMV = size(Matrix1Sift);
countV1s = Matrix1SizeMV(1);
countV2s = InputMatrixSizeSift(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 1                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcountS = Matrix1Sift(1,3);
frameiterS = 1;
framecountS = Matrix1Sift(frameiterS,2);
iterS = 1;
celliter1S = 1;
ikdim = size(Matrix1Sift);
kdim = ikdim(2);
Newmatrix1S = zeros((FrameRange(2)- FrameRange(1)+1),kdim);
while ( Matrix1Sift(iterS,2) == framecountS)
    Newmatrix1S(celliter1S,1) = Matrix1Sift(iterS,1);
    Newmatrix1S(celliter1S,2) = Matrix1Sift(iterS,2);
    Newmatrix1S(celliter1S,3) = Matrix1Sift(iterS,3);
    cellcountS = Matrix1Sift(iterS,3);
    num_vectS = 0;
    while ( Matrix1Sift(iterS,3) == cellcountS )
        num_vectS = num_vectS +1;
        for iter2S = 4:kdim
            Newmatrix1S(celliter1S,iter2S)= Newmatrix1S(celliter1S,iter2S)+Matrix1Sift(iterS,iter2S);
        end
        if ( iterS + 1 > countV1s )
            break;
        end
        iterS = iterS+1;
    end
    
    for iter2S = 4:kdim
        Newmatrix1S(celliter1S,iter2S)= Newmatrix1S(celliter1S,iter2S)/num_vectS;
    end 
    if (iterS+1 > countV1s)
            break;
    end
    celliter1S = celliter1S+1;
    framecountS = Matrix1Sift(iterS,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n SIFT Vectors to 1 per cell in Video 2                   %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcountS = InputMatrixSift(1,3);
frameiterS = 1;
framecountS = InputMatrixSift(frameiterS,2);
iterS = 1;
celliter2S = 1;
Newmatrix2Sift = zeros((InputMatrixSift(countV2s,2))*InputMatrixSift(countV2s,3),kdim);
while ( InputMatrixSift(iterS,2) == framecountS)
    Newmatrix2Sift(celliter2S,1) = InputMatrixSift(iterS,1);
    Newmatrix2Sift(celliter2S,2) = InputMatrixSift(iterS,2);
    Newmatrix2Sift(celliter2S,3) = InputMatrixSift(iterS,3);
    cellcountS = InputMatrixSift(iterS,3);
    num_vectS = 0;
    while ( InputMatrixSift(iterS,3) == cellcountS )
        num_vectS = num_vectS +1;
        for iter2S = 4:kdim
            Newmatrix2Sift(celliter2S,iter2S)= Newmatrix2Sift(celliter2S,iter2S)+ InputMatrixSift(iterS,iter2S);
        end
        if ( iterS + 1 > countV2s )
            break;
        end
        iterS = iterS+1;
    end

    for iter2S = 4:kdim
        Newmatrix2Sift(celliter2S,iter2S)= Newmatrix2Sift(celliter2S,iter2S)/num_vectS;
    end     
    if (iterS+1 > countV2s)
            break;
    end
    celliter2S = celliter2S+1;
    framecountS = InputMatrixSift(iterS,2);
end  
NewInputMatrixSizeSift = size(Newmatrix2Sift);

ksimS = zeros(TotalVideoSift,3);
for eachvideoS = 1:TotalVideoSift
    startVs = 0;countVs = 0 ;
    for vectorS = 1:NewInputMatrixSizeSift(1)
        if (Newmatrix2Sift(vectorS,1) == eachvideoS)
           if (startVs == 0)
                startVs = vectorS;
           end 
           countVs = countVs + 1;
        end
    end  
    
    Matrix2Sift = Newmatrix2Sift(startVs:(startVs + countVs - 1),1:end);
    lenSubSequenceSift = size(Newmatrix1S);
    SimilarityMatrixSift = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2Sift(countVs,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    startS = 1;is = 1;js = 1;ps =1;
    while (startS < lenSubSequenceSift(1))
            frs = Newmatrix1S(startS +ps - 1,2);
            while ((startS + ps -1) < lenSubSequenceSift(1))
                if (Newmatrix1S((startS + ps - 1),2) == frs)
                   ps = ps+1;
                else 
                    break;
                end   
            end    
            for eachcellM1S = 1:ps-1
                cellvectorM1S = Newmatrix1S(startS + eachcellM1S - 1,4:end);
                for eachcellM2S = 1:countVs
                    if (Matrix2Sift(eachcellM2S,3) == eachcellM1S)
                        cellvectorM2m = Matrix2Sift(eachcellM2S,4:end);
                        lenS = size(cellvectorM1S);
                        simS = 0;tot_simS = 0;
                        for itS = 1:lenS(2)
                         diffS = cellvectorM1S(itS) - cellvectorM2m(itS);
                         simS = simS +(diffS * diffS);
                        end
                        SimilarityMatrixSift(is,js) = SimilarityMatrixSift(is,js) + sqrt(simS);
                        js = js + 1;
                    end    
                end
                js = 1;
            end
        startS = startS + ps - 1;
        ps = 1;
        is = is + 1;   
    end
    SimilarityMatrixSift = SimilarityMatrixSift/4;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSimM = size(SimilarityMatrixSift);
    frameMatrixSift = zeros(1,sizeSimM(1));
    minS = 99999;runningsumS = 0;
    for is = 1:sizeSimM(1)
        minS = 99999;
        for js = 1:sizeSimM(2)
            if(any(frameMatrixSift == js))
               continue;
            else   
                if(is == 1) && (SimilarityMatrixSift(is,js) < minS)
                    minS = SimilarityMatrixSift(is,js);
                    framerefS = js; 
                end
                sumn = 0;
                if(is ~= 1)
                    fms = size(frameMatrixSift);
                    ss = 1;
                    for qs = 1:is-1
                        sumn = sumn + SimilarityMatrixSift(ss,frameMatrixSift(1,qs));
                        ss = ss + 1;
                    end
                end
                sumn = sumn/(is - 1);
                if((is ~= 1) && (abs(SimilarityMatrixSift(is,js) - sumn) < minS))
                    minS = abs(SimilarityMatrixSift(is,js) - sumn);
                    framerefS = js; 
                end
            end    
        end
        runningsumS = runningsumS + SimilarityMatrixSift(is,framerefS);
        frameMatrixSift(1,is) = framerefS;
    end 

   firstS = 99999;lastS = 1;
   lenframeMatrixS = size(frameMatrixSift);
   for is = 1:lenframeMatrixS(2)
      if(frameMatrixSift(1,is) > lastS)
          lastS = frameMatrixSift(1,is);
      end
      if(frameMatrixSift(1,is) < firstS)
          firstS = frameMatrixSift(1,is);
      end
   end 
   
   ksimS(eachvideoS,1) = runningsumS/(FrameRange(2) - FrameRange(1));
   ksimS(eachvideoS,2) = firstS;
   ksimS(eachvideoS,3) = lastS;
   ksimS(eachvideoS,4) = eachvideoS;
end

for is = 1:str2double(k)
    eachvideoS = ksimS(is,4);
    firstS = ksimS(is,2);
    lastS = ksimS(is,3);
    dist = ksimS(is,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                        MOTION VECTOR COMPUTATION                                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase2_output\';                    %PATH TO BE CHANGED
InputPathMV = fullfile(InputDir,'in_file_d.mpca');             

InputMV = fileread(InputPathMV);                 
AllVectorMV = strsplit(InputMV,'\n');
AllVectorMV = AllVectorMV';
lenVectorCountMV = size(AllVectorMV)-1;
InputMatrixMV = zeros(lenVectorCountMV(1),1);
lenEachVectorMV = 0;
for eachvectormv = 1:lenVectorCountMV(1)
    eachVectorListmv = strsplit(char(AllVectorMV(eachvectormv)),',');
    lenEachVectorMV = size(eachVectorListmv);
    for matrixmv = 1:lenEachVectorMV(2)
        valuemv = eachVectorListmv{matrixmv};
        InputMatrixMV(eachvectormv,matrixmv) = str2double(valuemv);
    end
end

InputMatrixSizeMV = size(InputMatrixMV);
startVm = 0;endVm =0 ;
for vectorm = 1:InputMatrixSizeMV(1)
    if (InputMatrixMV(vectorm,1) == str2double(VideoNo)) && ((InputMatrixMV(vectorm,2) == FrameRange(1,1)))
        if(startVm == 0)
            startVm = vectorm;
        end    
    end
    if (InputMatrixMV(vectorm,1) == str2double(VideoNo)) && ((InputMatrixMV(vectorm,2) == (FrameRange(1,2) + 1)))
        if(endVm == 0)
            endVm = vectorm - 1;
        end    
    end
end   

Matrix1Mvect = InputMatrixMV(startVm:endVm,1:end);
TotalVideoMvect = InputMatrixMV(InputMatrixSizeMV(1),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Matrix1SizeMV = size(Matrix1Mvect);
countV1m = Matrix1SizeMV(1);
countV2m = InputMatrixSizeMV(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellcountm = Matrix1Mvect(1, 3);
frameiterM = 1;
framecountM = Matrix1Mvect(frameiterM,2);
iterm = 1;
celliter1m = 1;
len=size(Matrix1Mvect);
Newmatrix1Mvect = zeros((FrameRange(2)- FrameRange(1)+1),len(2));
while ( Matrix1Mvect(iterm,2) == framecountM)
    Newmatrix1Mvect(celliter1m,1) = Matrix1Mvect(iterm,1);
    Newmatrix1Mvect(celliter1m,2) = Matrix1Mvect(iterm,2);
    Newmatrix1Mvect(celliter1m,3) = Matrix1Mvect(iterm,3);
    cellcountm = Matrix1Mvect(iterm,3);
    num_vectm = 0;
    while ( Matrix1Mvect(iterm,3) == cellcountm )
        num_vectm = num_vectm +1;
        for iter2m = 4:len(2)
            Newmatrix1Mvect(celliter1m,iter2m)= Newmatrix1Mvect(celliter1m,iter2m)+Matrix1Mvect(iterm,iter2m);
        end
        if ( iterm + 1 > countV1m )
            break;
        end
        iterm = iterm+1;
    end
    for iter2m = 4:len(2)
        Newmatrix1Mvect(celliter1m,iter2m)= Newmatrix1Mvect(celliter1m,iter2m)/num_vectm;
    end 
    if (iterm+1 > countV1m)
            break;
    end
    celliter1m = celliter1m+1;
    framecountM = Matrix1Mvect(iterm,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 2                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cellcountm = InputMatrixMV(1, 3);
frameiterM = 1;
framecountM = InputMatrixMV(frameiterM,2);
iterm = 1;
celliter2m = 1;
Newmatrix2Mvect = zeros((InputMatrixMV(countV2m,2))*InputMatrixMV(countV2m,3),len(2));
while ( InputMatrixMV(iterm,2) == framecountM)
    Newmatrix2Mvect(celliter2m,1) = InputMatrixMV(iterm,1);
    Newmatrix2Mvect(celliter2m,2) = InputMatrixMV(iterm,2);
    Newmatrix2Mvect(celliter2m,3) = InputMatrixMV(iterm,3);
    cellcountm = InputMatrixMV(iterm,3);
    num_vectm = 0;
    while ( InputMatrixMV(iterm,3) == cellcountm )
        num_vectm = num_vectm +1;
        for iter2m = 4:len(2)
            Newmatrix2Mvect(celliter2m,iter2m)= Newmatrix2Mvect(celliter2m,iter2m)+ InputMatrixMV(iterm,iter2m);
        end
        if ( iterm + 1 > countV2m )
            break;
        end
        iterm = iterm+1;
    end
    for iter2m = 4:len(2)
        Newmatrix2Mvect(celliter2m,iter2m)= Newmatrix2Mvect(celliter2m,iter2m)/num_vectm;
    end     
    if (iterm+1 > countV2m)
            break;
    end
    celliter2m = celliter2m+1;
    framecountM = InputMatrixMV(iterm,2);
end  
NewInputMatrixSizeMvect = size(Newmatrix2Mvect);

ksimm = zeros(TotalVideoMvect,3);
for eachvideom = 1:TotalVideoMvect
    startVm = 0;countVm = 0 ;
    for vectorm = 1:NewInputMatrixSizeMvect(1)
        if (Newmatrix2Mvect(vectorm,1) == eachvideom)
           if (startVm == 0)
                startVm = vectorm;
           end 
           countVm = countVm + 1;
        end
    end  
    
    Matrix2Mvect = Newmatrix2Mvect(startVm:(startVm + countVm - 1),1:end);
    lenSubSequenceM = size(Newmatrix1Mvect);
    SimilarityMatrixMvect = zeros(FrameRange(2)-FrameRange(1)+ 1,Matrix2Mvect(countVm,2)- 1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Generate Similarity Matrix for the subsequence and each Video         %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    startm = 1;im = 1;jm = 1;pm =1;
    while (startm < lenSubSequenceM(1))
            frm = Newmatrix1Mvect(startm +pm - 1,2);
            while ((startm + pm -1) < lenSubSequenceM(1))
                if (Newmatrix1Mvect(startm + pm - 1,2) == frm)
                   pm = pm+1;
                else 
                    break;
                end   
            end    
            for eachcellM1m = 1:pm-1
                cellvectorM1m = Newmatrix1Mvect(startm + eachcellM1m - 1,4:end);
                for eachcellM2m = 1:countVm
                    if (Matrix2Mvect(eachcellM2m,3) == eachcellM1m)
                        cellvectorM2m = Matrix2Mvect(eachcellM2m,4:end);
                        lenm = size(cellvectorM1m);
                        simm = 0;tot_simm = 0;
                        for itm = 1:lenm(2)
                         diffm = cellvectorM1m(itm) - cellvectorM2m(itm);
                         simm = simm +(diffm * diffm);
                        end
                        SimilarityMatrixMvect(im,jm) = SimilarityMatrixMvect(im,jm) + sqrt(simm);
                        jm = jm + 1;
                    end    
                end
                jm = 1;
            end
        startm = startm + pm - 1;
        pm = 1;
        im = im + 1;   
    end
    SimilarityMatrixMvect = SimilarityMatrixMvect/4;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%           Computation of Least Computation Subsequence for a given video        %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sizeSimM = size(SimilarityMatrixMvect);
    frameMatrixMvect = zeros(1,sizeSimM(1));
    minM = 99999;runningsumM = 0;
    for im = 1:sizeSimM(1)
        minM = 99999;
        for jm = 1:sizeSimM(2)
            if(any(frameMatrixMvect == jm))
               continue;
            else   
                if(im == 1) && (SimilarityMatrixMvect(im,jm) < minM)
                    minM = SimilarityMatrixMvect(im,jm);
                    framerefm = jm; 
                end
                sumn = 0;
                if(im ~=1)
                    fms = size(frameMatrixMvect);
                    ss = 1;
                    for qs = 1:im-1
                        sumn = sumn + SimilarityMatrixMvect(ss,frameMatrixMvect(1,qs));
                        ss = ss + 1;
                    end
                end
                sumn = sumn/(im-1);
                if((im ~= 1) && (abs(SimilarityMatrixMvect(im,jm) - sumn) < minM))
                    minM = abs(SimilarityMatrixMvect(im,jm) - sumn);
                    framerefm = jm; 
                end
            end    
        end
        runningsumM = runningsumM + SimilarityMatrixMvect(im,framerefm);
        frameMatrixMvect(1,im) = framerefm;
    end 

   firstm = 99999;lastm = 1;
   lenframeMatrixM = size(frameMatrixMvect);
   for im = 1:lenframeMatrixM(2)
      if(frameMatrixMvect(1,im) > lastm)
          lastm = frameMatrixMvect(1,im);
      end
      if(frameMatrixMvect(1,im) < firstm)
          firstm = frameMatrixMvect(1,im);
      end
   end 
   
   ksimm(eachvideom,1) = runningsumM/(FrameRange(2) - FrameRange(1));
   ksimm(eachvideom,2) = firstm;
   ksimm(eachvideom,3) = lastm;
   ksimm(eachvideom,4) = eachvideom;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                          Code to find k most similar                            %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kscSize = size(ksimh);
kscUlt = zeros(kscSize(1),kscSize(2));
for ik = 1:kscSize(1)
    if((ksimh(ik,1) == 0) || (ksimm(ik,1) == 0) || (ksimS(ik,1) == 0))
        flagh = 0;flags = 0;flagm = 0;
        if((ksimh(ik,1) == 0))
            histdist = 0;
            flagh = 1;
        end
        if((ksimS(ik,1) == 0))
            siftdist = 0;
            flags = 1;
        end
        if((ksimm(ik,1) == 0))
            mvectdist = 0;
            flagm = 1;
        end
        if(flagh == 0)
            histdist = (1 - abs(1/ksimh(ik,1)));
        end 
        if(flags == 0)
            siftdist = (1 - abs(1/ksimS(ik,1)));
        end 
        if(flagm == 0)
            mvectdist = (1 - abs(1/ksimm(ik,1)));
        end 
               
        kscdist = ((histdist + mvectdist + siftdist)/3)*100;
        
        histstart = ksimh(ik,2);
        siftstart = ksimS(ik,2);
        mvectstart = ksimm(ik,2);
        kscstart = ceil((histstart + mvectstart + siftstart)/3);
    
        histend = ksimh(ik,3);
        siftend = ksimS(ik,3);
        mvectend = ksimm(ik,3);
        kscend = floor((histend + mvectend + siftend)/3);
        
        kscUlt(ik,1) = kscdist;
        kscUlt(ik,2) = kscstart;
        kscUlt(ik,3) = kscend;
        kscUlt(ik,4) = ik;
        if(ik == VideoNo)
            kscUlt(ik,1) = 0;
            kscUlt(ik,2) = ksimh(ik,2);
            kscUlt(ik,3) = ksimh(ik,3);
            kscUlt(ik,4) = ik;
        end
    else
        histdist = (1 - abs(1/ksimh(ik,1)));
        siftdist = (1 - abs(1/ksimS(ik,1)));
        mvectdist = (1 - abs(1/ksimm(ik,1)));
        
        kscdist = ((histdist + mvectdist + siftdist)/3)*100;
        
        histstart = ksimh(ik,2);
        siftstart = ksimS(ik,2);
        mvectstart = ksimm(ik,2);
        kscstart = ceil((histstart + mvectstart + siftstart)/3);
    
        histend = ksimh(ik,3);
        siftend = ksimS(ik,3);
        mvectend = ksimm(ik,3);
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

VideoPath = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\InputVideo';
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



