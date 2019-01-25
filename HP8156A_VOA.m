classdef HP8156A_VOA < Device
    
    properties (Dependent = true)
        Current_ATT;
    end
    
    methods
        function obj = HP8156A_VOA(GPIB_Addr)
            if nargin <1
                obj.GPIB_Addr = 10;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'HP 8156 VOA';
            obj.VISA_Vendor = 'Agilent';
            obj.DevObj = obj.Init();
            obj.Enable();
        end
        
        function Set_Att(obj,att)
            obj.DevObj = obj.Init();
            step = 0.2;
            fopen(obj.DevObj);
            current_att = -str2double(query(obj.DevObj,'inp:att?'));
            diff = att - current_att;
            while(abs(diff) > step)
                fprintf(obj.DevObj,sprintf('inp:att %2.3f',current_att+...
                    sign(diff)*step));
                current_att = -str2double(query(obj.DevObj,'ATT?'));
                diff = att - current_att;
                pause(0.1);
            end
            % it is safe to set the att to the desired value
            fprintf(obj.DevObj,sprintf('inp:att %2.3f',att));
            fclose(obj.DevObj);
        end
        
        function Set_Att_Directly(obj,att)
            obj.DevObj = obj.Init();
            fopen(obj.DevObj);
            fprintf(obj.DevObj,sprintf('inp:att %2.3f',att));
            fclose(obj.DevObj);
        end
        
        function Current_ATT = get.Current_ATT(obj)
            fopen(obj.DevObj);
            fprintf(obj.DevObj,'inp:att?');
            txt=fscanf(obj.DevObj);
            Current_ATT = str2double(txt);
            fclose(obj.DevObj);
        end
        
        function Enable(obj)
            obj.DevObj = obj.Init();
            % enable the output
            fopen(obj.DevObj);
            char = query(obj.DevObj,':outp?');
            if char(2)~='1'
                fprintf(obj.DevObj,':outp ON');
            end
            fclose(obj.DevObj);
        end
    end
    
end