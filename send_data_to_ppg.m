function  send_data_to_ppg(data_pattern,page)
% this function is set the data for Anritsu 3GHz PPG MP1652A

% copyright: Tianwai Bo @ KAIST
% created on Mar-10-2017

% check the input
if data_pattern<0 || data_pattern > 65535 || page < 1
    error('Invalid input!');
end

GPIB_Address = 17; % set the default GPIB address to be 14
% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
gp = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp)
    gp = visa('NI', RsrcName);
else
    fclose(gp);
    gp = gp(1);
end
% set the buffer size
gp.InputBufferSize = 1e6;
gp.OutputBufferSize = 1e6;

%% Get Data
flushoutput(gp);
flushinput(gp);
% open the connection
fopen(gp);
% change to the page
fprintf(gp,'PAG %d',page);
% set the data
fprintf(gp,'BIT %d',data_pattern);
fclose(gp);