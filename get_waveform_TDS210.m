function y = get_waveform_TDS210()

GPIB_Address = 19;
% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB2::%d::0::INSTR',GPIB_Address);
gp = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp)
    gp = visa('agilent', RsrcName);
else
    fclose(gp);
    gp = gp(1);
end

gp.InputBufferSize = 1e6;
gp.OutputBufferSize = 1e6;

fopen(gp);

flushoutput(gp);
flushinput(gp);
fprintf(gp,'DAT:ENC ASCIi');
fprintf(gp,'CURVe?');
pause(0.01);
get_txt=fscanf(gp,'%s');
% get_txt = query(gp,'CURV?');
y = textscan(get_txt(6:end),'%d','Delimiter',',');
y = y{:};

fclose(gp);

 