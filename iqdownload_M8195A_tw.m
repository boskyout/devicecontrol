function result = iqdownload_M8195A_tw(data,fs,modMethod,chConfig,run)
% copyright: Tianwai@PSRL,KAIST
% create: 09/07/2018, Rev.0
% fs: sampling rate of AWG
% chConig: a struct with a sample structure like
%     chConfig.amplitude = 1*[0.9 0 0 0.9];
%     chConfig.offset = [0 0 0 0];
%     chConfig.skew = 0;
% run: a boolean parameter, 1: run after load the code | 0: stop after load

switch modMethod
    case 'IQ'
        channelMapping = [1 0;0 0;0 0;0 1]; % channel mapping: 1|2 : I|Q;
    case 'CH1'
        channelMapping = [1 0;0 0;0 0;0 0];
    case 'CH4'
        channelMapping = [0 0;0 0;0 0;1 0];
    otherwise
        error('invalid modulation method!');
end
        
arbConfig = getArbConfigM8195(chConfig);
result = iqdownload(data, fs,...
    'arbConfig',arbConfig,...
    'channelMapping',channelMapping,...
    'run',run);
    
