function [status] = ReadStatus(flagDisplay)
if nargin < 1
    flagDisplay = 1;
end
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
byteID=105;
byteData=[0 0 0 0 0 0];
fwrite(s,[byteID byteData]);
dataRec = fread(s,9);
returnedByteID = dataRec(1,1);
if(returnedByteID ~= byteID)
    status = 102;
    disp('Unknown Error. Please try again')
    return;
end
if flagDisplay
    switch dataRec(2,1)
        case 1
            disp('Stablizing');
        case 2
            disp('Stablized');
        case 3
            disp('Ligh too weak');
        case 4
            disp('Light too strong')
        case 5
            disp('Manual control')
    end
end
status = dataRec(2,1);
end