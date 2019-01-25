function [required_coeff] = SetCSPRwoRestart(target_cspr,filename,cf_order,b1,b2)
% function SetCSPR(cspr,filename)
% filename: the cspr measuring result file, containing coeff,cspr
% target_cspr: target cspr value
% cf_order: order of curve fitting
% Created on Sep. 19, 2017 Copyright Tianwai@KAIST
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
required_coeff = min(required_coeff,0.95);
SetQuadBias(required_coeff,b1,b2);
end