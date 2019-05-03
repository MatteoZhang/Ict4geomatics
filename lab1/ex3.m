clc;clear;close all;

data = load("data\DataSet\NominalUERE\dataset_1_20180328T122038.mat");
satellite = data.RHO.GPS;  % choosing the costellation
earth_fixed_pos = data.SAT_POS_ECEF.GPS;  % reference
col = size(satellite,2);  % time dimension 3600
row = size(satellite,1);  % number of satellite 
time_instant = zeros(1,col);  % time init

%LMS

rng('default')  % random number generator
K =10;  % interation param we can choose
array=zeros(col,4);  % array init for estimations ecef earth centre earth fixed

for i = 1:col %epoc
    index = find(not(isnan(satellite(:,i))));
    x_hat = rand(1,4);
    x_hat(4) = 0;
    rho_hat = zeros(1,length(index));
    rho = satellite(index,i);
    H = zeros(length(index),4);
    H(:,4) = 1;
    
    for k = 1:K
        for j = 1:length(index) % visible satellite
            xyz = earth_fixed_pos(index(j)).pos(i,:);
            rho_hat(j)=sqrt((xyz(1)-x_hat(1))^2 + (xyz(2)-x_hat(2))^2+(xyz(3)-x_hat(3))^2);
            H(j,1) = (xyz(1)-x_hat(1))/ rho_hat(j);
            H(j,2) = (xyz(2)-x_hat(2))/ rho_hat(j);
            H(j,3) = (xyz(3)-x_hat(3))/ rho_hat(j);      
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat;
end

std_xyz_GPS=zeros(1,4);  % std gps
std_xyz_GLO=zeros(1,4);  % std glonass
std_xyz_BEI=zeros(1,4);  % std beidou
std_xyz_GAL=zeros(1,4);  % std galileo

std_xyz_GPS(1,1) = std(array(:,1));
std_xyz_GPS(1,2) = std(array(:,2));
std_xyz_GPS(1,3) = std(array(:,3))

satellite = data.RHO.GLO;  % choosing the costellation
earth_fixed_pos = data.SAT_POS_ECEF.GLO;  % reference
col = size(satellite,2);  % time dimension 3600
row = size(satellite,1);  % number of satellite 
time_instant = zeros(1,col);  % time init

%LMS

array=zeros(col,4);  % array init for estimations

for i = 1:col %epoc
    index = find(not(isnan(satellite(:,i))));
    x_hat = rand(1,4);
    x_hat(4) = 0;
    rho_hat = zeros(1,length(index));
    rho = satellite(index,i);
    H = zeros(length(index),4);
    H(:,4) = 1;
    
    for k = 1:K
        for j = 1:length(index) % visible satellite
            xyz = earth_fixed_pos(index(j)).pos(i,:);
            rho_hat(j)=sqrt((xyz(1)-x_hat(1))^2 + (xyz(2)-x_hat(2))^2+(xyz(3)-x_hat(3))^2);
            H(j,1) = (xyz(1)-x_hat(1))/ rho_hat(j);
            H(j,2) = (xyz(2)-x_hat(2))/ rho_hat(j);
            H(j,3) = (xyz(3)-x_hat(3))/ rho_hat(j);      
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat;
end

std_xyz_GLO(1,1) = std(array(:,1));
std_xyz_GLO(1,2) = std(array(:,2));
std_xyz_GLO(1,3) = std(array(:,3))

satellite = data.RHO.BEI;  % choosing the costellation
earth_fixed_pos = data.SAT_POS_ECEF.BEI;  % reference
col = size(satellite,2);  % time dimension 3600
row = size(satellite,1);  % number of satellite 
time_instant = zeros(1,col);  % time init

%LMS

array=zeros(col,4);  % array init for estimations

for i = 1:col %epoc
    index = find(not(isnan(satellite(:,i))));
    x_hat = rand(1,4);
    x_hat(4) = 0;
    rho_hat = zeros(1,length(index));
    rho = satellite(index,i);
    H = zeros(length(index),4);
    H(:,4) = 1;
    
    for k = 1:K
        for j = 1:length(index) % visible satellite
            xyz = earth_fixed_pos(index(j)).pos(i,:);
            rho_hat(j)=sqrt((xyz(1)-x_hat(1))^2 + (xyz(2)-x_hat(2))^2+(xyz(3)-x_hat(3))^2);
            H(j,1) = (xyz(1)-x_hat(1))/ rho_hat(j);
            H(j,2) = (xyz(2)-x_hat(2))/ rho_hat(j);
            H(j,3) = (xyz(3)-x_hat(3))/ rho_hat(j);      
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat;
end

std_xyz_BEI(1,1) = std(array(:,1));
std_xyz_BEI(1,2) = std(array(:,2));
std_xyz_BEI(1,3) = std(array(:,3))

satellite = data.RHO.GAL;  % choosing the costellation
earth_fixed_pos = data.SAT_POS_ECEF.GAL;  % reference
col = size(satellite,2);  % time dimension 3600
row = size(satellite,1);  % number of satellite 
time_instant = zeros(1,col);  % time init

%LMS

array=zeros(col,4);  % array init for estimations

for i = 1:col %epoc
    index = find(not(isnan(satellite(:,i))));
    x_hat = rand(1,4);
    x_hat(4) = 0;
    rho_hat = zeros(1,length(index));
    rho = satellite(index,i);
    H = zeros(length(index),4);
    H(:,4) = 1;
    
    for k = 1:K
        for j = 1:length(index) % visible satellite
            xyz = earth_fixed_pos(index(j)).pos(i,:);
            rho_hat(j)=sqrt((xyz(1)-x_hat(1))^2 + (xyz(2)-x_hat(2))^2+(xyz(3)-x_hat(3))^2);
            H(j,1) = (xyz(1)-x_hat(1))/ rho_hat(j);
            H(j,2) = (xyz(2)-x_hat(2))/ rho_hat(j);
            H(j,3) = (xyz(3)-x_hat(3))/ rho_hat(j);      
        end
        d_rho = rho_hat' - rho;
        d_x = (inv(H.'*H)*H.')*d_rho;
        x_hat = x_hat + d_x';
    end
    array(i,:) = x_hat;
end

std_xyz_GAL(1,1) = std(array(:,1));
std_xyz_GAL(1,2) = std(array(:,2));
std_xyz_GAL(1,3) = std(array(:,3))

% fare grafico per 