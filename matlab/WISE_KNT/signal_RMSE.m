function RMSE = signal_RMSE(knt,imu)
[R1] = find(isnan(knt));
knt(R1) = [];
imu(R1) = [];
[R2] = find(isnan(imu));
knt(R2) = [];
imu(R2) = [];
err = knt-imu;
% sigma = mean(err)
RMSE = 0;
for i=1:length(knt)
RMSE = RMSE + (err(i))^2;
end
% RMSE = RMSE/(length(knt)-1);
RMSE = RMSE/(length(knt));
RMSE = sqrt(RMSE);
end
