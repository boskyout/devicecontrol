function voa_set_att_agilent(Target_ATT, GPIB_Address)
% this function is to set the attenuation value of a variable optical attenuator
% input: Target_ATT, GPIB_Address
% output: none
% Copyright @ Guo-wei Lu
% Revised by Tianwai Bo @ KAIST on Nov-3-2016

if nargin < 2
    GPIB_Address = 8; % set the default GPIB address
end

% Create GPIB object via NI Visa Driver
RsrcName = sprintf('GPIB0::%d::0::INSTR',GPIB_Address);
gp_Agilent_8156a = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
if isempty(gp_Agilent_8156a)
    gp_Agilent_8156a = visa('agilent', RsrcName);
else
    fclose(gp_Agilent_8156a);
    gp_Agilent_8156a = gp_Agilent_8156a(1);
end
% open the connection
fopen(gp_Agilent_8156a);
% read the current attenuation
command_txt=sprintf('%s','inp:att?');
fprintf(gp_Agilent_8156a,command_txt);
Current_ATT_txt=fscanf(gp_Agilent_8156a);
Current_ATT=str2double(Current_ATT_txt);
fclose(gp_Agilent_8156a);
  pause(1);

% start setting the Attenuation
if Target_ATT >=0 && Target_ATT <=60 && Current_ATT >=0 && Current_ATT <=60
    % case I
    while Target_ATT > Current_ATT
        fopen(gp_Agilent_8156a);
            % pause(1)
            Current_ATT=Current_ATT+0.2;
            output_ATT=Current_ATT;
            command_txt=sprintf('inp:att %2.2f', output_ATT);
            fprintf(gp_Agilent_8156a,command_txt);
        %    pause(0.005)
            pause(0.001);
        fclose(gp_Agilent_8156a);
    end
    % case II
    while Target_ATT < Current_ATT
        fopen(gp_Agilent_8156a);
            %  pause(1)
            Current_ATT=Current_ATT-0.2;
            output_ATT=Current_ATT;
            command_txt=sprintf('ATT %2.2f', output_ATT);
            fprintf(gp_Agilent_8156a,command_txt);
        %    pause(0.005)
            pause(0.001);
        fclose(gp_Agilent_8156a);
    end
    % now set the attenuation
    fopen(gp_Agilent_8156a);
        command_txt=sprintf('inp:att %2.2f', Target_ATT);
        fprintf(gp_Agilent_8156a,command_txt);
        pause(0.01);
    fclose(gp_Agilent_8156a);
end