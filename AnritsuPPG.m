classdef AnritsuPPG < Device
    methods
        function obj = AnritsuPPG(GPIB_Addr)
            if nargin <1
                obj.GPIB_Addr = 17;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'Anritsu PPG';
            obj.VISA_Vendor = 'NI';
            obj.DevObj = obj.Init();
        end
        
        function Set_N_Bits(obj,num)
           % this function is to set n bits to be ones
            nPage = floor(num/16);
            nRemBits = rem(num,16);
            % write the pages with all bits of ones
            for idx = 1:nPage
                obj.Set_Bit_Pattern(65535,idx);
            end
            % write the remaining bits to a new page
            if nRemBits ~= 0
                value = 0;
                for ii = 1:nRemBits
                    value = value + 2^(ii-1);
                end
                obj.Set_Bit_Pattern(value,nPage+1);
            end
        end
        
        function Set_All_Bits_Zero(obj)
           for idx = 1:64
               obj.Set_Bit_Pattern(0,idx);
           end
        end
        
        function Set_Bit_Pattern(obj,bit_pattern,page)
            % check the input
            if bit_pattern<0 || bit_pattern > 65535 || page < 1
                error('Invalid input!');
            end
            
            obj.DevObj = obj.Init();
            
            % set the buffer size
            obj.DevObj.InputBufferSize = 1e6;
            obj.DevObj.OutputBufferSize = 1e6;
            flushoutput(obj.DevObj);
            flushinput(obj.DevObj);
            
            % open the connection
            fopen(obj.DevObj);
            % change to the page
            fprintf(obj.DevObj,'PAG %d',page);
            % set the data
            fprintf(obj.DevObj,'BIT %d',bit_pattern);
            fclose(obj.DevObj);
        end
    end
end