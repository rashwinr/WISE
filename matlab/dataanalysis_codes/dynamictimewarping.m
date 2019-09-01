clc
clear all
close all
t = 0:0.001:2*pi;
A = sin(t);
B = 3*sin(t+0.1);
signal_RMSE(A,B)
figure(1)
hold on
plot(t,A)
plot(t,B)
[a,X,Y] = dtw(A,B,2);
signal_RMSE(A(X),B(Y))
a
%%
figure(2)
subplot(3,1,1)
hold on
plot(A(X))
plot(A)
% plot(t,B)
subplot(3,1,2)
hold on
plot(B)
% plot(t,A)
plot(B(Y))
subplot(3,1,3)
hold on
plot(A(X))
% plot(t,A)
plot(B(Y))

