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
for i = 1 : row
    r = satellite(i,:);
    r = r(~(isnan(r)));
    diffR = diff(r, 2);
    sigma_uere(i)=std(diffR); %#ok<SAGROW>
end
R = diag(sigma_uere).^2;

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
            R(j,j) = std^2
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat; % posizioni xyz finali
end

std_xyz(1,1) = std(array(:,1));
std_xyz(1,2) = std(array(:,2));
std_xyz(1,3) = std(array(:,3))


