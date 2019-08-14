classdef KeysightAWG < Device
    % Rev v0.2
    % Created by Tianwai@PSRL,KAIST
    % Package to control Keysight AWG
    properties
       channelMapping;
       arbConfig;
       AWGSamplingRate = 64e9;
       channelConfig;
       AWGmodel = 'M8195A_2ch_256k';
       
       ipaddr = '192.168.0.168';
       port = 5025;
       
       flagNotification = true;
       flagRunAfterLoad = true;
    end

    methods
        function obj = KeysightAWG(ipaddr,port,modMethod,model)
            if nargin <1
                % use default
                ipaddr = '192.168.0.168';
                port = 5025;
                modMethod = 'IQ';
                model = 'M8195A_2ch_256k';
            end
            
            % configure remote interface to the AWG
            obj.ipaddr = ipaddr;
            obj.port = port;
            obj.AWGmodel = 'M8195A_2ch_256k';
            obj.arbConfig = getArbConfig(ipaddr,port,model);
            % configure the channel mapping
            obj.SetChannelMapping(modMethod); % 'IQ'|'CH1'|'CH4';
            fprintf('AWG is configured with %s mode\n',modMethod);
        end
        
        function obj = SetChannelMapping(obj,modMethod)
            switch lower(modMethod)
                case 'iq'
                    obj.channelMapping = [1 0;0 0;0 0;0 1]; % channel mapping: 1|2 : I|Q;
                case 'ch1'
                    obj.channelMapping = [1 0;0 0;0 0;0 0];
                case 'ch4'
                    obj.channelMapping = [0 0;0 0;0 0;1 0];
                otherwise
                    errordlg('invalid modulation method!','Error');
            end
        end
        
        function DevObj = Init(obj)
            DevObj = iqopen(obj.arbConfig);
            fclose(DevObj);
        end
        
        function result = SendDataToAWG(obj,data)
            % check the validity of data to be sent to AWG
            if mod(length(data),obj.arbConfig.segmentGranularity)
                error('Data length does not satisfy the granularity requirement!');
            end
            % if no problem, call iqdownload to send
            result = iqdownload(data, obj.AWGSamplingRate,...
                'arbConfig',obj.arbConfig,...
                'channelMapping',obj.channelMapping,...
                'run',obj.flagRunAfterLoad);
        end
        
        function result = SetSkew(obj,data,delay)
            if obj.flagNotification
               fprintf('Adding skew triggers reloading the data to AWG\n'); 
            end
            obj.arbConfig.skew = delay;
            result = obj.SendDataToAWG(data);
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
            % update the channel setting
            obj.arbConfig.amplitude(chan) = amp;
        end
        
        function retVal = xfprintf(~, f, s, ignoreError)
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