clear; close all

c = 2.99792458e8;
osa = Advantest_OSA();

osa.Single();

[lambda,y] = osa.Get_Spectrum();
f = c./lambda;

[p_carrier,ind] = max(y);
f_carrier = f(ind);
lambda_carrier = lambda(ind);

f_max = f_carrier + 460/512*16e9;
lambda_max = c/f_max;

signal_index = find(lambda >= lambda_max & lambda <= lambda_carrier);
third = floor(length(signal_index)/3);

average_db_sig = mean(y(signal_index(third+1:2*third)));

p_sig = 10.^(average_db_sig/10)*length(signal_index);
cspr = p_carrier - 10*log10(p_sig);