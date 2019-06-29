[muHat,sigmaHat] = normfit(err);
y = gaussmf(err,[sigmaHat muHat]);
figure(2)
scatter(err,y)
