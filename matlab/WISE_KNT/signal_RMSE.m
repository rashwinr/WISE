function RMSE = signal_RMSE(knt,imu)
err = knt-imu;
sigma = mean(err);
RMSE = 0;
for i=1:length(knt)
RMSE = RMSE + (err(i)-sigma)^2;
end
% RMSE = RMSE/(length(knt)-1);
RMSE = RMSE/(length(knt)-1);
RMSE = sqrt(RMSE);
end
