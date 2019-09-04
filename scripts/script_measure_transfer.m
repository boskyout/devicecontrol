clear; close all;

DCPS = KeysightDCPowerSupply();
PM =  HP8153A();

if ~isunix
    DCPS.VISA_Vendor = 'agilent';
    PM.VISA_Vendor = 'agilent';
end

% init the DC power supply
DCPS.Set_Voltage_Current('p6v',0,0.001);
DCPS.Set_Voltage_Current('p25v',0,0.2);
DCPS.Set_Voltage_Current('n25v',0,0.2);

start = -6;
stop = 0;
step = 0.05;

voltage = start:step:stop;

for idx = 1:length(voltage);
    DCPS.Set_Voltage('n25v',voltage(idx));
    pause(0.2);
    power(idx) = PM.Read_Power(2,5);
    pause(0.2);
    disp([num2str(voltage(idx)),':',num2str(power(idx))]);
end

data = [voltage.' power.'];

filename = 'DD-MZM_20170530.csv';
dlmwrite(filename,data,'-append');
