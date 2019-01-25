function [b1,b2] = SetQuadBias(coeff,b1,b2)
% SystemInit;
% pause(0.5);
if nargin < 2
    b1 = [];
    b2 = [];
end
SetMode(2);
pause(0.5);
if isempty(b1) && isempty(b2)
    b1 = ReadBias(1);
    pause(0.5);
    b2 = ReadBias(2);
    pause(0.5);
end
v1 = ReadVpi(1);
pause(0.5);
v2 = ReadVpi(2);
pause(0.5);
SetDAC(1,b1+coeff*v1/2);
pause(0.5);
SetDAC(2,b2+coeff*v2/2);
pause(0.5);