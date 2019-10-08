classdef Device < handle
    % 2017-07-06: add delete methods
    properties
        DeviceName = 'General Device';
        GPIB_Addr; % DO NOT USE ADDRESS 21!!! IT IS RESERVED BY KEYSIGHT
        VISA_Vendor = 'NI';
        DevObj=[];
        GPIBControllerAddr = 0;
    end
    
    properties
        Status;
    end
    
    methods
        function DevObj = Init(obj)
            if ~isunix
                obj.VISA_Vendor = 'agilent';
            end
            % Create GPIB object via NI Visa Driver
            RsrcName = sprintf('GPIB%d::%d::0::INSTR',obj.GPIBControllerAddr,obj.GPIB_Addr);
            DevObj = instrfind('Type', 'visa-gpib', 'RsrcName', RsrcName, 'Tag', '');
            if isempty(DevObj)
                DevObj = visa(obj.VISA_Vendor, RsrcName);
            else
                fclose(DevObj);
                DevObj = DevObj(1);
            end
            obj.DevObj = DevObj;
        end
        
        function passflag = SelfTest(obj,flagPrint)
            % extCode: 0->normal;1->error
            if nargin<2
                flagPrint = 1;
            end
            gp = obj.Init();
            fopen(gp);
            message = query(gp,'*idn?');
            if ~isempty(message)
                passflag = true;
                if flagPrint
                    fprintf('Device Self Test Passed!\nDevice Info: %s\n',message);
                end
            else
                passflag = false;
            end
            fclose(gp);
        end
        
        function value = Read(obj,cmd)
            g = obj.Init();
            fopen(g);
            fprintf(g,cmd);
            txt = fscanf(g,'%s');
            %             tmp = textscan(txt,'%f','delimiter',',').';
            if isstruct(txt)
                value = txt{1};
            else
                value = txt;
            end
            fclose(g);
        end
        
        function value = ReadFloat(obj,cmd)
            txt = obj.Read(cmd);
            value = str2double(txt);
        end
        
        function Set(obj,cmd)
            g = obj.Init();
            fopen(g);
            fprintf(g,cmd);
            fclose(g);
        end
        
        function retVal = xfprintf(obj,g,cmd,flagIgnoreErr)
            retVal = 0;
            fprintf(g,cmd);
            query(g,'*opc?');
            result = query(g,':syst:err?');
            if (isempty(result))
                fclose(g);
                errordlg({'The Device did not respond a :SYST:ERRor query.' ...
                    'Please check that the firmware is running and responding to commands.'}, 'Error');
                retVal = -1;
                return
            end
            if (~exist('flagIgnoreErr', 'var') || flagIgnoreErr == 0)
                while (~strncmp(result, '0,""',4))
                    errordlg({'Device returns an error on command:' 'Error Message:' result});
                    result = query(g, ':syst:err?');
                    retVal = -1;
                end
            end
            return;
        end
        
        function delete(obj)
            if ~isempty(obj.DevObj) % add this line to avoid the warning from an empty DevObj
                if isvalid(obj.DevObj)
                    fclose(obj.DevObj);
                    delete(obj.DevObj);
                end
            end
        end
    end
end