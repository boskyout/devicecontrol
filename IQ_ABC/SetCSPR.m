function [b1,b2,required_coeff] = SetCSPR(target_cspr,filename,cf_order)
% function SetCSPR(cspr,filename)
% filename: the cspr measuring result file, containing coeff,cspr
% target_cspr: target cspr value
% cf_order: order of curve fitting
% Created on July 0.2, 2017 Copyright Tianwai@KAIST
if nargin < 3
    filename = 'CSPR_Measurement_20170702_1.mat';
    cf_order = 1;
end
% load result file
load(filename);
% perform curve fitting
p = polyfit(cspr,coeff,cf_order);
% calculate the target coeff
required_coeff = polyval(p,target_cspr);
% set the ABC
SetMode(1);
pause(0.5)
while ReadStatus(0) ~= 2
    pause(0.5);
end
[b1,b2] = SetQuadBias(required_coeff);
sprintf('CSPR has been set to be %d dB.\n',target_cspr);
end