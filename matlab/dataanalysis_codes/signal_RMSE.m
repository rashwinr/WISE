function RMSE = signal_RMSE(knt,imu)
RMSE = 0;
if length(knt)>=2 && length(imu)>=2
[R1] = find(isnan(knt));
knt(R1) = [];
imu(R1) = [];
[R2] = find(isnan(imu));
knt(R2) = [];
imu(R2) = [];
err = knt-imu;
M = mean(err);
Std = std(err);
% h = kstest((err-M)/Std);
% sigma = mean(err)
RMSE = 0;
for i=1:length(knt)
RMSE = RMSE + (err(i))^2;
end
% RMSE = RMSE/(length(knt)-1);
RMSE = RMSE/(length(knt));
RMSE = sqrt(RMSE);
end

end
