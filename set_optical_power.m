function [out_pwr] = set_optical_power(target_power,VOA,PM,mon_chn)
current_power = PM.Read_Power(mon_chn,5);
pause(0.1);
att_diff = target_power - current_power;
current_att = VOA.Read_Current_ATT();
new_att = current_att + att_diff;
VOA.Set_Att_Directly(-new_att);
pause(0.1);
out_pwr = PM.Read_Power(mon_chn,5);
pause(0.1);