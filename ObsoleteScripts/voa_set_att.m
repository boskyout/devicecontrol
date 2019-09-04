function voa_set_att(Target_ATT, GPIB_Address)
% this function is to set the attenuation value of a variable optical attenuator
% input: Target_ATT, GPIB_Address
% output: none
% Copyright @ Guo-wei Lu
% Revised by Tianwai Bo @ KAIST on Nov-3-2016

% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
gp_JDSU_HA9 = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp_JDSU_HA9)
    gp_JDSU_HA9 = visa('NI', RsrcName);
else
    fclose(gp_JDSU_HA9);
    gp_JDSU_HA9 = gp_JDSU_HA9(1);
end
% open the connection
fopen(gp_JDSU_HA9);
% read the current attenuation
command_txt=sprintf('%s','ATT?');
fprintf(gp_JDSU_HA9,command_txt);
Current_ATT_txt=fscanf(gp_JDSU_HA9,'ATT%s');
Current_ATT=str2double(Current_ATT_txt);
fclose(gp_JDSU_HA9);
  pause(1);

% start setting the Attenuation
if Target_ATT >=0 && Target_ATT <=60 && Current_ATT >=0 && Current_ATT <=60
    % case I
    while Target_ATT > Current_ATT
        fopen(gp_JDSU_HA9);
            % pause(1)
            Current_ATT=Current_ATT+0.2;
            output_ATT=Current_ATT;
            command_txt=sprintf('ATT %2.3f', output_ATT);
            fprintf(gp_JDSU_HA9,command_txt);
        %    pause(0.005)
            pause(0.001);
        fclose(gp_JDSU_HA9);
    end
    % case II
    while Target_ATT < Current_ATT
        fopen(gp_JDSU_HA9);
            %  pause(1)
            Current_ATT=Current_ATT-0.2;
            output_ATT=Current_ATT;
            command_txt=sprintf('ATT %2.2f', output_ATT);
            fprintf(gp_JDSU_HA9,command_txt);
        %    pause(0.005)
            pause(0.001);
        fclose(gp_JDSU_HA9);
    end
    % now set the attenuation
    fopen(gp_JDSU_HA9);
        command_txt=sprintf('ATT %2.2f', Target_ATT);
        fprintf(gp_JDSU_HA9,command_txt);
        pause(0.01);
    fclose(gp_JDSU_HA9);
end