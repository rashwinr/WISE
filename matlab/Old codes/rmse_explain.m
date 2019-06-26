X = 0:0.01:pi;
Y = sin(X);
Z = sin(X+0.1);
immse1 = sqrt(immse(Y,Z));
immse2 = sqrt(immse(Z,Y));
rmse1 = signal_RMSE(Y,Z);
rmse2 = signal_RMSE(Z,Y);