%Brief: Return current polar of controller
function [polarI,polarQ,polarP]=ReadPolar()
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
byteID=104;
byteData=[0 0 0 0 0 0];
fwrite(s,[byteID byteData]);
dataRec = fread(s,9);
returnedByteID = dataRec(1,1);
if(returnedByteID ~= byteID)
    status = 102;
    disp('Unknown Error. Please try again')
    return;
end
polarI = dataRec(2,1)+1;
polarQ = dataRec(3,1)+1;
polarP = dataRec(4,1)+1;
if(polarI == 1)
    disp('Polar I: Positive');
else
    disp('Polar I: Negative')
end
if(polarQ == 1)
    disp('Polar Q: Positive');
else
    disp('Polar Q: Negative')
end
if(polarP == 1)
    disp('Polar P: Positive');
else
    disp('Polar P: Negative')
end
end