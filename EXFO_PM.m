classdef EXFO_PM < Device
    properties
        
    end
    
    methods
        function obj = EXFO_PM(GPIBControllerAddr,GPIB_Addr)
            if nargin <1
                obj.GPIBControllerAddr = 1;
                obj.GPIB_Addr = 8;
            elseif nargin < 2
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = 8;
            else
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'EXPO PM-1600 Poewr Meter';
            obj.VISA_Vendor = 'agilent';
            obj.DevObj = obj.Init();
        end
        function pwr = Read_Power(obj)
            % get the device object
            f = obj.Init();
            % open the connection
            fopen(f);
            % send the command
            command_txt='read:pow:dc?';
            fprintf(f,command_txt);
            % read the response from device
            pwr_txt=fscanf(f,'%s');
            % convert string to double
            pwr = str2double(pwr_txt);
            % close the connection
            fclose(f);
        end
        
    end
end