% HP 8168C Tunable Laser Driver
start_wave = 1530; % unit: nm
step_wave = 0.1; % unit: nm
stop_wave = 1565; % unit: nm
time_last = 5; % unit: s
power = 0; % unit: dBm
% GPIB address of HP x8168C
GPIB_Address = 20;
% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
dev = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(dev)
    dev = visa('NI', RsrcName);
else
    fclose(dev);
    dev = dev(1);
end
% open the connection
fopen(dev);
% display the device information
fprintf(dev,'*IDN?');
disp(fscanf(dev));

% set power
fprintf(dev,sprintf(':POW:LEV %f',power));
% start the wavelength scanning
for wave = start_wave:step_wave:stop_wave
    cmd = sprintf(':WAVE %f NM',wave);
    fprintf(dev,cmd);
    fprintf(dev,':OUTP ON');
    disp(['Current Wavelength:',num2str(wave),'nm']);
    pause(time_last);
end
% close the connection
fclose(dev);