classdef AgilentDCA < Device
    methods
        function obj = AgilentDCA(GPIB_Addr)
            if nargin <1
                obj.GPIB_Addr = 7;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Agilent 86100B DCA';
            obj.VISA_Vendor = 'Agilent';
            obj.DevObj = obj.Init();
            % set the buffer size
            obj.DevObj.InputBufferSize = 1e6;
            obj.DevObj.OutputBufferSize = 1e6;
            flushoutput(obj.DevObj);
            flushinput(obj.DevObj);
        end
        
        function [Waveform] = Read_Waveform(obj,channel,n_avg)
            if nargin < 2
                n_avg = 1;
            end
            obj.DevObj = obj.Init();
            % read the waveform
            % open the connection
            fopen(obj.DevObj);
            % set the data source to Channel
            fprintf(obj.DevObj,sprintf(':waveform:source channel%d',channel));
            % get the data
            for idx = 1:n_avg
                fprintf(obj.DevObj,':sing');
                fprintf(obj.DevObj,':wav:data?');
                waveform_txt = fscanf(obj.DevObj,'%s');
                wf_temp = textscan(waveform_txt,'%f','delimiter',',').';
                wf(idx,:) = wf_temp{1};
                pause(0.1);
            end
            if n_avg ~= 1
                wf = mean(wf);
            end
            Waveform.Waveform = wf;
            % get the time scale
            Waveform.scale = str2double(query(obj.DevObj,':tim:scal?'));
            Waveform.t = Waveform.scale*(0:length(wf)-1);
            Waveform.XUnit = query(obj.DevObj,':waveform:xunits?');
            Waveform.YUnit = query(obj.DevObj,':waveform:yunits?');
            fprintf(obj.DevObj,':run');
            fclose(obj.DevObj);
        end
        
        function histInfo = GetHistogramInfo(obj)
            obj.DevObj = obj.Init();
%             % open the connection
%             fopen(obj.DevObj);
            % clear
            obj.Set(':CDISplay');
            % run
            obj.Set(':run');
            % make sure the number of hits should be larger than 100k
            nHits = 0;
            while(nHits<100e3)
                pause(0.1);
                txt = obj.Read(':MEASure:HISTogram:HITS?');
                nHits = str2double(txt);
            end
            histInfo.nHits = nHits;
            % stop
            obj.Set(':stop');
            % read the histogram information
            histInfo.mean = obj.ReadFloat(':MEASure:HISTogram:MEAN?');
            histInfo.std = obj.ReadFloat(':MEASure:HISTogram:STDDev?');
            histInfo.median = obj.ReadFloat(':MEASure:HISTogram:MEDian?');
            histInfo.m1 = obj.ReadFloat(':MEASure:HISTogram:M1S?');
            histInfo.m2 = obj.ReadFloat(':MEASure:HISTogram:M2S?');
            histInfo.m3 = obj.ReadFloat(':MEASure:HISTogram:M3S?');
            % calculate the cspr
            histInfo.cspr = 10*log10((histInfo.mean)/histInfo.std);
            % run
            obj.Set(':run');
%             % close the connection
%             fclose(obj.DevObj);
            % 
        end
    end
end