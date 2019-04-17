StartWork;

RsrcName = 'USB0::0x2A8D::0x1002::MY58290606::0::INSTR';
pc = KeysightE36311A(RsrcName);
pm = Keysight8163B();


dc_vec = 0:-0.2:-10;

for idx = 1:length(dc_vec)
    bias = dc_vec(idx);
    % set the voltage
    pc.Set_Voltage('n25v',bias);
    pause(0.2);
    % read the current
    current(idx) = pc.Read_Current('n25v');
    % read the power
    power(idx) = pm.Read_Power(1,2);
    % disp
    disp(num2str(bias));
end

att = 0;
power = power + att;
save('Data\DML_LI.mat','dc_vec','current','power');