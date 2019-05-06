clear all; close all; clc;

data=load('dataset_1_20180329T160947.mat');
gps_rho=data.RHO.GAL;%data.RHO.GPS;%data.RHO.BEI;%data.RHO.GAL;
gps_xyz=data.SAT_POS_ECEF.GAL;%data.SAT_POS_ECEF.GPS;%data.SAT_POS_ECEF.BEI;%data.SAT_POS_ECEF.GAL;
visible_sat=sum(not(isnan(gps_rho)),1);
Nit=15;
pos=[0,0,0];
vis_sat_index=[];
second_der_rho=[];
sigma_uere_sat=[];
sigma2_uere_sat=[];
sigma_x=[];
gdop=[];
[Nr,Nc]=size(gps_rho);
est_pos=zeros(3600,3);
%Stringhe per le legende
not_nan=[];
for i=[1:1:Nr]
    not_nan=[not_nan;not(isnan(gps_rho(i,:)))];
end
total_not_nan=sum(not_nan,2);
index_sat=find(total_not_nan>0);
f = cell(length(index_sat), 1);
for i=1:length(index_sat)
   f{i} = strcat('Satellite ', num2str(index_sat(i)));
end
%Plot pseudorange over time
figure(1)
hold on
grid minor
for i=[1:1:Nr]
    plot([1:1:Nc],gps_rho(i,:),'LineWidth',2)
end
xlabel('Time')
ylabel('Pseudorange \rho')
lg1=legend(f);
%Plot number of satellite over time
figure(2)
plot(visible_sat,'LineWidth',2)
grid minor
xlabel('Time')
ylabel('Number of satellites')

%Plot second derivative of rho with respect to time
figure(3)
hold on
grid minor
j=1;
for i=[1:1:Nr]
    second_der_rho=[second_der_rho; diff(gps_rho(i,:),2)];
    ind=find(not(isnan(second_der_rho(i,:))));
    sigma_uere_sat(i)=std(second_der_rho(i,ind));
    sigma2_uere_sat(i)=var(second_der_rho(i,ind));
    if isnan(sigma_uere_sat(i))==0
        subplot(ceil(length(index_sat)/2),ceil(length(index_sat)/2),j)
        stem(second_der_rho(i,:))
        title(f{j});
        xlabel('Time (s)')
        ylabel('d^{2}\rho/dt^{2}')
        j=j+1;
    end
end

R=diag(sigma2_uere_sat);

%LMS algorithm to estimate position
for i=[1:Nc]
    
    for j=[1:Nit] 
        
        k=1;
        clear H, clear rho_jn, clear rho_hat_jn
        visible_sat_index=find(not(isnan(gps_rho(:,i))));
        H=[];
        
        for sat=1:length(visible_sat_index)
            k=visible_sat_index(sat);
            rho_hat_jn(sat)=sqrt((gps_xyz(k).pos(i,1)-pos(1))^2 +(gps_xyz(k).pos(i,2)-pos(2))^2 +(gps_xyz(k).pos(i,3)-pos(3))^2);
            a_xj=(gps_xyz(k).pos(i,1)-pos(1))/rho_hat_jn(sat);
            a_yj=(gps_xyz(k).pos(i,2)-pos(2))/rho_hat_jn(sat);
            a_zj=(gps_xyz(k).pos(i,3)-pos(3))/rho_hat_jn(sat);
            H=[H;a_xj,a_yj,a_zj,1];
            rho_jn(sat)=gps_rho(k,i);
        end
        R2=R(visible_sat_index,visible_sat_index);
        W=inv(R2);
        delta_rho=rho_hat_jn-rho_jn;
        delta_x_hat=(inv(H'*W*H)*H'*W)*delta_rho';
        pos=pos+delta_x_hat(1:3)';
        
    end
    cov_dx=inv(H'*W*H)*H'*W*diag(sigma2_uere_sat(visible_sat_index))*W'*H*inv(H'*W*H);
    sigma_x(i)=sqrt(trace(cov_dx));
    gdop(i)=sqrt(trace(inv(H'*H)));
    est_pos(i,:)=pos;
    lla(i,1:3)=ecef2lla(est_pos(i,:));
    
end

writeKML_GoogleEarth('wlms_est.m',lla(:,1),lla(:,2),lla(:,3));
figure(4)
plot([1:3600],gdop)
grid minor
xlabel('Time (s)')
ylabel('GDOP')
title('GDOP vs Time')

figure(5)
plot([1:3600],sigma_x)
grid minor
xlabel('Time')
ylabel('Distance (m)')
title('Standard deviation of x (\sigma_{x})')