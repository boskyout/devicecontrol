function [power] = ReadPower()
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
byteID=101;
byteData=[0 0 0 0 0 0];
fwrite(s,[byteID byteData]);
dataRec = fread(s,9);
returnedByteID = dataRec(1,1);
if(returnedByteID ~= byteID)
    status = 102;
    disp('Unknown Error. Please try again')
    return;
end
answerHex = strcat(dec2hex(dataRec(5,1),2),dec2hex(dataRec(4,1),2),dec2hex(dataRec(3,1),2),dec2hex(dataRec(2,1),2));
convertedData = typecast(uint32(hex2dec(answerHex)),'single');
power = convertedData;
end