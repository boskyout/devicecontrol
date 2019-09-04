function optopower = read_power(mod_num, n_avg, GPIB_Address)
% this function is to read the power from HP power sensor
% input: mod_num: the index of the module in the mainframe [1,2]
%        n_avg: the number of iterations for power measurement and averaging
%        GPIB_Address: GPIB address default is 14
% output: optopower: the power measurement in dBm
% copyright: Tianwai Bo @ KAIST
% created on Nov-3-2016

if nargin < 3
    GPIB_Address = 14; % set the default GPIB address to be 14
end

if nargin < 2
    n_avg = 5;
end

% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
gp_PowerMeter = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp_PowerMeter)
    gp_PowerMeter = visa('agilent', RsrcName);
else
    fclose(gp_PowerMeter);
    gp_PowerMeter = gp_PowerMeter(1);
end
% open the connection
fopen(gp_PowerMeter);
    for idx = 1:n_avg
        command_txt=sprintf('read%d:pow?',mod_num);
        fprintf(gp_PowerMeter,command_txt);
        Current_power_txt=fscanf(gp_PowerMeter,'%s');
        Current_Power(idx)=str2double(Current_power_txt);
    end
fclose(gp_PowerMeter);

optopower = mean(Current_Power);