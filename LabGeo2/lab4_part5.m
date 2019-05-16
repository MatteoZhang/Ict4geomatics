clear all;clc;
%% Ex5
%if we don't have the helmert params we can estimate them 
%we must know 3 common points in the 2 reference systems
data = load("points_helmert.txt"); %col 1:3 etrf89 ,   4:6 igs05
Xa = data(:,1);
Ya = data(:,2);
Za = data(:,3);
Xb = data(:,4);
Yb = data(:,5);
Zb = data(:,6);

L0x = Xb-Xa;
L0y = Yb-Ya;
L0z = Zb-Za;
A=zeros(36,7);
L0 = zeros(36,1);
j=1;
for i = 1:3:36
    
    A(i,:) = [1 0 0 Xa(j) 0 -Za(j) Ya(j)];
    A(i+1,:) = [0 1 0 Ya(j) -Za(j) 0 -Xa(j)];
    A(i+2,:) = [0 0 1 Za(j) Ya(j) Xa(j) 0];
    L0(i,:) = L0x(j);
    L0(i+1,:) = L0y(j);
    L0(i+2,:) = L0z(j);
    j=j+1;
end

X=inv(A'*A)*(A'*L0)
residual = A*X-L0