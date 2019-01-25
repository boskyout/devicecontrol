classdef HP8153A < Device

methods
	function obj = HP8153A(GPIB_Addr)
            if nargin <1
                obj.GPIB_Addr = 14;
            else
                obj.GPIB_Addr = GPIB_Addr;
            end
            obj.DeviceName = 'HP Power Meter';
            obj.VISA_Vendor = 'NI';
            obj.DevObj = obj.Init();
    end
	function pwr = Read_Power(obj, mod_num, n_avg)
		if isempty(n_avg)
			n_avg = 1;
		end
		% open the connection
		obj.DevObj = obj.Init();
		fopen(obj.DevObj);
		    for idx = 1:n_avg
		        command_txt=sprintf('read%d:pow?',mod_num);
		        fprintf(obj.DevObj,command_txt);
		        Current_power_txt=fscanf(obj.DevObj,'%s');
		        Current_Power(idx)=str2double(Current_power_txt);
            end
            pwr = mean(Current_Power);
		fclose(obj.DevObj);
	end
end % end of methods

end % end of classdef