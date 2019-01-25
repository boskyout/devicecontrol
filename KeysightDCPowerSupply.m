classdef KeysightDCPowerSupply < Device
    % copyright Tianwai@PSRL,KAIST
    % 2018/09/05, add E36311 USB interface support
    properties
        % copy this string from ConnectionExpert
        USBRsrcName = 'USB0::0x2A8D::0x1002::MY58290609::0::INSTR';
        
        thisConnectMethod = 'USB'; % USB | GPIB
    end
    
    methods
        function obj = KeysightDCPowerSupply(thisConnectMethod)
            if nargin<1 || ~(strcmp(thisConnectMethod,'USB') || strcmp(thisConnectMethod,'GPIB'))
                error('thisConnectMethod (USB or GPIB) should be set!');
            end
            obj.thisConnectMethod = thisConnectMethod;
            obj.GPIB_Addr = 5; % default is 5, you can change later
            obj.DeviceName = 'Keysight E3631 DC Power Supply';
            obj.VISA_Vendor = 'agilent';
        end
        function DevObj = Init(obj)
            if ~isunix
                obj.VISA_Vendor = 'agilent';
            end
            switch obj.thisConnectMethod
                case 'GPIB'
                    % Create GPIB object via NI Visa Driver
                    RsrcName = sprintf('GPIB%d::%d::0::INSTR',obj.GPIBControllerAddr,obj.GPIB_Addr);
                    DevObj = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
                case 'USB'
                    % Create USB object via Visa Driver
                    RsrcName = obj.USBRsrcName;
                    DevObj = instrfind('Type', 'visa-usb', 'RsrcName', obj.USBRsrcName, 'Tag', '');
                otherwise
                    error('thisConnectMethod should be set!')
            end
            if isempty(DevObj)
                DevObj = visa(obj.VISA_Vendor, RsrcName);
            else
                fclose(DevObj);
                DevObj = DevObj(1);
            end
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
    end % end of methods
    
end % end of classdef