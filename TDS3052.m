classdef TDS3052 < Device
    methods
        function obj = TDS3052(GPIBControllerAddr,GPIB_Addr)
            if nargin <1
                obj.GPIBControllerAddr = 2;
                obj.GPIB_Addr = 19;
            elseif nargin<2
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = 19;
            else
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Tektronix TDS 3052 Real-time Scope';
            obj.VISA_Vendor = 'Agilent';
            obj.DevObj = obj.Init();
        end
        function SetTimeScale(obj,time_scale)
            gp = obj.Init();
            fopen(gp);
            time_txt = regexprep(sprintf('%1.0E',time_scale),'E-0','E-');
            time_txt = regexprep(time_txt,'E\+0','E');
            cmd = sprintf('HORizontal:MAIn:SCAle %s',time_txt);
            fprintf(gp,cmd);
            fclose(gp);
        end
        function Stop(obj)
            gp = obj.Init();
            fopen(gp);
            fprintf(gp,'ACQuire:STOPAfter RUNSTop');
            fprintf(gp,'ACQuire:STATE STOP');
            fclose(gp);
        end
        function Run(obj)
            gp = obj.Init();
            fopen(gp);
            fprintf(gp,'ACQuire:STOPAfter RUNSTop');
            fprintf(gp,'ACQuire:STATE RUN');
            fclose(gp);
        end
        
        function [t,y,debugInfo] = GetWaveform(obj,ch)
            gp = obj.Init();
            gp.InputBufferSize = 1e6;
            gp.OutputBufferSize = 1e6;
            fopen(gp);
            %             fprintf(gp,'ACQuire:STOPAfter RUNSTop');
            %             fprintf(gp,'ACQuire:STATE STOP');
            %             fprintf(gp,'ACQuire:STOPAfter SEQUENCE');
            %             status = 49;
            %             while(status==49)
            %                 tmp=query(gp,'ACQuire:STATE?');
            %                 status = double(tmp(1));
            %             end
            flushoutput(gp);
            flushinput(gp);
            fprintf(gp,'DAT:ENC ASCIi');
            fprintf(gp,sprintf('DATa:SOUrce CH%d',ch));
            fprintf(gp,'DATa:WIDth 2'); % two byte ASCII
            fprintf(gp,'CURVe?');
            pause(0.01);
            get_txt=fscanf(gp,'%s');
            % get_txt = query(gp,'CURV?');
            y = textscan(get_txt(1:end),'%d','Delimiter',',');
            ymulti = str2double(query(gp,'WFMPre:YMUlt?'));
            yzero = str2double(query(gp,'WFMPre:YZEro?'));
            yoffset = str2double(query(gp,'WFMPre:YOFf?'));
            xzero = str2double(query(gp,'WFMPre:XZEro?'));
            xoffset = str2double(query(gp,'WFMPre:PT_Off?'));
            xmulti = str2double(query(gp,'WFMPre:XINcr?'));
            y = yzero + ymulti.*(double(y{:})-yoffset);
            t = xzero + xmulti.*(1:length(y)-xoffset);
            debugInfo.preamble = query(gp,'WFMPre?');
            
            fclose(gp);
        end
    end
end