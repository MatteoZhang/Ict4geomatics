clc;clear all;close all;
Xsat = 15487292.829;
Ysat = 6543538.932;
Zsat = 20727274.429;
Latitude = 45+ 3/60 + 48.114/3600;
Longitude = 7+ 39/60+ 40.605/3600;
phi = Latitude/180*pi; % rad
lamda = Longitude/180*pi;

a = 6378137;
f = 1/298.257223;
e = sqrt(2*f-f^2);
W = sqrt(1-e^2*(sin(phi))^2);

X = (a*cos(phi)*cos(lamda))/W; %Xrec Xi
Y = (a*cos(phi)*sin(lamda))/W;
Z = (a*(1-e^2)*sin(phi))/W;

Delta = [   Xsat-X;
            Ysat-Y;
            Zsat-Z];
        
R = [  -sin(lamda),            cos(lamda),             0; 
       -sin(phi)*cos(lamda),   -sin(phi)*sin(lamda),   cos(phi);
       cos(phi)*cos(lamda),    cos(phi)*sin(lamda),    sin(phi)];

Local = R*Delta; %local(e n u)

rad_azimuth = atan(Local(3)/sqrt(Local(2)^2+Local(1)^2));
rad_elevation = atan(Local(1)/Local(2));

grad_azimuth = rad_azimuth/pi*180;
grad_elevation = rad_elevation/pi*180;

%ex3

dati = load("pos_sat.dat");
rho = zeros(length(dati),1);
D=zeros(length(dati),4);
for i = 1:11
    rho(i)=sqrt((dati(i,2)-X)^2+(dati(i,3)-Y)^2+(dati(i,4)-Z)^2);
    D(i,1)=(dati(i,2)-X)/rho(i);
    D(i,2)=(dati(i,3)-Y)/rho(i);
    D(i,3)=(dati(i,4)-Z)/rho(i);
    D(i,4)=-1;
end

Qxx = inv(D'*D);
Quu = R*Qxx(1:3,1:3)*R';
Quu(4,4) = Qxx(4,4);

HDOP=sqrt(Quu(1,1)+Quu(2,2));
PDOP=sqrt(Quu(1,1)+Quu(2,2)+Quu(3,3));
GDOP=sqrt(Quu(1,1)+Quu(2,2)+Quu(3,3)+Quu(4,4));
%az->75 el->60