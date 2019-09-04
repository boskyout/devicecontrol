function [trace_x, trace_y] = GetOSATrace(traceid, n_avg)
% The function is used to get the trace from Yokogawa OSA AQ6370C via
% TCP/IP. Compared with GPIB approach, the buffer size is larger and 
% data speed is faster.
% Input: traceid    : string, indicate the trace number
%        n_avg      : integer, number of iterations for trace averaging
% Output: trace_x   : wavelength axis
%         trace_y   : waveform data
%% Init parameters
ip = '192.168.0.63'; % IP address of the OSA, you can modify it here
center = 1535.328; % unit nm
span = 0.5; % unit nma
%% Connect to the OSA
RsrcName = strcat('TCPIP-',ip);
Obj = instrfind('Type','tcpip','Name',RsrcName,'Tag','');
if isempty(Obj)
    Obj = tcpip(ip,10001);
else
    fclose(Obj);
    Obj = Obj(1);
end
% set the buffer size
Obj.InputBufferSize = 8e6;
Obj.OutputBufferSize = 8e6;
% open the tcpip connection
fopen(Obj);
% authentication
fprintf(Obj,'OPEN "anonymous" ""')
%% OSA Init
% init
fprintf(Obj,':INITiate:SMODe 1');
pause(0.01);
fprintf(Obj,'CFORM1');
pause(0.01);
% set the center wavelength and span
fprintf(Obj,sprintf(':sens:wav:cent %fnm',center));
pause(0.01);
fprintf(Obj,sprintf(':sens:wav:span %fnm',span));
% fprintf(Obj,':sens:wav:span 2nm');
pause(0.01);
%% Get Data
flushoutput(Obj);
flushinput(Obj);
% get the number of samples from OSA configuration
fprintf(Obj,':SENS:SWE:POIN?')
txt = fscanf(Obj,'%s');
n_samp = str2num(txt);
% get the wavelength data
fprintf(Obj,sprintf(':TRAC:X? TR%s,%d,%d',traceid,1,n_samp));
pause(0.01);
get_txt = fscanf(Obj,'%s');
x = textscan(get_txt,'%f','delimiter',',');
trace_x = x{1};
% get the waveform (power) data, n_avg iterations are averaged
trace_y = zeros(n_samp,1);
for iter = 1:n_avg
    fprintf(Obj,sprintf(':TRAC:Y? TR%s,%d,%d',traceid,1,n_samp));
    pause(0.01);
    get_txt = fscanf(Obj,'%s');
    y = textscan(get_txt,'%f','delimiter',',');
    trace_y = trace_y + y{1};
end
trace_y = trace_y./n_avg;


