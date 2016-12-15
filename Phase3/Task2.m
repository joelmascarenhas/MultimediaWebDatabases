%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ks = input('Enter The no of hash functions per layer:- ','s');                 
%layer=input('Enter the number of layers- ','s');
%layers=str2num(layer);
%k=str2num(ks);

K = str2num(input('Enter K i.e No of similar frames:- ','s'));                 
layers = 3; k = 12;

disp(sprintf('\nReading Input Matrix.............'));
disp(datestr(now));
Matrix1 = dlmread('C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase3\Phase3_output\filename_d.spc',',');
length=size(Matrix1);
dims=length(2);

disp(sprintf('\nReading Input Matrix Completed'));
disp(datestr(now));

disp(sprintf('\nLSH Computation Starting now.............'));
disp(datestr(now));

Min_val=zeros(1,dims-5);
Max_val=zeros(1,dims-5);
for i=1:dims-5
    %finding the min and max values along each dimension
    Min_val(i)=min(Matrix1(:,i+5));
    Max_val(i)=max(Matrix1(:,i+5));
end
random=zeros(1,dims-5);
Mat_final=zeros(1,7);

for j=1:layers
    %for each layer
    it=1;
    bucket_vals=zeros(length(1),k);
    Mat_fin=zeros(length(1),7);
    for l=1:k
        %for each hash function in a layer
        for i=1:dims-5
            %get a random value between min and max along each dimension
            random(i)=Min_val(i)+(Max_val(i)-Min_val(i))*rand(1,1);
        end
        for i=1:length(1)
            %for each sift vector, calculate the cosine distane wrt the
            %random vector generated above.
            vec=Matrix1(i,6:end);
            sum=0;
            ran_val=0;
            vec_val=0;
            for m=1:dims-5
                sum=sum+(random(m)*vec(m));
                ran_val=ran_val+(random(m)*random(m));
                vec_val=vec_val+(vec(m)*vec(m));
            end
            d=sum/(sqrt(ran_val)*sqrt(vec_val));
            %if the value is less the 0.7 then assign 1 as hash value else
            %0.
            if d<0.85
                bucket_vals(i,l)=0;
            else
                bucket_vals(i,l)=1;
            end
        end
    end
    %for each layer, get the bucket value with 0's and 1's obtained from
    %each hash function
    for i=1:length(1)
        Mat_fin(i,1)=j;
        vec=bucket_vals(i,:);
        Mat_fin(i,2)=bi2de(vec);
        for m=1:5
            Mat_fin(i,m+2)=Matrix1(i,m);
        end
    end
    
    %Mat_fin1=sortrows(Mat_fin,2);
    Mat_final=[Mat_final;Mat_fin];
end
Mat_final=Mat_final(2:end,:);

disp(sprintf('\nLSH Computation Completed'));
disp(datestr(now));

% Finding frames in each video
lengthMatrix1 = size(Matrix1);
vc = Matrix1(lengthMatrix1(1),1);
vfr = zeros(vc,1);
frcount = 0;
for video = 1:vc
    for i = 1:lengthMatrix1(1)
        if(Matrix1(i,1) == (video + 1))
            frcount = Matrix1(i - 1,2);
            break;
        end    
    end
    if(video == vc)
        frcount = Matrix1(lengthMatrix1(1),2);
    end    
    vfr(video,1) = frcount;
    frcount = 0;
end    

totalfr = 0;
for sum = 1:vc
    totalfr = totalfr + vfr(sum,1);
end   

Graphmat1 = zeros(totalfr * K,5);
Graphmat2 = zeros(totalfr * K,5);
Graphmat3 = zeros(totalfr * K,5);

% Finding vectors in each frame
vvec = zeros(totalfr,1);
totalvc = 0;
start = 1;
for a = 1:vc
    for b = 1:vfr(a,1)
        for c = 1:lengthMatrix1(1)
            if((Matrix1(c,1) == a) && (Matrix1(c,2) == b)) 
                totalvc = totalvc + 1;
            end    
        end
        vvec(start,1) = totalvc;
        start = start + 1;
        totalvc = 0;
    end
end    
length=size(Mat_final);
Mat_final2 = Mat_final((length(1)/3) + 1:(length(1)*2)/3,1:length(2));
Mat_final3 = Mat_final(((length(1)*2)/3) + 1:length(1),1:length(2));

