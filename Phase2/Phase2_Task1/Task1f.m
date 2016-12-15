%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Video1 = input('Enter index of Video1 to be compared:- ','s');                
Video2 = input('Enter index of Video2 to be compared:- ','s'); 

InputDir = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase2\Phase1_output\';
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
frame_it=1;
Mat1=zeros((Matrix1(countV1,2))*Matrix1(countV1,3),10);
numberofframes1 = Matrix1(countV1,3);
Mat2=zeros((Matrix2(countV2,2))*Matrix2(countV2,3),10);
numberofframes2 = Matrix2(countV2,3);
frame_no=Matrix1(frame_it,2);
it=1;
cell_it=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 1                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (Matrix1(it,2)==frame_no)
    Mat1(cell_it,1)=Matrix1(it,1);
    Mat1(cell_it,2)=Matrix1(it,2);
    Mat1(cell_it,3)=Matrix1(it,3);
    cell_num=Matrix1(it,3);
    num_vec=0;
    while (Matrix1(it,3)==cell_num)
        num_vec=num_vec+1;
        for it2=4:10            
            Mat1(cell_it,it2)=Mat1(cell_it,it2)+Matrix1(it,it2);
        end
        if (it+1 >countV1)
            break;
        end
        it=it+1;
    end
    for it2 = 5:10
        Mat1(cell_it,it2) = Mat1(cell_it,it2)/num_vec;
    end
    if (it+1 >countV1)
            break;
    end
    cell_it=cell_it+1;
    frame_no=Matrix1(it,2);
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           Aggregating n Motion Vectors to 1 per cell in Video 2                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frame_it=1;
frame_no=Matrix2(frame_it,2);
it=1;
cell_it=1;
while (Matrix2(it,2)==frame_no)
    
    Mat2(cell_it,1)=Matrix2(it,1);
    Mat2(cell_it,2)=Matrix2(it,2);
    Mat2(cell_it,3)=Matrix2(it,3);
    cell_num=Matrix2(it,3);
    num_vec=0;
    while (Matrix2(it,3)==cell_num)
        num_vec=num_vec+1;
        for it2=4:10            
            Mat2(cell_it,it2)=Mat2(cell_it,it2)+Matrix2(it,it2);
        end
        if (it+1 >countV2)
            break;
        end
        it=it+1;
    end
    for it2 = 5:10
        Mat2(cell_it,it2) = Mat2(cell_it,it2)/num_vec;
    end
    if (it+1 >countV2)
            break;
    end
    cell_it=cell_it+1;
    frame_no=Matrix2(it,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Checking Frame Count in Video 1 and Video 2                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalFrameV1 = Matrix1(countV1,2);
TotalFrameV2 = Matrix2(countV2,2);
flag = 0;
if (TotalFrameV1 > TotalFrameV2)
   flag = 1;
end
if (TotalFrameV1 < TotalFrameV2)
   flag = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 = Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abs1 = norm(Mat1);
abs2 = norm(Mat2);
total_abs = abs1*abs2;
len1=size(Mat1);
sim = 0;
sim1 = 0;
if(flag==0)
    total_sim = 0;
    for vector = 1:len1(1)
       for move = 1:10
          sim1 = pdist2(Mat1(vector,5:10),Mat2(vector,5:10),'minkowski',2);
          sim = sim + sim1;
       end    
       total_sim = (sim*10000)/total_abs;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 > Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      No of Frames in Video 1 < Video 2                          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag==2)
    buffer=Mat1;
    Mat1=Mat2;
    Mat2=buffer;
end
len1=size(Mat1);
len2=size(Mat2);
if(flag~=0)
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
    total_sim = 0;
    for vector = 1:len2(1)
       if ( Mat1(vector+BestVect-1,3) ~= 0 )
          sim1 =  pdist2(Mat1(vector+BestVect-1,5:10),Mat2(vector,5:10),'minkowski',2);
          sim = sim + sim1;
          total_sim = (sim*1000000)/total_abs; 
       end
    end
end
result = ['Motion Vector Similarity between Video ',num2str(Video1),' and Video ',num2str(Video2),' is = ',num2str(total_sim)];
disp(result);