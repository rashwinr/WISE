% quaternion to rotation matrix
clear all, close all, clc
syms thx thy thz
Rx = [1 0 0; 0 cos(thx) -sin(thx); 0 sin(thx) cos(thx)];
Ry = [cos(thy) 0 sin(thy); 0 1 0;-sin(thy) 0 cos(thy)];
Rz = [cos(thz) -sin(thz) 0; sin(thz) cos(thz) 0;0 0 1];
R = Rz*Rx*Ry

