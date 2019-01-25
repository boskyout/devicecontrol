function [waveform,t] = read_DCA_waveform()
% this function is to read the waveform from HP 83480A

% copyright: Tianwai Bo @ KAIST
% created on Mar-10-2017

GPIB_Address = 30; % set the default GPIB address to be 14
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
% set the data source to Channel 2
fprintf(gp,':waveform:source channel2');
fprintf(gp,':sing');
% get the data
fprintf(gp,':wav:data?');
waveform_txt = fscanf(gp,'%s');
waveform = textscan(waveform_txt,'%f','delimiter',',');
% get the time scale
scale = str2double(query(gp,':tim:scal?'));
fprintf(gp,':run');
fclose(gp);

waveform = waveform{1};
t = scale*10/length(waveform)*(0:1:length(waveform)-1);