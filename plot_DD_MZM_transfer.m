clear;close all;

data = csvread('DD-MZM_20170530-final.csv');

voltage = data(:,1);
op_dbm = data(:,2);
op_linear = 10.^(op_dbm./10);

plot(voltage,op_linear);
% plot(voltage,op_dbm);