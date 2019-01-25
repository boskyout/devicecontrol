classdef Keysight8163Btcp < Device
    properties
       IPaddr; 
    end
   methods
       function obj = Keysight8163Btcp(IPaddr)
           obj.DeviceName = 'Keysight 8163B Lightwave Multimeter';
           obj.VISA_Vendor = 'agilent';
           obj.IPaddr = IPaddr;
       end
       
       function Pow = Read_Power(obj,slot,channel)
          % channel is the id of channel in the module with two monitoring
          % channels such as 81635A
          if nargin<3
              channel = 1;
          end
          obj.DevObj = obj.Init();
          fopen(obj.DevObj);
          if channel==1
              Pow = str2double(query(obj.DevObj,...
                  sprintf('read%d:chan%d:pow?',slot,channel)));
          elseif channel==2
              % see "slave channel" in the manual
              Pow = str2double(query(obj.DevObj,...
                  sprintf('fetc%d:chan%d:pow?',slot,channel)));
          end
       end
       
       function dev = Init(obj)
           % Create TCPIP object via Visa Driver
            RsrcName = sprintf('TCPIP0::%s::5025::SOCKET',obj.IPaddr);
            dev = instrfind('Type', 'visa-generic', 'RsrcName', RsrcName, 'Tag', '');
            if isempty(dev)
                dev = visa(obj.VISA_Vendor, RsrcName);
            else
                fclose(dev);
                dev = dev(1);
            end
       end
   end
end