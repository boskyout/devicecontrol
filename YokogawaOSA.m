classdef YokogawaOSA < Device
    
    properties
        ipaddr;
    end
    
    methods
        function obj = YokogawaOSA(ipaddr)
            if nargin < 1
                ipaddr = '192.168.0.63';
            end
            obj.ipaddr = ipaddr;
        end
        
        function g = Init(obj)
            RsrcName = strcat('TCPIP-',obj.ipaddr);
            g = instrfind('Type','tcpip','Name',RsrcName,'Tag','');
            if isempty(g)
                g = tcpip(obj.ipaddr,10001);
            else
                fclose(g);
                g = g(1);
            end
            % set the buffer size
            g.InputBufferSize = 8e6;
            g.OutputBufferSize = 8e6;
        end
        
        function SetCenterWavelengthSpan(obj,center,span)
            g = obj.Init();
            % open the tcpip connection
            fopen(g);
            % authentication
            fprintf(g,'OPEN "anonymous" ""');
            % set the center wavelength and span
            fprintf(g,sprintf(':sens:wav:cent %fnm',center));
            pause(0.01);
            fprintf(g,sprintf(':sens:wav:span %fnm',span));
            pause(0.01);
            fclose(g);
        end
        
        function [wavelength,waveform] = GetOSATrace(obj, traceid)
            if nargin < 2
                traceid = 'A';
            end
            g = obj.Init();
            % open the tcpip connection
            fopen(g);
            % authentication
            fprintf(g,'OPEN "anonymous" ""');
            %% OSA Init
            fprintf(g,':INITiate:SMODe 1'); % single
            pause(0.01);
            fprintf(g,'CFORM1');
            pause(0.01);
            %% Get Data
            flushoutput(g);
            flushinput(g);
            % get the number of samples from OSA configuration
            fprintf(g,':SENS:SWE:POIN?');
            txt = fscanf(g,'%s');
            n_samp = str2double(txt);
            % get the wavelength data
            fprintf(g,sprintf(':TRAC:X? TR%s,%d,%d',traceid,1,n_samp));
            pause(0.01);
            get_txt = fscanf(g,'%s');
            x = textscan(get_txt,'%f','delimiter',',');
            wavelength = x{1};
            % get the waveform (power) data, n_avg iterations are averaged
            fprintf(g,sprintf(':TRAC:Y? TR%s,%d,%d',traceid,1,n_samp));
            pause(0.01);
            get_txt = fscanf(g,'%s');
            y = textscan(get_txt,'%f','delimiter',',');
            waveform = y{1};
            % close the connection
            fclose(g);
        end
        function Single(obj)
            g = obj.Init();
            % open the tcpip connection
            fopen(g);
            % authentication
            obj.Authentication();
            fprintf(g,'CFORM1');
            % single
            fprintf(g,':init:smode 1'); % single
            fprintf(g,'*cls');
            fprintf(g,':init');
            % close
            fclose(g);
        end
        
        function Repeat(obj)
            g = obj.Init();
            % open the tcpip connection
            fopen(g);
            % authentication
            obj.Authentication();
            % repeat
            fprintf(g,':INITiate:SMODe REPEAT'); % repeat
            fprintf(g,'*cls');
            fprintf(g,':init');
            % close
            fclose(g);
        end
        
        function Authentication(obj)
            g = obj.Init();
            fopen(g);
            % this function must be called after the connection is open
            fprintf(g,'OPEN "anonymous" ""');
            get_txt = fscanf(g,'%s');
            fprintf(g,' ');
            get_txt = fscanf(g,'%s');
            if ~strcmp(get_txt,'ready')
                error('auth failed!');
            end
        end
    end
end