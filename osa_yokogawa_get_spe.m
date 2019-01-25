function [xb,yb]=osa_yokogawa_get_spe(ch_index)

ch_index
% if nargin==1
%     
% ;    
% else %default parameters
%  i_ch=0;    
% end



%clear all

hold off

wavelength_center=1552.5
wavelength_span=5.0


n_data=10000;


%bufferSize=10*n_data
%vp_yoko_osa.OutputBufferSize=bufferSize;
%vp_yoko_osa.InputBufferSize=bufferSize;
%vp_yoko_osa=visa('ni','TCPIP::192.168.2.118::INSTR')
gpib_address=20;
command_txt=sprintf('GPIB0::%d::0::INSTR',gpib_address)
vp_yoko_osa=visa('ni',command_txt)
%vp_yoko_osa=visa('ni','TCPIP0::192.168.2.118::inst0::INSTR')

fopen(vp_yoko_osa)

%command_txt=sprintf(':INITiate:SMODe REPeat')
command_txt=sprintf(':INITiate:SMODe 1')
fprintf(vp_yoko_osa,command_txt);
pause(0.001);

command_txt=sprintf('CFORM1')
fprintf(vp_yoko_osa,command_txt);
pause(0.001);

%command_txt=sprintf(':sens:wav:cent 1552nm')
command_txt=sprintf(':sens:wav:cent %fnm',wavelength_center)
fprintf(vp_yoko_osa,command_txt);
pause(0.001);

%command_txt=sprintf(':sens:wav:span 5nm')
command_txt=sprintf(':sens:wav:span %fnm',wavelength_span)
fprintf(vp_yoko_osa,command_txt);
pause(0.1);


% :SYSTEM:GRID Custom
% command_txt=sprintf(':SYSTEM:GRID 10GHZ')
% fprintf(vp_yoko_osa,command_txt);
% pause(0.5);
% 
% %:SYSTem:GRID:CUSTOM:START 1550.000NM
% command_txt=sprintf(':SYSTem:GRID:CUSTOM:START WL 1550.000NM')
% fprintf(vp_yoko_osa,command_txt);
% pause(0.5);
% peak search :CALCulate:MARKer:MAXimum

% command_txt=sprintf(':CALCulate:MARKer:MAXimum')
% fprintf(vp_yoko_osa,command_txt);
% pause(0.5);


%%%%command_txt=sprintf(':CALCulate:MARKer:Y? 0')
%command_txt=sprintf(':CALC:AMAR:Y? ')

%command_txt=sprintf(':CALC:MARK:Y?ALL')

%command_txt=sprintf(':SENS:SWE:POIN?')
%command_txt=sprintf(':SENS:WAV:CENT?')

%command_txt=sprintf(':TRAC:X? TRA')

%command_txt=sprintf(':FORM:DATA?')



pause (0.5)

command_txt=sprintf(':init')
fprintf(vp_yoko_osa,command_txt);

scan_flag=1

while scan_flag==1
  command_txt=sprintf(':stat:oper:even?')
fprintf(vp_yoko_osa,command_txt);
get_txt=fscanf(vp_yoko_osa,'%s');
scan_flag=str2num(get_txt)
pause(0.001);
end

command_txt=sprintf(':SENS:SWE:POIN?')
fprintf(vp_yoko_osa,command_txt);
get_txt=fscanf(vp_yoko_osa,'%s');
n_sampling=str2num(get_txt)

n_buf=25
i_max=floor(n_sampling/n_buf)

for i=0:i_max
    %i
    n_from=n_buf*i+1;
    n_to=n_buf*(i+1);
    
    %command_txt=sprintf(':TRAC:X? TRA')
    %%%%command_txt=sprintf(':TRAC:X? TRA,1,25')
    command_txt=sprintf(':TRAC:X? TRA,%d,%d',n_from,n_to);
    
    fprintf(vp_yoko_osa,command_txt);
    %c_wavelength_txt=fscanf(gp_Advantest_opt_spe,'%s')
    %fprintf(vp_yoko_osa, '*WAI')
    
    pause(0.001);
    get_txt=fscanf(vp_yoko_osa,'%s');
    
    %xxx=textscan(get_txt,'%f,%*n')
    %xxx{1}.*10e6
    % xxx=textscan(get_txt,'%s','delimiter',',')
    % xxx{1}
    % xxx=str2double(xxx{1})
    xxx=textscan(get_txt,'%f','delimiter',',');
    
    %command_txt=sprintf(':TRAC:Y? TRA')
    
    %%%%command_txt=sprintf(':TRAC:Y? TRA,1,25')
    command_txt=sprintf(':TRAC:Y? TRA,%d,%d',n_from,n_to);
    
    
    
    fprintf(vp_yoko_osa,command_txt);
    %c_wavelength_txt=fscanf(gp_Advantest_opt_spe,'%s')
    %fprintf(vp_yoko_osa, '*WAI')
    
    pause(0.001);
    get_txt=fscanf(vp_yoko_osa,'%s');
    
    %yyy=textscan(get_txt,'%f,%*n')
    yyy=textscan(get_txt,'%f','delimiter',',');
    
    %%%%ya=yyy{1}
    %%%%xa=xxx{1}
    
    ya(n_from:n_to)=yyy{1};
    xa(n_from:n_to)=xxx{1};
    
end

%plot(xa(1:end-1,1),ya(1:end-1,1))



xb=xa(1:n_sampling);
yb=ya(1:n_sampling);

%%%%plot(xb,yb)

command_txt=sprintf('OSA_yoko_results_%d.dat',ch_index)
%%%%command_txt=sprintf('OSA_yoko_results.dat')

dlmwrite(command_txt, [xb' yb'],'-append','delimiter', '\t','precision', 6);

%dlmwrite('OSA_yoko_results.dat', [xb' yb'],'-append','delimiter', '\t','precision', 6);


%command_txt=sprintf(':sens:wav:',wavelength_span)
%fprintf(vp_yoko_osa,command_txt);
%pause(0.1);

fprintf('***************FINSIH**************\n');
ch_index


%xxx{1,1}

%command_txt=sprintf(':TRACE:DATA:SNUMBER?')

%fprintf(vp_yoko_osa,command_txt)
%c_wavelength_txt=fscanf(gp_Advantest_opt_spe,'%s')
%fprintf(vp_yoko_osa, '*WAI')

%pause(1)
%get_txt=fscanf(vp_yoko_osa,'%s')


%get_data=str2double(get_txt)



% 
% command_txt=sprintf(':HCOPY[:IMMediate]:FUNCtion:MARKer:LIST')
% fprintf(vp_yoko_osa,command_txt);
% pause(0.5);
    
fclose(vp_yoko_osa)


end
