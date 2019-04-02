
clc;clear;close all;

data = load("data\DataSet\NominalUERE\dataset_1_20180328T122038.mat");
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

for j = 1:row 
    figure(2)
    plot(satellite(j,:))
    hold on
end




