classdef Advantest_OSA < Device
    
    properties
        
    end
    
    methods
        function obj = Advantest_OSA(GPIBControllerAddr,GPIB_Addr)
            if nargin <1
                obj.GPIBControllerAddr = 2;
                obj.GPIB_Addr = 18;
            elseif nargin<2
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = 18;
            else
                obj.GPIBControllerAddr = GPIBControllerAddr;
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Advantest Q8384 OSA';
            obj.VISA_Vendor = 'Agilent';
            obj.DevObj = obj.Init();
        end
        
        function SetResolution(obj,res_str)
            % res_str: string to set the resolution
            % e.g.: 0.1nm; 0.01nm;
            % TODO: test on OSA
           cmd = sprintf('RES%s',res_str);
           obj.Set(cmd);
        end
        
        function [lambda,y] = Get_Spectrum(obj)
            nHeader = 4; % Header length can be found in the datasheet
            obj.DevObj = obj.Init();
            % set Buffer size
            obj.DevObj.InputBufferSize = 1e6;
            obj.DevObj.OutputBufferSize = 1e6;
            % open the connection
            fopen(obj.DevObj);
            flushoutput(obj.DevObj);
            flushinput(obj.DevObj);
            % read the frequency-axis values
            fprintf(obj.DevObj,'OSD 1');
            pause(0.01);
            get_txt=fscanf(obj.DevObj,'%s');
            lambda = textscan(get_txt(nHeader+1:end),'%f','Delimiter',',');
            lambda = lambda{:};
            % read the magnitude-axis values
            fprintf(obj.DevObj,'OSD 0');
            pause(0.01);
            get_txt=fscanf(obj.DevObj,'%s');
            y = textscan(get_txt(nHeader+1:end),'%f','Delimiter',',');
            y = y{:};
            % close the connection
            fclose(obj.DevObj);
        end
        function Single(obj)
            obj.DevObj = obj.Init();
            % open the connection
            fopen(obj.DevObj);
            % single run
            fprintf(obj.DevObj,'MEA1');
            % wait until the single run finishes
            while(1)
                pause(0.1);
                status = query(obj.DevObj,'MEA?');
                if str2double(status(4)) == 0
                    break;
                end
            end
            % close the connection
            fclose(obj.DevObj);
        end
        function Save_Spectrum(obj,filename)
            [lambda,y] = obj.Get_Spectrum();
            save(filename,'lambda','y');
            fprintf('OSA spectrum has been saved in %s\n',filename);
        end
        function [cspr,debugInfo] = Estimate_CSPR(obj,BW)
            % single run and get spectrum
            obj.Single();
            [lambda,y] = obj.Get_Spectrum();
            % find the carrier freq & power
            c = 2.99792458e8;
            nProtect = 9; % the number is cali based on data 2017/07/23
            f = c./lambda;
            [~,ind] = max(y);
            p_carrier = 10*log10(sum(10.^(y(ind-nProtect:ind+nProtect)/10)));
            f_carrier = f(ind);
            lambda_carrier = lambda(ind-nProtect:ind+nProtect);
            % find the signal index and calculate the average power
            f_max = f_carrier + BW;
            lambda_max = c/f_max;
            signal_index = find(lambda >= lambda_max & lambda < lambda_carrier(1));
            third = floor(length(signal_index)/3);
            average_db_sig = mean(y(signal_index(third+1:2*third)));
            % calculate the singal power
            p_sig = 10^(average_db_sig/10)*length(signal_index);
            cspr = p_carrier - 10*log10(p_sig);
%             %%%% calibration for 28.75 GHz
%             cspr = cspr - 0.3;
            %%%% calibration ends
            
            %             cspr = p_carrier - average_db_sig - 10*log10(BW/0.125e9);
            % save debug info
            debugInfo.lambda = lambda;
            debugInfo.spectrum = y;
            debugInfo.p_carrier = p_carrier;
            debugInfo.signal_index = signal_index;
            debugInfo.cspr_bymean = p_carrier - average_db_sig - 10*log10(BW/0.125e9);
            debugInfo.cspr_bymultiply = cspr;
        end
        function [cspr,debugInfo] = Estimate_CSPR_old(obj,BW)
            % single run and get spectrum
            obj.Single();
            [lambda,y] = obj.Get_Spectrum();
            % find the carrier freq & power
            c = 2.99792458e8;
            nProtect = 5;
            f = c./lambda;
            [p_carrier,ind] = max(y);
            f_carrier = f(ind);
            lambda_carrier = lambda(ind-nProtect:ind+nProtect);
            % find the signal index and calculate the average power
            f_max = f_carrier + BW;
            lambda_max = c/f_max;
            signal_index = find(lambda >= lambda_max & lambda < lambda_carrier(1));
            third = floor(length(signal_index)/3);
            average_db_sig = mean(y(signal_index(third+1:2*third)));
            % calculate the singal power
            p_sig = 10^(average_db_sig/10)*length(signal_index);
            cspr = p_carrier - 10*log10(p_sig);
            %             cspr = p_carrier - average_db_sig - 10*log10(BW/0.125e9);
            % save debug info
            debugInfo.lambda = lambda;
            debugInfo.spectrum = y;
            debugInfo.p_carrier = p_carrier;
            debugInfo.signal_index = signal_index;
            debugInfo.cspr_bymean = p_carrier - average_db_sig - 10*log10(BW/0.125e9);
            debugInfo.cspr_bymultiply = cspr;
        end
        function cursor = Get_Cursor_Info(obj)
            % note this function is for DeltaMode only
            % for other mode like Normal Mode, check the manual Page 4-11
            f = obj.Init();
            f.InputBufferSize = 1e3;
            f.OutputBufferSize = 1e3;
            fopen(f);
            % set the cursor to Delta Mode
            fprintf(f,'CUD1');
            % read the value back
            txt = query(f,'OCD?');
            x = textscan(txt,'%s',6,'Delimiter',',');
            x = x{1};
            for idx = 1:length(x)
                value(idx) = str2double(x{idx}(5:end));
            end
            % assign the value to the output
            cursor.lambda1 = value(1);
            cursor.level1 = value(2);
            cursor.dlambda = value(3);
            cursor.dlevel = value(4);
            cursor.L1 = value(5);
            cursor.dL = value(6);
            
            fclose(f);
        end
    end
    
end