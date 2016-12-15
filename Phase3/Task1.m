%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file and put into matrix                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                                                                                 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim = input('Enter Target Dimensionality:- ','s');                 

disp(sprintf('\nReading Input Matrix.............'));
disp(datestr(now));
Matrix1 = dlmread('C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase3\Phase1_output\filename.sift',','); 
disp(datestr(now));
disp('Reading Matrix Completed');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%                      Code to read from file ends here                           %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OutputPath = 'C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase3\Phase3_output\';

OutputFile2 = 'filename_d2.spc';
OutputPath2 = fullfile(OutputPath,OutputFile2);
Output2 = fopen(OutputPath2,'w');

InfoMatrix = Matrix1(1:end,1:5);
VectorMatrix = Matrix1(1:end,6:end);

CovarianceMatrix = cov(VectorMatrix);
[BasisMatrix,DiagonalMatrix] = eig(CovarianceMatrix);
[DiagonalMatrix,index] = sort(diag(DiagonalMatrix),'descend');
DiagonalMatrix = diag(DiagonalMatrix);
BasisMatrix = BasisMatrix(:,index);

BasisMatrix = BasisMatrix(1:end,1:str2double(dim));
PCAMatrixFull = VectorMatrix * BasisMatrix;
PCAMatrix = PCAMatrixFull(1:end,1:str2double(dim));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                                     Code for <original_index,score>                                         %%%%%%%                                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BasisMatrixSize = size(BasisMatrix);
IndexMatrix = zeros(BasisMatrixSize(1),1);
for i = 1:BasisMatrixSize(1)
    IndexMatrix(i,1) = i;
end    

ScoreMatrix = horzcat(IndexMatrix,BasisMatrix);

disp(sprintf('\nWriting <Index,Score> Matrix.............'));
disp(datestr(now));

for j = 2:(BasisMatrixSize(2)+1)
    AscPrintMatrix = sortrows(ScoreMatrix,j);
    k = BasisMatrixSize(1);
    indexVal = '';index = 0;score = 0;
    while(k > 0)
        score = AscPrintMatrix(k,j);
        index = AscPrintMatrix(k,1);
        indexVal = strcat(indexVal,'<',num2str(index),',',num2str(score),'>/' );
        k = k - 1;
    end
    fprintf(Output2,'%s',indexVal);
    fprintf(Output2,'\n'); 
end    
fclose(Output2);
disp(datestr(now));
disp('Writing <Index,Score> Matrix Completed');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                                     Code for <original_index,score> ends here                               %%%%%%%                                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(sprintf('\nWriting Dim Reduced Matrix............'));
disp(datestr(now));
SiftPCAMatrix = horzcat(InfoMatrix,PCAMatrix);
dlmwrite('C:\Users\Joel\Desktop\ASU_Stuff\Sem1\MWD\Phase3\Phase3_output\filename_d.spc',SiftPCAMatrix);
disp(datestr(now));
disp(sprintf('Writing Dim Reduced Matrix Completed'));