clc;clear;close all;

data = load("data\DataSet\NominalUERE\dataset_1_20180328T122038.mat");
satellite = data.RHO.GPS;  % choosing the costellation rho 
earth_fixed_pos = data.SAT_POS_ECEF.GPS;  % reference earth c earth f
col = size(satellite,2);  % time dimension 3600
row = size(satellite,1);  % number of satellite 
time_instant = zeros(1,col);  % time init

%WLMS weighted

rng('default')  % random number generator
K =10;  % interation param we can choose
array=zeros(col,4);  % array init for estimations

%diff sulla riga per ogni istante 

%nanstd per le std sigma_uere

for i = 1:col %epoc
    index = find(not(isnan(satellite(:,i))));
    x_hat = rand(1,4);
    x_hat(4) = 0;
    rho_hat = zeros(1,length(index));
    rho = satellite(index,i);
    H = zeros(length(index),4);
    H(:,4) = 1;
    R = zeros(length(index),length(index));
    for k = 1:K
        for j = 1:length(index) % visible satellite
            xyz = earth_fixed_pos(index(j)).pos(i,:); %rho
            rho_hat(j)=sqrt((xyz(1)-x_hat(1))^2 + (xyz(2)-x_hat(2))^2+(xyz(3)-x_hat(3))^2);
            H(j,1) = (xyz(1)-x_hat(1))/ rho_hat(j);
            H(j,2) = (xyz(2)-x_hat(2))/ rho_hat(j);
            H(j,3) = (xyz(3)-x_hat(3))/ rho_hat(j);
            %R(j,j) = std^2
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat; % posizioni xyz finali
end