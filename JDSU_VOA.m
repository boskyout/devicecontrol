classdef JDSU_VOA < Device
    properties
        
    end
    
    methods
        function obj = JDSU_VOA()
            if nargin <1
                obj.GPIB_Addr = 23;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'JDSU HA9 VOA';
            obj.VISA_Vendor = 'agilent';
            obj.DevObj = obj.Init();
        end
        function Set_Att_Directly(obj,att)
                obj.DevObj = obj.Init();
                fopen(obj.DevObj);
                obj.xfprintf(obj.DevObj,sprintf('ATT %2.2f DB',att));
                query(obj.DevObj,'*opc?');
                fclose(obj.DevObj);
            end
        function Current_ATT = Read_Current_ATT(obj)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            txt = query(obj.DevObj,'ATT?');
            query(obj.DevObj,'*opc?');
            Current_ATT = str2double(txt);
            fclose(obj.DevObj);
        end
    end