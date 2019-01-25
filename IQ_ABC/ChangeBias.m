function ChangeBias(bias)
% SystemInit;
% pause(0.5);
SetMode(2);
pause(0.5);
b1 = ReadBias(1);
pause(0.5);
b2 = ReadBias(2);
pause(0.5);
SetDAC(1,b1+bias);
pause(0.5);
SetDAC(2,b2+bias);
pause(0.5);