% Md = [R S G]'
clc
clear all
close all
Time = 48;
gamma = 1.3;
maxscore = 100;
maxrep = 20;
maxrom = 180;
Md = zeros(3,Time);
Md(:,1) = [maxrep maxscore maxrom]';
Mt = zeros(3,Time);
Mt1 = zeros(3,Time);
start = [2 40 60]';
Mt(:,1) = start;
epsil = zeros(3,1);
epsilon = zeros(3,1);

for i=2:Time
for j=1:3
epsil(j,1) = (Mt(j,i-1)-Md(j,i-1))/Md(j,i-1);
epsilon(j,1) = Mt(j,i-1)/Md(j,i-1);
end
lambda = diag([1 1 1]);
lambda(1,1) = lambda(1,1) + epsil(1,1)*epsilon(1,1);
lambda(2,2) = lambda(2,2) + epsil(2,1)*epsilon(2,1);
lambda(3,3) = lambda(3,3) + epsil(3,1)*epsilon(3,1);
% display(lambda);
Mt1(:,i) = ceil(lambda*round(Md(:,i-1)));
Md(:,i) = ceil(gamma*Mt1(:,i));
if Md(1,i)>=maxrep
    Md(1,i) = maxrep;
end
if Md(2,i)>=maxscore
    Md(2,i) = maxscore;
end
if Md(3,i)>=maxrom
    Md(3,i) = maxrom;
end
if Mt1(1,i)>=maxrep
    Mt1(1,i) = maxrep;
end
if Mt1(2,i)>=maxscore
    Mt1(2,i) = maxscore;
end
if Mt1(3,i)>=maxrom
    Mt1(3,i) = maxrom;
end

Mt(:,i) = [start(1)+((i/60)*10)+randi([1,2],1) start(2)+((i/60)*50)+randi([5,10],1) start(3)+((i/60)*100)+randi([5,10],1)]';
end
% display(Mt1);
% display(Md);

figure(1)
subplot(3,1,1)
plot(Mt(1,:))
hold on
plot(Mt1(1,2:48))
plot(Md(1,:))
subplot(3,1,2)
plot(Mt(2,:))
hold on
plot(Mt1(2,2:48))
plot(Md(2,:))
subplot(3,1,3)
plot(Mt(3,:))
hold on
plot(Mt1(3,2:48))
plot(Md(3,:))

