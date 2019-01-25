classdef AgilentPSA < Device
    methods
        function obj = AgilentPSA(GPIB_Addr)
            if nargin <1
                obj.GPIB_Addr = 27;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Agilent E4448A PSA';
            obj.VISA_Vendor = 'Agilent';
            obj.DevObj = obj.Init();
            % set the buffer size
            obj.DevObj.InputBufferSize = 1e7;
            obj.DevObj.OutputBufferSize = 1e7;
            flushoutput(obj.DevObj);
            flushinput(obj.DevObj);
        end
        
        function [wf] = Read_Waveform(obj,channel)
            if nargin < 2
                channel = 1;
            end
            obj.DevObj = obj.Init();
            obj.DevObj.EOSMode = 'write';
            % read the waveform
            % open the connection
            fopen(obj.DevObj);
            % read the number of points
            nPts = str2num(query(obj.DevObj,'SWE:POIN?'));
            % set the buffer to be 40
            n_buf = 40;
            i_max = floor(nPts/n_buf);

%             for i=0:i_max
%                 n_from=n_buf*i+1;
%                 n_to=n_buf*(i+1);
%                 command_txt=sprintf(':TRACe? TRACE%d',channel);
%                 fprintf(obj.DevObj,command_txt);
%                 pause(0.001);
%                 get_txt=fscanf(obj.DevObj,'%s');
%                 xxx=textscan(get_txt,'%f','delimiter',',');
%                 wf(n_from:n_to)=xxx{1};
%             end
            % set the data source to Channel
            fprintf(obj.DevObj,sprintf(':TRACe? TRACE%d',channel));
            waveform_txt = fscanf(obj.DevObj,'%s');
            wf_temp = textscan(waveform_txt,'%f','delimiter',',').';
            wf = wf_temp{1};
            fclose(obj.DevObj);
        end
    end
end