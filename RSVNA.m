classdef RSVNA < Device
    % copyright Tianwai@PSRL,KAIST
    % created on 2019/04/1
    % combined in R&S VNA ZNB40
    
    properties
        IPaddr = '192.168.0.88';
        thisConnectMethod = 'TCPIP'; %GPIB | TCPIP
        SlotInfo;
    end
    
    methods
        function obj = RSVNA(IPaddr)
            if nargin <1
                obj.IPaddr = '192.168.0.88';
            else
                obj.IPaddr = IPaddr;
            end
            obj.DeviceName = 'R&S VNA ZNB40';
            obj.VISA_Vendor = 'agilent';
            
        end
        
        function y = GetResponse(obj)
            % read the magnitude part
            cmd = 'CALCulate1:FORMat MLIN';
            obj.Set(cmd);
            cmd = 'CALCulate1:DATA? FDATa';
            txt = obj.Read(cmd);
            y_abs = obj.txt2float(txt);
            % read the Imaginary part
            cmd = 'CALCulate1:FORMat Phase';
            obj.Set(cmd);
            cmd = 'CALCulate1:DATA? FDATa';
            txt = obj.Read(cmd);
            y_phase = obj.txt2float(txt);
            % output
            y = y_abs.*exp(1i.*y_phase/180*pi);
            % change back to magnitude (db)
            obj.Set('CALCulate1:FORMat MLOG');
        end
        
        function y = GetMagResponse(obj)
                        % read the Real part
            cmd = 'CALCulate1:FORMat MLOGarithmic';
            obj.Set(cmd);
            cmd = 'CALCulate1:DATA? FDATa';
            txt = obj.Read(cmd);
            y = obj.txt2float(txt);
        end
        
        function data = txt2float(obj,txt)
            tmp = textscan(txt,'%f','Delimiter',',');
            data = tmp{1};
        end
        
        function Single(obj)
            % refer to page 1262
            cmd = 'INITiate1:IMMediate';
            obj.Set(cmd);
            obj.Set('*WAI');
        end
        
        
        function DevObj = Init(obj)
            % Create TCPIP object via Visa Driver
            RsrcName = sprintf('TCPIP0::%s::5025::SOCKET',obj.IPaddr);
            DevObj = instrfind('Type', 'visa-generic', 'RsrcName', RsrcName, 'Tag', '');
            if isempty(DevObj)
                DevObj = visa(obj.VISA_Vendor, RsrcName);
            else
                fclose(DevObj);
                DevObj = DevObj(1);
            end
            DevObj.InputBufferSize = 1e6;
            DevObj.OutputBufferSize = 1e6;
            % set the obj.DevObj for the general use
            obj.DevObj = DevObj;
        end
        
    end
end