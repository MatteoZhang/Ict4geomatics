% satellite presence

clc;clear;close all;

% Nominal UERE
data = load("dataset_1_20180328T122038.mat");
% data = load("dataset_2_20180328T122158.mat");
% data = load("dataset_3_20180328T121914.mat");
% data = load("dataset_4_20180328T121804.mat");
% data = load("dataset_5_20180328T121529.mat");
% data = load("dataset_6_20180328T121701.mat");

% Realistical UERE
% data = load("dataset_1_20180329T160947.mat");
% data = load("dataset_2_20180329T160900.mat");
% data = load("dataset_3_20180329T161023.mat");
% data = load("dataset_4_20180329T161103.mat");
% data = load("dataset_5_20180329T161418.mat");
% data = load("dataset_6_20180329T161139.mat");

n = size(data.RHO.GPS,2);
satellite = data.RHO.GPS;
time_instant = zeros(1,n);
row = size(satellite,1);

for i = 1:n
    for j = 1:row
        if isnan(satellite(j,i)) == 0 
            time_instant(i)=time_instant(i)+1;
        end
    end
end

figure(1)
plot(time_instant)
title("satellite presence")
ylabel("number of satellite")
xlabel("time (s)")
xlim([0 n])
grid on

for j = 1:row 
    figure(2)
    plot(satellite(j,:))
    hold on
end
title("rho measuraments")
ylabel("rho")
xlabel("time (s)")
xlim([0 n])
grid on




