clear;close all;

fs = 92e9;
marker1 = [];
marker2 = [];
segmNum = 1; % default: 1
channelMapping = [1 0;0 0;0 0;0 1]; % channel mapping: 1|2 : I|Q
run = 1;

arbConfig.skew = 0e-12;
arbConfig.M8196Acorrection = 0;
arbConfig.amplitude = [0.12548 0 0 0.1];
arbConfig.offset = [0 0 0 -0.0083];

load('seq_to_awg.mat');

result = iqdownload_M8196A_tw(arbConfig, fs, seq, marker1, marker2, segmNum, channelMapping, run);