disp(sprintf('\nLayer 1 Computation Begins.................'));
disp(datestr(now));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                         LAYER 1                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length=size(Mat_final);
videoCount = Mat_final(length(1),3);
for v = 1:videoCount
    vectorcount = 0;startpos = 0;
    %for l = length(1)/2:length(1)
    for l = 1:length(1)/3
        if(Mat_final(l,3) == v)
            if(vectorcount == 0)
                startpos = l;
            end    
            vectorcount = vectorcount + 1;
        end  
    end    
    
    totframes = Mat_final((startpos + vectorcount - 1),4);
    for frames = 1:totframes
        startframevec = 0;
        totvecperfr = 0;
        for i = 1:vectorcount
            if(Mat_final(i + startpos - 1,4) == frames)
                if(startframevec == 0)
                    startframevec = i + startpos - 1;
                end
                totvecperfr = totvecperfr + 1;
            end
        end
        bmatrix = zeros(1,4096);
        bmatrix(1,1) = Mat_final(startframevec,2);
        pos = 2;
        for vec = 2:totvecperfr
            bucket_id = Mat_final(vec + startframevec - 1,2);
            found = find(bmatrix()==bucket_id);
            if isempty(found)
                bmatrix(1,pos) = bucket_id;
                pos = pos + 1;
            end
        end
        bucketmatrix=bmatrix(1:find(bmatrix, 1, 'last'));
        lenbmat = size(bucketmatrix);
        
        %%%% Finding how many vectors match the each bucket for source frame
        frammatmain = zeros(1,lenbmat(2));
                       
        frammat = zeros(totalfr - totframes,lenbmat(2));
        %for d = length(1)/2:length(1)
        for d = 1:length(1)/3    
            if Mat_final(d,3) == v
                if Mat_final(d,4) == frames
                    bucketno = Mat_final(d,2);
                    for e = 1:lenbmat(2)
                        if bucketmatrix(1,e) == bucketno
                            break;
                        end    
                    end
                    frammatmain(1,e) = frammatmain(1,e) + 1;
                end
            else
                bucketno = Mat_final(d,2);
                flag = 0;
                for e = 1:lenbmat(2)
                    if bucketmatrix(1,e) == bucketno
                        flag = 1;
                        break;
                    end    
                end
                if flag == 1
                    matchedvno = Mat_final(d,3);
                    matchedfrno = Mat_final(d,4);
                    matchedfrcount = 0;
                    %%%% Finding how many vectors match the original vectors
                    if matchedvno < v
                        if matchedvno == 1
                            matchedfrcount = matchedfrno;
                            frammat(matchedfrcount,e) = frammat(matchedfrcount,e) + 1;
                        else    
                            for f = 1:matchedvno - 1
                                matchedfrcount = matchedfrcount + vfr(f,1);
                            end
                            frammat(matchedfrcount + matchedfrno,e) = frammat(matchedfrcount + matchedfrno,e) + 1;
                        end
                    end
                    if matchedvno > v
                        for f = 1:matchedvno - 1
                            matchedfrcount = matchedfrcount + vfr(f,1);
                        end
                        frammat(matchedfrcount + matchedfrno - vfr(v,1),e) = frammat(matchedfrcount + matchedfrno - vfr(v,1),e) + 1;
                    end
                end    
            end    
        end
        sizeframmat = size(frammat);
        %%%% Normalizing all vectors in source frame
        if v == 1
            for h = 1:sizeframmat(2)
                frammatmain(1,h) = frammatmain(1,h)/vvec(frames,1);
            end    
        else
            srcframecount = 0;
            for i = 1:v-1
                srcframecount = srcframecount + vfr(i,1);
            end
            for h = 1:sizeframmat(2)
                %disp (srcframecount + 1);
                %disp (vvec(srcframecount + 1,1));
                frammatmain(1,h) = frammatmain(1,h)/vvec(srcframecount + frames,1);
            end
        end
                
        %%%% Normalizing all vectors
        if v == 1
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(vfr(1,1) + g,1);
                end    
            end
        end
        if v ~= 1 && v ~= videoCount
            currentframecount = 0;
            for  i = 1:v-1
                currentframecount = currentframecount + vfr(i,1);
            end
            for g = 1:currentframecount
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end
            newframecount = currentframecount + vfr(v,1);
            for g = currentframecount + 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(newframecount+ 1,1);
                end    
            end
        end
        if v == videoCount
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end   
        end
        
        %Creating Similarity Matrix
        simmatrix = zeros(sizeframmat(1),2);
        for i = 1:sizeframmat(1)
            simmatrix(i,1) = i;
            mincount = 0;
            maxcount = 0;
            for j = 1:sizeframmat(2)
                mincount = mincount + min(frammat(i,j),frammatmain(1,j));
                maxcount = maxcount + max(frammat(i,j),frammatmain(1,j));
            end    
            simmatrix(i,2) = mincount/maxcount;
        end
        finalsimmatrix = sortrows(simmatrix,-2);
        finalsimmatrixframes = zeros(K,4);
        for l = 1:K
            finalsimmatrixframes(l,1) = finalsimmatrix(l,1);
            finalsimmatrixframes(l,4) = finalsimmatrix(l,2);
            if finalsimmatrixframes(l,1) <= vfr(1,1)
                if v == 1
                    finalsimmatrixframes(l,2) = 2;
                else    
                    finalsimmatrixframes(l,2) = 1;
                end    
                finalsimmatrixframes(l,3) = finalsimmatrixframes(l,1);
            else
                currentvidframestart = 0;
                for m = 1:v-1
                    currentvidframestart = currentvidframestart + vfr(m,1);
                end    
                if finalsimmatrixframes(l,1) < currentvidframestart+1
                    matchframe = finalsimmatrixframes(l,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end    
                else
                    matchframe = finalsimmatrixframes(l,1) + vfr(v,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end
                end    
            end    
        end    
        outputmat1 = finalsimmatrixframes(1:K,2:4);
        outputmat2 = zeros(K,2);
        for o = 1:K
            outputmat2(o,1) = v;
            outputmat2(o,2) = frames;
        end    
        finaloutputmatrix = horzcat(outputmat2,outputmat1);
        if ~any(Graphmat1(:)) == 0
            Graphmat1 = vertcat(Graphmat1,finaloutputmatrix);
        else
            Graphmat1 = finaloutputmatrix;
        end    
    end    
end

disp(sprintf('\nLayer 2 Computation Begins.................'));
disp(datestr(now));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                         LAYER 2                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length2=size(Mat_final2);
videoCount = Mat_final(length(1),3);
for v = 1:videoCount
    vectorcount = 0;startpos = 0;
    for l = 1:length2(1)
    %for l = 1:length(1)/2
        if(Mat_final2(l,3) == v)
            if(vectorcount == 0)
                startpos = l;
            end    
            vectorcount = vectorcount + 1;
        end  
    end    
    
    totframes = Mat_final2((startpos + vectorcount - 1),4);
    for frames = 1:totframes
        startframevec = 0;
        totvecperfr = 0;
        for i = 1:vectorcount
            if(Mat_final2(i + startpos - 1,4) == frames)
                if(startframevec == 0)
                    startframevec = i + startpos - 1;
                end
                totvecperfr = totvecperfr + 1;
            end
        end
        bmatrix = zeros(1,4096);
        bmatrix(1,1) = Mat_final2(startframevec,2);
        pos = 2;
        for vec = 2:totvecperfr
            bucket_id = Mat_final2(vec + startframevec - 1,2);
            found = find(bmatrix()==bucket_id);
            if isempty(found)
                bmatrix(1,pos) = bucket_id;
                pos = pos + 1;
            end
        end
        bucketmatrix=bmatrix(1:find(bmatrix, 1, 'last'));
        lenbmat = size(bucketmatrix);
        
        %%%% Finding how many vectors match the each bucket for source frame
        frammatmain = zeros(1,lenbmat(2));
                       
        frammat = zeros(totalfr - totframes,lenbmat(2));
        for d = 1:length2(1)
        %for d = 1:length(1)/2    
            if Mat_final2(d,3) == v
                if Mat_final2(d,4) == frames
                    bucketno = Mat_final2(d,2);
                    for e = 1:lenbmat(2)
                        if bucketmatrix(1,e) == bucketno
                            break;
                        end    
                    end
                    frammatmain(1,e) = frammatmain(1,e) + 1;
                end
            else
                bucketno = Mat_final2(d,2);
                flag = 0;
                for e = 1:lenbmat(2)
                    if bucketmatrix(1,e) == bucketno
                        flag = 1;
                        break;
                    end    
                end
                if flag == 1
                    matchedvno = Mat_final2(d,3);
                    matchedfrno = Mat_final2(d,4);
                    matchedfrcount = 0;
                    %%%% Finding how many vectors match the original vectors
                    if matchedvno < v
                        if matchedvno == 1
                            matchedfrcount = matchedfrno;
                            frammat(matchedfrcount,e) = frammat(matchedfrcount,e) + 1;
                        else    
                            for f = 1:matchedvno - 1
                                matchedfrcount = matchedfrcount + vfr(f,1);
                            end
                            frammat(matchedfrcount + matchedfrno,e) = frammat(matchedfrcount + matchedfrno,e) + 1;
                        end
                    end
                    if matchedvno > v
                        for f = 1:matchedvno - 1
                            matchedfrcount = matchedfrcount + vfr(f,1);
                        end
                        frammat(matchedfrcount + matchedfrno - vfr(v,1),e) = frammat(matchedfrcount + matchedfrno - vfr(v,1),e) + 1;
                    end
                end    
            end    
        end
        sizeframmat = size(frammat);
        %%%% Normalizing all vectors in source frame
        if v == 1
            for h = 1:sizeframmat(2)
                frammatmain(1,h) = frammatmain(1,h)/vvec(frames,1);
            end    
        else
            srcframecount = 0;
            for i = 1:v-1
                srcframecount = srcframecount + vfr(i,1);
            end
            for h = 1:sizeframmat(2)
                %disp (srcframecount + 1);
                %disp (vvec(srcframecount + 1,1));
                frammatmain(1,h) = frammatmain(1,h)/vvec(srcframecount + frames,1);
            end
        end
                
        %%%% Normalizing all vectors
        if v == 1
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(vfr(1,1) + g,1);
                end    
            end
        end
        if v ~= 1 && v ~= videoCount
            currentframecount = 0;
            for  i = 1:v-1
                currentframecount = currentframecount + vfr(i,1);
            end
            for g = 1:currentframecount
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end
            newframecount = currentframecount + vfr(v,1);
            for g = currentframecount + 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(newframecount+ 1,1);
                end    
            end
        end
        if v == videoCount
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end   
        end
        
        %Creating Similarity Matrix
        simmatrix = zeros(sizeframmat(1),2);
        for i = 1:sizeframmat(1)
            simmatrix(i,1) = i;
            mincount = 0;
            maxcount = 0;
            for j = 1:sizeframmat(2)
                mincount = mincount + min(frammat(i,j),frammatmain(1,j));
                maxcount = maxcount + max(frammat(i,j),frammatmain(1,j));
            end    
            simmatrix(i,2) = mincount/maxcount;
        end
        finalsimmatrix = sortrows(simmatrix,-2);
        finalsimmatrixframes = zeros(K,4);
        for l = 1:K
            finalsimmatrixframes(l,1) = finalsimmatrix(l,1);
            finalsimmatrixframes(l,4) = finalsimmatrix(l,2);
            if finalsimmatrixframes(l,1) <= vfr(1,1)
                if v == 1
                    finalsimmatrixframes(l,2) = 2;
                else    
                    finalsimmatrixframes(l,2) = 1;
                end    
                finalsimmatrixframes(l,3) = finalsimmatrixframes(l,1);
            else
                currentvidframestart = 0;
                for m = 1:v-1
                    currentvidframestart = currentvidframestart + vfr(m,1);
                end    
                if finalsimmatrixframes(l,1) < currentvidframestart+1
                    matchframe = finalsimmatrixframes(l,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end    
                else
                    matchframe = finalsimmatrixframes(l,1) + vfr(v,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end
                end    
            end    
        end    
        outputmat1 = finalsimmatrixframes(1:K,2:4);
        outputmat2 = zeros(K,2);
        for o = 1:K
            outputmat2(o,1) = v;
            outputmat2(o,2) = frames;
        end    
        finaloutputmatrix = horzcat(outputmat2,outputmat1);
        if ~any(Graphmat2(:)) == 0
            Graphmat2 = vertcat(Graphmat2,finaloutputmatrix);
        else
            Graphmat2 = finaloutputmatrix;
        end    
    end    
end

disp(sprintf('\nLayer 3 Computation Begins.................'));
disp(datestr(now));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                         LAYER 3                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length3=size(Mat_final3);
videoCount = Mat_final(length(1),3);
for v = 1:videoCount
    vectorcount = 0;startpos = 0;
    for l = 1:length3(1)
        if(Mat_final3(l,3) == v)
            if(vectorcount == 0)
                startpos = l;
            end    
            vectorcount = vectorcount + 1;
        end  
    end    
    
    totframes = Mat_final3((startpos + vectorcount - 1),4);
    for frames = 1:totframes
        startframevec = 0;
        totvecperfr = 0;
        for i = 1:vectorcount
            if(Mat_final3(i + startpos - 1,4) == frames)
                if(startframevec == 0)
                    startframevec = i + startpos - 1;
                end
                totvecperfr = totvecperfr + 1;
            end
        end
        bmatrix = zeros(1,4096);
        bmatrix(1,1) = Mat_final3(startframevec,2);
        pos = 2;
        for vec = 2:totvecperfr
            bucket_id = Mat_final3(vec + startframevec - 1,2);
            found = find(bmatrix()==bucket_id);
            if isempty(found)
                bmatrix(1,pos) = bucket_id;
                pos = pos + 1;
            end
        end
        bucketmatrix=bmatrix(1:find(bmatrix, 1, 'last'));
        lenbmat = size(bucketmatrix);
        
        %%%% Finding how many vectors match the each bucket for source frame
        frammatmain = zeros(1,lenbmat(2));
                       
        frammat = zeros(totalfr - totframes,lenbmat(2));
        for d = 1:length3(1)
        %for d = 1:length(1)/2    
            if Mat_final3(d,3) == v
                if Mat_final3(d,4) == frames
                    bucketno = Mat_final3(d,2);
                    for e = 1:lenbmat(2)
                        if bucketmatrix(1,e) == bucketno
                            break;
                        end    
                    end
                    frammatmain(1,e) = frammatmain(1,e) + 1;
                end
            else
                bucketno = Mat_final3(d,2);
                flag = 0;
                for e = 1:lenbmat(2)
                    if bucketmatrix(1,e) == bucketno
                        flag = 1;
                        break;
                    end    
                end
                if flag == 1
                    matchedvno = Mat_final3(d,3);
                    matchedfrno = Mat_final3(d,4);
                    matchedfrcount = 0;
                    %%%% Finding how many vectors match the original vectors
                    if matchedvno < v
                        if matchedvno == 1
                            matchedfrcount = matchedfrno;
                            frammat(matchedfrcount,e) = frammat(matchedfrcount,e) + 1;
                        else    
                            for f = 1:matchedvno - 1
                                matchedfrcount = matchedfrcount + vfr(f,1);
                            end
                            frammat(matchedfrcount + matchedfrno,e) = frammat(matchedfrcount + matchedfrno,e) + 1;
                        end
                    end
                    if matchedvno > v
                        for f = 1:matchedvno - 1
                            matchedfrcount = matchedfrcount + vfr(f,1);
                        end
                        frammat(matchedfrcount + matchedfrno - vfr(v,1),e) = frammat(matchedfrcount + matchedfrno - vfr(v,1),e) + 1;
                    end
                end    
            end    
        end
        sizeframmat = size(frammat);
        %%%% Normalizing all vectors in source frame
        if v == 1
            for h = 1:sizeframmat(2)
                frammatmain(1,h) = frammatmain(1,h)/vvec(frames,1);
            end    
        else
            srcframecount = 0;
            for i = 1:v-1
                srcframecount = srcframecount + vfr(i,1);
            end
            for h = 1:sizeframmat(2)
                %disp (srcframecount + 1);
                %disp (vvec(srcframecount + 1,1));
                frammatmain(1,h) = frammatmain(1,h)/vvec(srcframecount + frames,1);
            end
        end
                
        %%%% Normalizing all vectors
        if v == 1
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(vfr(1,1) + g,1);
                end    
            end
        end
        if v ~= 1 && v ~= videoCount
            currentframecount = 0;
            for  i = 1:v-1
                currentframecount = currentframecount + vfr(i,1);
            end
            for g = 1:currentframecount
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end
            newframecount = currentframecount + vfr(v,1);
            for g = currentframecount + 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(newframecount+ 1,1);
                end    
            end
        end
        if v == videoCount
            for g = 1:sizeframmat(1)
                for h = 1:sizeframmat(2)
                    frammat(g,h) = frammat(g,h)/vvec(g,1);
                end    
            end   
        end
        
        %Creating Similarity Matrix
        simmatrix = zeros(sizeframmat(1),2);
        for i = 1:sizeframmat(1)
            simmatrix(i,1) = i;
            mincount = 0;
            maxcount = 0;
            for j = 1:sizeframmat(2)
                mincount = mincount + min(frammat(i,j),frammatmain(1,j));
                maxcount = maxcount + max(frammat(i,j),frammatmain(1,j));
            end    
            simmatrix(i,2) = mincount/maxcount;
        end
        finalsimmatrix = sortrows(simmatrix,-2);
        finalsimmatrixframes = zeros(K,4);
        for l = 1:K
            finalsimmatrixframes(l,1) = finalsimmatrix(l,1);
            finalsimmatrixframes(l,4) = finalsimmatrix(l,2);
            if finalsimmatrixframes(l,1) <= vfr(1,1)
                if v == 1
                    finalsimmatrixframes(l,2) = 2;
                else    
                    finalsimmatrixframes(l,2) = 1;
                end    
                finalsimmatrixframes(l,3) = finalsimmatrixframes(l,1);
            else
                currentvidframestart = 0;
                for m = 1:v-1
                    currentvidframestart = currentvidframestart + vfr(m,1);
                end    
                if finalsimmatrixframes(l,1) < currentvidframestart+1
                    matchframe = finalsimmatrixframes(l,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end    
                else
                    matchframe = finalsimmatrixframes(l,1) + vfr(v,1);
                    runningsum = 0;
                    for n = 1:v-1
                        if matchframe <= runningsum + vfr(n,1)
                            finalsimmatrixframes(l,2) = n;
                            startframe = runningsum;
                            newexactframe = matchframe - startframe;
                            finalsimmatrixframes(l,3) = newexactframe;
                            break;
                        end
                        runningsum = runningsum + vfr(n,1);
                    end
                end    
            end    
        end    
        outputmat1 = finalsimmatrixframes(1:K,2:4);
        outputmat2 = zeros(K,2);
        for o = 1:K
            outputmat2(o,1) = v;
            outputmat2(o,2) = frames;
        end    
        finaloutputmatrix = horzcat(outputmat2,outputmat1);
        if ~any(Graphmat3(:)) == 0
            Graphmat3 = vertcat(Graphmat3,finaloutputmatrix);
        else
            Graphmat3 = finaloutputmatrix;
        end    
    end    
end

disp(sprintf('\nFinal Graph Calculation Begins...............'));
disp(datestr(now));

FinalMatrix = vertcat(Graphmat1,Graphmat2);
FinalMatrix = vertcat(FinalMatrix,Graphmat3);
FinalMatrixUlt = sortrows(FinalMatrix,[1,2,-5]);

Ultsize = size(FinalMatrixUlt);
jumps = (Ultsize(1)/3)/K;
z = 1;zz = 1;
Ultmat = zeros(totalfr * K,5); 
while(z < Ultsize(1))
    for i = 0:K-1
        Ultmat(zz,1:5) = FinalMatrixUlt(z+i,1:5);
        zz = zz + 1;
    end 
    z = z + (K*3);
end
s= size(Ultmat);    
for q = 1:s(1)
    if (Ultmat(q,3) == 0 && Ultmat(q,4) == 0)
        if Ultmat(q-1,4) < 25
            Ultmat(q,3) = Ultmat(q-1,3);
            Ultmat(q,4) = Ultmat(q-1,4)+1;
        else
            Ultmat(q,3) = Ultmat(q-1,3);
            Ultmat(q,4) = Ultmat(q-1,4);
        end    
    end    
end   

%%%%%%%% Video Matrix actual representation %%%%%%%%%%
VideoMatrix = zeros(63,2);
for iter = 1:63
    VideoMatrix(iter,1) = iter;
end    
Vid = [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,44,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,7,8,9];
Vid = Vid';
VideoMatrix(1:63,2) = Vid;
%%%%%%%% Video Matrix representation ends %%%%%%%%%%%

for q = 1:s(1)
    mainvid = VideoMatrix(Ultmat(q,1),2);
    simvid = VideoMatrix(Ultmat(q,3),2);
    Ultmat(q,1) = mainvid;
    Ultmat(q,3) = simvid;  
end
Ultmat = sortrows(Ultmat,[1,2]);

disp(sprintf('\nWriting Output to File Begins.................'));
disp(datestr(now));
dlmwrite('C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase3\Phase3_output\filename_d_k.gspc',Ultmat);

disp(sprintf('\nCode Execution completed'));
disp(datestr(now));