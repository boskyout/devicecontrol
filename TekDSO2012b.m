classdef TekDSO2012b < Device
    properties
        RsrcName = 'USB0::0x0699::0x039D::C030836::0::INSTR';
    end
    methods
        function obj = TekDSO2012b()
            
        end
        function DevObj = Init(obj)
            if ~isunix
                obj.VISA_Vendor = 'agilent';
            end
            % Create USB device via Visa Driver
            DevObj = instrfind('Type', 'visa-usb', 'RsrcName', obj.RsrcName, 'Tag', '');
            if isempty(DevObj)
                DevObj = visa(obj.VISA_Vendor, obj.RsrcName);
            else
                fclose(DevObj);
                DevObj = DevObj(1);
            end
            % Set buffer
            DevObj.InputBufferSize = 1e6;
            DevObj.OutputBufferSize = 1e6;
        end
        function [y,t] = Capture(obj,ch)
            % select the waveform source
            cmd = sprintf('DATa:SOUrce CH%d',ch);
            obj.Set(cmd);
            % specify the waveform data format
            obj.Set('DATa:ENCdg ASCIi');
            obj.Set('DATa:WIDth 2');
            % transfer waveform data from the scope
            y = obj.Read('CURVe?');
            y = textscan(y,'%d','Delimiter',',');
            y = y{1};
            % get the dimension info
            gp = obj.Init();
            fopen(gp);
            ymulti = str2double(query(gp,'WFMPre:YMUlt?'));
            yzero = str2double(query(gp,'WFMPre:YZEro?'));
            yoffset = str2double(query(gp,'WFMPre:YOFf?'));
            xzero = str2double(query(gp,'WFMPre:XZEro?'));
            xoffset = str2double(query(gp,'WFMPre:PT_Off?'));
            xmulti = str2double(query(gp,'WFMPre:XINcr?'));
            y = yzero + ymulti.*(double(y(:))-yoffset);
            t = xzero + xmulti.*(1:length(y)-xoffset);
            fclose(gp);
        end
    end
end