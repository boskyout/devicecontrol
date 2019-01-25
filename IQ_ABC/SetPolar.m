function [status] = SetPolar(polarI,polarQ,polarP)
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
byteID=108;
byteData=[polarI polarQ polarP 0 0 0];
fwrite(s,[byteID byteData]);
dataRec = fread(s,9);
returnedByteID = dataRec(1,1);
if(returnedByteID ~= byteID)
    status = 102;
    disp('Unknown Error. Please try again')
    return;
end
status = dataRec(2,1);
end