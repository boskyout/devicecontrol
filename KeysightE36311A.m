classdef KeysightE36311A < Device
    % copyright Tianwai@PSRL,KAIST
    % created on 2018/09/05
    % combined in KeysightDCPowerSupply Function
    
    properties
        % copy this string from ConnectionExpert
        RsrcName = 'USB0::0x2A8D::0x1002::MY58290609::0::INSTR'; 
    end
    methods
        function obj = KeysightE36311A(RsrcName)
            if nargin < 1
                obj.RsrcName = 'USB0::0x2A8D::0x1002::MY58290609::0::INSTR'; 
            else
                obj.RsrcName = RsrcName;
            end
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
        end
        function Set_Voltage(obj, channel_id, voltage)
            % set the voltage limit of the specified channel only
            obj.DevObj = obj.Init();
            % open the connection
            fopen(obj.DevObj);
            command_txt=sprintf('appl %s, %3.3f',channel_id,voltage);
            fprintf(obj.DevObj,command_txt);
            pause(0.1);
            fclose(obj.DevObj);
        end
        function pwr = Read_Current(obj,channel_id)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            pwr = str2double(query(obj.DevObj,sprintf('MEAS:CURR? %s',channel_id)));
            fclose(obj.DevObj);
        end
        function Set_Voltage_Current(obj, channel_id, voltage, current)
            % set the voltage and current limit of the specified channel simultaneously
            obj.DevObj = obj.Init();
            % open the connection
            fopen(obj.DevObj);
            command_txt=sprintf('appl %s, %3.3f, %3.3f',channel_id,voltage,current);
            fprintf(obj.DevObj,command_txt);
            pause(0.1);
            fclose(obj.DevObj);
        end
    end
end