clear all;clc;close all;
format long g
%% Ex 1
M = [6376985 1/308.6; 6377276 1/300.8;
    6377397 1/299.1528128; 6378338 1/288.5;
    6378249 1/293.5; 6378140 1/298.3;
    6378388 1/297.0; 6378245 1/298.3;
    6378137 1/298.257223563];
a = M(:,1); %semiasse maggiore
alfa = M(:,2); %flattening compreso tra 0 e 1
%qundo alfa è zero abbiamo un cerchio, quando è 1 ->c=0 e abbiamo una linea
c = a.*(1-alfa); %semiasse minore
e2 = (a.^2-c.^2)./a.^2; %eccentricità
ep2 = e2./(1-e2);%eccentricità primo


%% Ex3
XYZ = [ 4499525.4271 585034.1293 4467910.3596;
    4495694.2695 592457.8605 4470744.7781;
    4503484.7172 578160.7507 4465024.3002;
    4498329.3715 562840.7651 4472537.6125];

treshold = 10^(-8);

%hayford
h_3_ = [];
phi_3_ = [];
for i = 1:4
    h_old=0;h_new=0;phi_old=0;phi_new=0;
    lamda(i)  = atan(XYZ(i,2)/XYZ(i,1));
    r = sqrt(XYZ(i,1)^2+XYZ(i,2)^2);
    phi_old = atan(XYZ(i,3)/r);
    W = sqrt(1-e2(7)*sin(phi_old)^2);
    N = a(7)/W;
    h_old = XYZ(i,1)/(cos(phi_old)*cos(lamda(i)))-N;
    err_h = 1;
    err_phi = 1;
    count = 0;
    while(err_h>treshold || err_phi>treshold)
        h_3_(i,count+1) = h_old;
        phi_3_(i,count+1) = phi_old;
        phi_new = atan(XYZ(i,3)/(r*(1-(e2(7)*N)/(N+h_old))));
        W = sqrt(1-e2(7)*sin(phi_new)^2);
        N = a(7)/W;
        h_new = XYZ(i,1)/(cos(phi_new)*cos(lamda(i)))-N;
        err_h = abs(h_old-h_new);
        err_phi = abs(phi_old-phi_new);
        h_old = h_new;
        phi_old = phi_new;
        count = count+1;
    end
    %N_(i)=N;
    %W_(i)=W;
end
%wgs84 ->9
h_3__w = [];
phi_3__w = [];
for i = 1:4
    h_old=0;h_new=0;phi_old=0;phi_new=0;
    lamda(i)  = atan(XYZ(i,2)/XYZ(i,1));
    r = sqrt(XYZ(i,1)^2+XYZ(i,2)^2);
    phi_old = atan(XYZ(i,3)/r);
    W = sqrt(1-e2(9)*sin(phi_old)^2);
    N = a(9)/W;
    h_old = XYZ(i,1)/(cos(phi_old)*cos(lamda(i)))-N;
    err_h = 1;
    err_phi = 1;
    count = 0;
    while(err_h>treshold || err_phi>treshold)
        h_3__w(i,count+1) = h_old;
        phi_3__w(i,count+1) = phi_old;
        phi_new = atan(XYZ(i,3)/(r*(1-(e2(9)*N)/(N+h_old))));
        W = sqrt(1-e2(9)*sin(phi_new)^2);
        N = a(9)/W;
        h_new = XYZ(i,1)/(cos(phi_new)*cos(lamda(i)))-N;
        err_h = abs(h_old-h_new);
        err_phi = abs(phi_old-phi_new);
        h_old = h_new;
        phi_old = phi_new;
        count = count+1;
    end
end