function [status]=SetDAC(arm,voltage)
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
if(voltage >= 0)
    dataThree = 0;
else
    dataThree = 1;
end
tempVoltage = floor(abs(voltage)*1000);
dataOne = floor(tempVoltage/256);
dataTwo = rem(tempVoltage,256);
byteID = 107;     
byteData = [arm dataOne dataTwo dataThree 0 0];
fwrite(s,[byteID byteData]);
dataRec = fread(s,9);
status = dataRec(2,1);
end