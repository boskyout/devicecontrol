clear;close all;

ipaddr = '172.16.102.8';
vna = RSVNA(ipaddr);
pc = KeysightE36311A();

freq_start = 10e6;
freq_stop  = 40e9;
npoints = 2001;

freq = linspace(freq_start,freq_stop,npoints);

dc_vec = 0:-0.1:-3.5;

for idx = 1:length(dc_vec)
    % set the power supply
    pc.Set_Voltage('n25v',dc_vec(idx));
    pause(0.1);
    % read the VNA
    vna.Single();
    pause(4.5);
    cplxRsp = vna.GetResponse();
    % save
    filename = sprintf('Data\\EML584\\%1.1fv_0km.mat',dc_vec(idx));
    save(filename,'cplxRsp','freq');
    % disp
    disp(num2str(dc_vec(idx)));
end