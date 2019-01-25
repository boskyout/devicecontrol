% function SysInit(noOfBytes)
% Desciption: System initialization
% Input buffer: 12500 bytes
% Interrupt generated when terminator received, call function ReceiveData
if exist('s','var')
    try
        fclose(s);
        delete(s);
    catch
        clear s;
    end
end
clc
global s;
global noOfBytes;
global upperLimit_I;
global lowerLimit_I;
global range_I;
global upperLimit_Q;
global lowerLimit_Q;
global range_Q;
global upperLimit_P;
global lowerLimit_P;
global range_P;
global DACPrecision_I;
global DACPrecision_Q;
global DACPrecision_P;
global ADCPrecision;
global recordNoOfPoints;
global recordStartVoltage;
global recordEndVoltage;
global comName;
errorHappen = 0;
lowerLimit_I = -14.604;
upperLimit_I = 14.467;
lowerLimit_Q = -14.546;
upperLimit_Q = 14.372;
lowerLimit_P = -14.498;
upperLimit_P = 14.349;
range_I = upperLimit_I - lowerLimit_I;
DACPrecision_I = range_I / 4096;
range_Q = upperLimit_Q - lowerLimit_Q;
DACPrecision_Q = range_Q / 4096;
range_P = upperLimit_P - lowerLimit_P;
DACPrecision_P = range_P / 4096;
ADCPrecision = 3.814697e-5;
s = serial(comName);
set(s,'BaudRate', 57600, 'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none'); 
%set(s,'Timeout',600);
s.Timeout = 10;
s.InputBufferSize = 100000;
try
fopen(s);
catch err
    errorHappen = 1;
end
if(errorHappen == 1)
fprintf('%s open failed.\n', comName);
else
fprintf('%s open succeed.\n', comName);
end