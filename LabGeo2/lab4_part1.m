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

%% Ex2
%estimate the coordinate in x,y,z starting from lmbda,phi, h
points = [(44+45/60+1.03930/3600)*pi/180 (7+24/60+29.20335/3600)*pi/180 322.4909;
    (44+47/60+10.90505/3600)*pi/180 (7+30/60+26.53939/3600)*pi/180 305.7367];
phi = points(1,1);
lambda = points(1,2);
h = points(1,3);
W = sqrt(1-e2*sin(phi)^2);
X = (a./W+h).*cos(phi).*cos(lambda);
Y = (a./W+h).*cos(phi).*sin(lambda);
Z = (a./W.*(1-e2)+h).*sin(phi);
phi2 = points(2,1);
lambda2 = points(2,2);
h2 = points(2,3);
W2 = sqrt(1-e2*sin(phi2)^2);
X2 = (a./W2+h2).*cos(phi2).*cos(lambda2);
Y2 = (a./W2+h2).*cos(phi2).*sin(lambda2);
Z2 = (a./W2.*(1-e2)+h2).*sin(phi2);
%hyford = 7; %the variation is not neglectible using different ellipsoids
%wg84 = 9;
points_h = points;
points_h(:,3) = points_h(:,3)+2000;
phi_h = points_h(1,1);
lambda_h = points_h(1,2);
h_h = points_h(1,3);
W_h = sqrt(1-e2*sin(phi_h)^2);
X_h = (a./W_h+h_h).*cos(phi_h).*cos(lambda_h);
Y_h = (a./W_h+h_h).*cos(phi_h).*sin(lambda_h);
Z_h = (a./W_h.*(1-e2)+h_h).*sin(phi_h);
phi_h2 = points_h(2,1);
lambda_h2 = points_h(2,2);
h_h2 = points_h(2,3);
W_h2 = sqrt(1-e2*sin(phi_h2)^2);
X_h2 = (a./W_h2+h_h2).*cos(phi_h2).*cos(lambda_h2);
Y_h2 = (a./W_h2+h_h2).*cos(phi_h2).*sin(lambda_h2);
Z_h2 = (a./W_h2.*(1-e2)+h_h2).*sin(phi_h2);

Xdiff = [X_h-X X_h2-X2];
Ydiff = [Y_h-Y Y_h2-Y2];
Zdiff = [Z_h-Z Z_h2-Z2];
coord1 =[X Y Z];
coord2 = [X2 Y2 Z2];
%in xyz non siamo più in grado di capire che il punto si è spostato di 2000m
%inoltre l variazione dipende dalla posizione del punto rispetto
%all'equatore perchè xy dipendono sia da phi che lambda
%la variazione in h rimane visibile solo ai poli, altrimenti viene divisa
%nelle tre componenti xyz
%% Ex4
itrf89_1 = [4498462.09060  584896.09000 4467862.04830 ;
 4498854.70420  584947.13810 4467498.70870; 
 4498980.87400  584963.54290 4467459.90280; 
 4499919.93850  585085.64130 4467285.73360; 
 4499725.46640  585060.35580 4467622.05460;
 4499526.31330  585034.46160 4467915.84020; 
 4499733.98140  585061.46290 4467990.49000; 
 4499600.38290  585044.09230 4467989.38940 ;
 4499525.26910  585034.32590 4467910.49290];
itrf89_2 = [ 4494631.51620  592318.02450 4470696.11850;
 4495024.03500  592369.75200 4470332.78480;
 4495150.14960  592386.37180 4470294.00590;
 4496088.76760  592510.06610 4470120.07420;
 4495894.29280  592484.43750 4470456.44280;
 4495695.15310  592458.19420 4470750.26070;
 4495902.68660  592485.54370 4470824.99940;
 4495769.15980  592467.94710 4470823.85670;
 4495694.11120  592458.05690 4470744.91130
];
%coord are similar but identical: 20/40cm of difference
diff89_punto1 = coord1-itrf89_1;%in meters
diff89_punto2 = coord2-itrf89_2;
%if we change epoch we apply time parameter because plates are moving in
%time
itrf2000_1 = [4498462.05310  584896.05180 4467862.07800;
 4498854.66670  584947.09990 4467498.73850;
 4498980.83650  584963.50470 4467459.93250;
 4499919.90100  585085.60310 4467285.76330;
 4499725.42890  585060.31760 4467622.08440;
 4499526.27580  585034.42340 4467915.86990;
 4499733.94390  585061.42470 4467990.51970;
 4499600.34540  585044.05400 4467989.41910;
 4499525.23160  585034.28770 4467910.52260;
];
itrf2000_2 = [4494631.47870  592317.98620 4470696.14820;
 4495023.99740  592369.71370 4470332.81450;
 4495150.11210  592386.33350 4470294.03560;
 4496088.73010  592510.02780 4470120.10390;
 4495894.25530  592484.39930 4470456.47250;
 4495695.11550  592458.15600 4470750.29040;
 4495902.64910  592485.50540 4470825.02920;
 4495769.12230  592467.90880 4470823.88650;
 4495694.07370  592458.01860 4470744.94100 
];
diff2000_punto1 = coord1-itrf2000_1;%in meters
diff2000_punto2 = coord2-itrf2000_2;
