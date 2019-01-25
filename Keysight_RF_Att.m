classdef Keysight_RF_Att < Device
    properties
        
    end
    
    methods
        function obj = Keysight_RF_Att()
            if nargin <1
                obj.GPIB_Addr = 24;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Keysight J7211C Variable Attenuator';
            obj.VISA_Vendor = 'agilent';
            obj.DevObj = obj.Init();
        end
        function Set_Att(obj,att)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            obj.xfprintf(obj.DevObj,sprintf('ATT %d',att));
            query(obj.DevObj,'*opc?');
            fclose(obj.DevObj);
        end
        function Current_ATT = Read_ATT(obj)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            txt = query(obj.DevObj,'ATT?');
            query(obj.DevObj,'*opc?');
            Current_ATT = str2double(txt);
            fclose(obj.DevObj);
        end
        function Increase_Att(obj,att)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            obj.xfprintf(obj.DevObj,sprintf('INCR %d',att));
            query(obj.DevObj,'*opc?');
            fclose(obj.DevObj);
        end
        function Decrease_Att(obj,att)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            obj.xfprintf(obj.DevObj,sprintf('DECR %d',att));
            query(obj.DevObj,'*opc?');
            fclose(obj.DevObj);
        end
    end