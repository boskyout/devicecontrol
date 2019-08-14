classdef KeysightAWG < Device
    methods
        function obj = KeysightAWG()
            obj.DeviceName = 'Keysight AWG M8196A';
            obj.VISA_Vendor = 'agilent';
            obj.DevObj = obj.Init();
            % set the buffer size
            obj.DevObj.InputBufferSize = 1e6;
            obj.DevObj.OutputBufferSize = 1e6;
            flushoutput(obj.DevObj);
            flushinput(obj.DevObj);
        end
        
        function DevObj = Init(obj)
            if ~isunix
                obj.VISA_Vendor = 'agilent';
            end
            % Create GPIB object via Visa Driver
%             RsrcName = 'TCPIP0::WINDOWS-Q88N2GU::5025::SOCKET';
            RsrcName = 'TCPIP0::192.168.0.168::5025::SOCKET';
            DevObj = instrfind('Type', 'visa-generic', 'RsrcName', RsrcName, 'Tag', '');
            if isempty(DevObj)
                DevObj = visa(obj.VISA_Vendor, RsrcName);
                % set the buffer size
                DevObj.InputBufferSize = 1e6;
                DevObj.OutputBufferSize = 1e6;
                flushoutput(DevObj);
                flushinput(DevObj);
            else
                fclose(DevObj);
                DevObj = DevObj(1);
            end
        end
        
        function [response] = Query_Calibration(obj,channel,amp)
            obj.DevObj = obj.Init();
            % open the connection
            fopen(obj.DevObj);
            % set the data source to Channel
            txt = query(obj.DevObj,sprintf(':CHAR%d? %d',channel,amp));
            y = textscan(txt(2:end-2),'%f','Delimiter',',');
            response = y{1};
            response = reshape(response,3,[]).';
            % get the data
            fclose(obj.DevObj);
        end
        
        function retVal = SetAmp(obj,chan,amp)
            % chan: Channel ID
            % amp: Amplitude to be set
            if amp > 1 || amp < 0
                error('invalid amplitude value');
            end
            f = obj.Init();
            fopen(f);
            retVal = obj.xfprintf(f,sprintf(':VOLTage%d:AMPLitude %g',...
                chan, amp));
            fclose(f);
            flushoutput(f);
            flushinput(f);
        end
        
        function retVal = xfprintf(obj, f, s, ignoreError)
            % Send the string s to the instrument object f
            % and check the error status
            % if ignoreError is set, the result of :syst:err is ignored
            % returns 0 for success, -1 for errors
            
            retVal = 0;
            % % set debugScpi=1 in MATLAB workspace to log SCPI commands
            %     if (evalin('base', 'exist(''debugScpi'', ''var'')'))
            %         fprintf('cmd = %s\n', s);
            %     end
            fprintf(f, s);
            result = query(f, ':syst:err?');
            if (isempty(result))
                fclose(f);
                errordlg({'The M8196A firmware did not respond to a :SYST:ERRor query.' ...
                    'Please check that the firmware is running and responding to commands.'}, 'Error');
                retVal = -1;
                return;
            end
            if (~exist('ignoreError', 'var') || ignoreError == 0)
                while (~strncmp(result, '0,No error', 10) && ~strncmp(result, '0,"No error"', 12))
                    errordlg({'M8196A firmware returns an error on command:' s 'Error Message:' result});
                    result = query(f, ':syst:err?');
                    retVal = -1;
                end
            end
        end
        
    end
end