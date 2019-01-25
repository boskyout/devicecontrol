function [] = SetDitherAmp(ditherAmpI,ditherAmpQ)
global s;
if(s.BytesAvailable ~= 0)
    fread(s,s.BytesAvailable);
end
byteID = 111;     
byteData = [ditherAmpI ditherAmpQ 0 0 0 0];
fwrite(s,[byteID byteData]);
pause(1);
SystemInit;
end