function SetOneBranch(ch, coeff)
% SystemInit;
% pause(0.5);
SetMode(2);
pause(0.5);
b1 = ReadBias(ch);
pause(0.5);
v1 = ReadVpi(ch);
pause(0.5);
SetDAC(ch,b1+coeff*v1/2);
pause(0.5);