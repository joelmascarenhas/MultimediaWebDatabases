%Path of all Scripts = C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\DataR
%User Input for Path of scripts
Path = input('Enter Path of folder with videos :- ','s');                   %User Input for Path of scripts
Resolution = input('Enter Resolution for videos to be split into :- ');     %User Input for Resolution r for all videos
%disp (Path)
%File Handler for Writing Output to File
OutputFile = 'out_file.sift';                                               %Final Output File
OutputPath = fullfile(Path,OutputFile);
Output = fopen(OutputPath,'w');

VideoFiles = dir(fullfile(Path,'*mp4'));
for File = 1:size(VideoFiles)                                               %Loop running for each video (.mp4) in the given path
    %disp (VideoFiles(File).name)
    Video = VideoReader(fullfile(Path,VideoFiles(File).name));
    FrameNo = 1;
    while hasFrame(Video)                                                   %Loop running while each Video has frames remaining for extraction
        FrameInRGB = readFrame(Video);
        Frame = rgb2gray(FrameInRGB);               %Converting Frame to Grayscale
        [FrameHeight,FrameWidth] = size(Frame);
        
        %Splitting Resolution R into cells
        HeightSplits = FrameHeight/Resolution;
        WidthSplits = FrameWidth/Resolution;
        
        % Following code is used to retrieve all SIFT vectors for each
        % frame and store in their corresponding matrix
        FrameDouble = im2double(Frame);
        [frames,descriptors,gss,dogss] = sift(FrameDouble);
        Outputmatrix = [frames;descriptors];
        TotalVectors = size(Outputmatrix);
        
        % Following code logic is used to read destX,destY coordinates and
        % assign the corresponding cell value to it
        CellNumber = zeros(1,TotalVectors(2));
        FinalOutputMatrix =  [CellNumber;Outputmatrix];   
        for siftvectorsframes = 1:TotalVectors(2)
            xcoord = FinalOutputMatrix(2,siftvectorsframes);
            ycoord = FinalOutputMatrix(3,siftvectorsframes);
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
            FinalOutputMatrix(1,siftvectorsframes) = cell;
        end
        
        % Following code logic is used to print the Final matrix in the
        % format required
        Finalmatrix = sortrows(FinalOutputMatrix',1)';
        Finalmatrixsize = size(Finalmatrix);
        for siftvectorsframes = 1:Finalmatrixsize(2)
            fprintf(Output,'%s',int2str(File),';',int2str(FrameNo));
            SiftVectorValues = '';
            for eachvector = 1:133
                if (eachvector == 1 || eachvector == 2)
                    SiftVectorValues = strcat(SiftVectorValues,';',num2str(Finalmatrix(eachvector,siftvectorsframes)));
                else
                    SiftVectorValues = strcat(SiftVectorValues,',',num2str(Finalmatrix(eachvector,siftvectorsframes)));
                end     
            end
             fprintf(Output,'%s',SiftVectorValues);
             fprintf(Output,'\n');
        end       
    FrameNo = FrameNo + 1;
    end
end
fclose(Output);







