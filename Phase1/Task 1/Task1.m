%Path of all Scripts = C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\DataR
%User Input for Path of scripts
Path = input('Enter Path of folder with video :- ','s');                    %User Input for Path of scripts
Resolution = input('Enter Resolution(r) for videos to be split into :- ');     %User Input for Resolution r for all videos
Nbins = input('Enter Color Histogram size(n) for videos to be split into :- ');     %User Input for Resolution r for all videos
%disp (Path)
%File Handler for Writing Output to File

OutputFile = 'out_file.chst';                                               %Final Output File
OutputPath = fullfile(Path,OutputFile);                                     %Absolute Path of Final Output File 
Output = fopen(OutputPath,'w');

VideoFiles = dir(fullfile(Path,'*mp4'));
for File = 1:size(VideoFiles)                                               %Loop running for each video (.mp4) in the given path
    Video = VideoReader(fullfile(Path,VideoFiles(File).name));
    FrameNo = 1;
    while hasFrame(Video)                                                   %Loop running while each Video has frames remaining for extraction
        FrameInRGB = readFrame(Video);
        Frame = rgb2gray(FrameInRGB);          %Converting Frame to Grayscale
        [FrameHeight,FrameWidth] = size(Frame);
        
        %Splitting Resolution R into cells
        HeightSplits = floor(FrameHeight/Resolution);
        FrameHeightSplits = zeros(Resolution+1,1); % to initialize array 
        for counter = 2:Resolution + 1  
            FrameHeightSplits(counter) = ((counter - 1) * HeightSplits);      
        end
        
        WidthSplits = floor(FrameWidth/Resolution);
        FrameWidthSplits = zeros(Resolution+1,1); % to initialize array 
        for counter = 2:Resolution + 1  
            FrameWidthSplits(counter) = ((counter - 1) * WidthSplits);      
        end
        %Creating Individual Cells
        SmallFrameCount = 1;
        for NewHeight = 1:Resolution
            for NewWidth = 1:Resolution
                SmallFrame = Frame(FrameHeightSplits(NewHeight)+1:FrameHeightSplits(NewHeight+1), FrameWidthSplits(NewWidth)+1:FrameWidthSplits(NewWidth+1));
                [PixelFreq,Range] = imhist(SmallFrame,Nbins);
                PixelFreqOutput = '';
                for Value = 1:size(PixelFreq)
                    if isempty(PixelFreqOutput)
                        PixelFreqOutput = strcat(PixelFreqOutput,';',int2str(PixelFreq(Value)));
                    else
                        PixelFreqOutput = strcat(PixelFreqOutput,',',int2str(PixelFreq(Value)));
                    end    
                end    
                fprintf(Output,'%s',int2str(File),';',int2str(FrameNo),';',int2str(SmallFrameCount));
                fprintf(Output,'%s',PixelFreqOutput);
                fprintf(Output,'\n');
                SmallFrameCount = SmallFrameCount + 1;
            end 
        end       
    FrameNo = FrameNo + 1;
    end
end
fclose(Output);







