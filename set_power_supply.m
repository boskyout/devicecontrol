function set_power_supply(channel_id, voltage, current, GPIB_Address)
% this function is to set the voltage, current of the power supple (Keysight E3631A)
% input: channel_idx: the index of the module in the mainframe [1,2]
%        voltage: the set voltage value;
%        current: the set current value;
%        GPIB_Address: GPIB address default is 14
% output: optopower: the power measurement in dBm
% copyright: Tianwai Bo @ KAIST
% created on Nov-12-2016

if nargin < 4
    GPIB_Address = 5; % set the default GPIB address to be 5
end

% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
gp_PowerSupply = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp_PowerSupply)
    gp_PowerSupply = visa('NI', RsrcName);
else
    fclose(gp_PowerSupply);
    gp_PowerSupply = gp_PowerSupply(1);
end

% open the connection
fopen(gp_PowerSupply);
    command_txt=sprintf('appl %s, %3.3f, %3.3f',channel_id,voltage,current);
    fprintf(gp_PowerSupply,command_txt);
    % check the output
    fprintf(gp_PowerSupply,'outp?');
    status = fscanf(gp_PowerSupply);
    if str2double(status) == 0
         fprintf(gp_PowerSupply,'outp on');
    end
fclose(gp_PowerSupply);