Path= input('Enter the Directory path containing the videos: ', 's'); 
Res = input('Enter the resolution required to split the Videos: ');
OutputFile=fopen('F:\ASU\SEM-1\MWDB\Project Docs\Task2_out_file_rash.sift','w');
Vid_dir = dir(fullfile(Path,'*.mp4'));
for n=1:length(Vid_dir)
    vidname = Vid_dir(n).name;
    v = VideoReader(fullfile(Path,vidname));
    FrameNum =1;
    while hasFrame(v)
        frname = readFrame(v);
        grayimg= rgb2gray(frname);
        [Frameht, Framewd] = size(grayimg);
        Splitht= floor(Frameht/Res);
        Splitwd =floor( Framewd/Res);
        Frame_inDbl = im2double(grayimg);
        [frames,descriptors,gss,dogss] = sift(Frame_inDbl);
        Frame_Matrix = [frames;  descriptors ];
        MatrixVectorscnt = size(Frame_Matrix);
        Cellno_Row = zeros(1, MatrixVectorscnt (2));
        Output_FrameMatrix =  [Cellno_Row;Frame_Matrix];
        wd_checkpoints=[];
        ht_checkpoints=[];
        for p = 1:Res
            n1 = p*Splitwd;
            wd_checkpoints = [wd_checkpoints, n1];
            n2 = p*Splitht;
            ht_checkpoints = [ht_checkpoints, n2];
        end
        
        for count = 1: MatrixVectorscnt(2)
            X_coor = Output_FrameMatrix(2, count);
            Y_coor = Output_FrameMatrix(3, count);
            for i = 1:Res
                if X_coor > wd_checkpoints(i) &&  X_coor <= wd_checkpoints(i+1)
                    x_cellcount = i+1;
                    if Y_coor > ht_checkpoints(i) &&  Y_coor <= ht_checkpoints(i+1)
                        y_cellcount = i+1;
                        cellcount = x_cellcount+ (y_cellcount*Res)+1;
                        Output_FrameMatrix (1, count) = cellcount;
                    end 
                end
            end
            FinalmatSize=size(Output_FrameMatrix);
            
            for count = 1:FinalmatSize(2)
                fprintf(OutputFile,'%s',int2str(n),';',int2str(FrameNum));
                SiftVectorString = ' ';
                for k = 1:FinalmatSize
                    if (k ==1 ||k==2)
                        SiftVectorString = strcat(SiftVectorString, ';', num2str(Output_FrameMatrix(k, count)));
                    else
                        SiftVectorString = strcat(SiftVectorString, ',', num2str(Output_FrameMatrix(k, count)));
                    end
                end
                fprintf(OutputFile,'%s',SiftVectorString);
                fprintf(OutputFile,'\n');
            end
        end
        Frameno = Frameno+1;
    end
end
fclose(OutputFile);

