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

lamda = atan(XYZ(:,2)./XYZ(:,3));
r = sqrt(XYZ(:,1).^2+XYZ(:,2).^2);
for i = 1:4
    phi(i) = atan(XYZ(i,3)/r(i));
    W(i) = sqrt(1-e2(7)*sin(phi(i))^2);
    N(i) = a(7)/W(i); 
    h(i) = XYZ(i,1)/(cos(phi(i))*cos(lamda(i)))-N(i) ;
end

h_first = h;
%commenta h sfera
%phi in rad also lamda
%h in metre

i=abs(h);
j=0;
while i(1)>10e-8
    h_old=h;
    phi=atan(XYZ(:,3)./r.*(1-(e2(7)*N)/(N+h_old)));
    W=sqrt(1-e2(7)*sin(phi).^2);
    N = a(7)./W;
    h=XYZ(:,1)./(cos(phi).*cos(lamda))-N;
    i=abs(h-h_old);
    j=j+1;
end

