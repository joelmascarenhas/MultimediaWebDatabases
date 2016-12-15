%Path of all Scripts = C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\DataR
Path = input('Enter Path of folder with videos :- ','s');                   %User Input for Path of scripts
Resolution = input('Enter Resolution for videos to be split into :- ');     %User Input for Resolution r for all videos 

%File Handler for Writing Output to File
OutputFile = 'out_file.mvect';                      %Final Output File
tempOutputFile = 'tempFile.txt';                    %Output from extract_mv.cpp written to temp file
OutputTempPath = fullfile(Path,tempOutputFile);     %Absolute Path of temp output file
OutputPath = fullfile(Path,OutputFile);             %Absolute Path of Final Output File
Output = fopen(OutputPath,'w');
TempOutput = fopen(OutputTempPath,'r');
%PathtoEXE = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Output\Task3.exe';    %Absolute path to Task3.exe after building project
PathtoEXE = fullfile(Path,'\Output\Task3.exe');

VideoFiles = dir(fullfile(Path,'*mp4'));
for File = 1:size(VideoFiles)                       %Loop running for each video (.mp4) in the given path
    VideoName = fullfile(Path,VideoFiles(File).name);
    Video = VideoReader(VideoName);
    FrameInRGB = readFrame(Video);
    Frame = rgb2gray(FrameInRGB); 
    [FrameHeight,FrameWidth] = size(Frame);         
    
    system(char(strcat(PathtoEXE,{' '},VideoName,' > ',OutputTempPath)));   %Call to extract+mv.cpp build file (i.e Task3.exe) is made with Video Name and output is written to file out_file.mvect
    
    % Following code is used to read data from the file and feed into a 2D
    % Matrix 
    Out = fileread(OutputTempPath);                 
    AllVector = strsplit(Out,';');
    AllVector = AllVector';
    len = size(AllVector)-1;
    FinalMatrix = zeros(len(1),8);
    for eachvector = 1:len(1)
        eachVectorList = strsplit(char(AllVector(eachvector)),' ');
        %disp (eachVectorList);
        lenEachVector = size(eachVectorList);
        for matrix = 1:lenEachVector(2)
           value = eachVectorList{matrix};
           FinalMatrix(eachvector,matrix) = str2double(value);
        end
    end
    
    % Following code logic is used to read destX,destY coordinates and
    % assign the corresponding cell value to it
    FinalMatrix = FinalMatrix';
    HeightSplits = FrameHeight/Resolution;  %Partitions FrameHeight into cells based on Resolution r
    WidthSplits = FrameWidth/Resolution;    %Partitions FrameWidth into cells based on Resolution r
    CellNumber = zeros(1,len(1));           %Create a 1D Matrix which will have Cell Number for each Vector
    FinalOutputMatrix =  [CellNumber;FinalMatrix];          
    TotalVectors = size(FinalOutputMatrix);
    for motionvectorsframes = 1:len(1)
        xcoord = FinalOutputMatrix(8,motionvectorsframes);
        ycoord = FinalOutputMatrix(9,motionvectorsframes);
        %Corner Cases on Y Axis
        celly = floor(ycoord/HeightSplits);
        if (celly >= Resolution)
            celly = celly - 1;
        end
        %Corner Cases on X Axis
        cellx = floor(xcoord/WidthSplits);
        if (cellx >= Resolution)
            cellx = cellx - 1;
        end
        cell = (celly * Resolution) + (cellx + 1);
        FinalOutputMatrix(1,motionvectorsframes) = cell;
    end
    
    % Following code logic is used to print the Final OutputMatrix in the
    % format required
    FinalOutputMatrix([1 2],:) = FinalOutputMatrix([2 1 ],:);
    FinalOutputMatrix = FinalOutputMatrix';
    FinalOutputMatrix = sortrows(FinalOutputMatrix,[1 2]);
    FinalOutputMatrix = FinalOutputMatrix';
    for vectors = 1:len(1)
        fprintf(Output,'%s',int2str(File));
            MotionVectorValues = '';
            for AllVector = 1:9
                if (AllVector == 1 || AllVector == 2)
                    MotionVectorValues = strcat(MotionVectorValues,';',num2str(FinalOutputMatrix(AllVector,vectors)));
                else
                    MotionVectorValues = strcat(MotionVectorValues,',',num2str(FinalOutputMatrix(AllVector,vectors)));
                end     
            end
             fprintf(Output,'%s',MotionVectorValues);
             fprintf(Output,'\n');         
    end  
end
fclose(Output);







