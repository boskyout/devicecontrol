% test scripts go here

DCPS = KeysightDCPowerSupply();
PM = HP8153A;
% init the DC power supply
DCPS.Set_Voltage_Current('p6v',0,0.001);
DCPS.Set_Voltage_Current('p25v',0,0.2);
DCPS.Set_Voltage_Current('n25v',0,0.2);