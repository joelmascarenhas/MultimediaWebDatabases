%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Enter Videos Numbers to be compared
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';                    %PATH TO BE CHANGED
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
countmvectV1 = 0;startV1 = 0;countmvectV2 = 0;startV2 = 0;
for Vector = 1:InputMatrixSize(1)
    if (InputMatrix(Vector,1) == str2double(Video1))
        if(startV1 == 0)
            startV1 = Vector;
        end    
        countmvectV1 = countmvectV1 + 1;
    end
    if (InputMatrix(Vector,1) == str2double(Video2))
        if(startV2 == 0)
            startV2 = Vector;
        end
        countmvectV2 = countmvectV2 + 1;
    end 
end   

MatrixMvect1 = InputMatrix(startV1:(startV1+countmvectV1-1),1:end);
MatrixMvect2 = InputMatrix(startV2:(startV2+countmvectV2-1),1:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frame_it=1;
no_of_cells=MatrixMvect1(countmvectV1,3);
Mat1=zeros((MatrixMvect1(countmvectV1,2)-1)*MatrixMvect1(countmvectV1,3),12);
Mat2=zeros((MatrixMvect2(countmvectV2,2)-1)*MatrixMvect2(countmvectV2,3),12);

frame_no=MatrixMvect1(frame_it,2);
it=1;
cell_it=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

frame_it=1;
frame_no=MatrixMvect2(frame_it,2);
it=1;
cell_it=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 2                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
end
result = ['Motion Vector Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is = ',num2str(total_sim/4)];
disp(result);