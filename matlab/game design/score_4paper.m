% Md = [R S G]'
clc
clear all
close all
Time = 48;
gamma = 1.1;
maxscore = 100;
maxrep = 20;
maxrom = 180;
Md = zeros(3,Time);
Md(:,1) = [maxrep maxscore maxrom]';
Mt = zeros(3,Time);
Mt1 = zeros(3,Time);
start = [10 60 150]';
Mt(:,1) = start;
epsil = zeros(3,1);
epsilon = zeros(3,1);
fs = 15;LW = 2;
for i=2:Time

    
        for j=1:3
        epsil(j,1) = abs((Md(j,i-1)-Mt(j,i-1))/Md(j,i-1));
        epsilon(j,1) = 1;
        end
    
lambda = diag([1 1 1]);
lambda(1,1) = lambda(1,1) - epsil(1,1);
lambda(2,2) = lambda(2,2) - epsil(2,1);
lambda(3,3) = lambda(3,3) - epsil(3,1);

% display(lambda);
Mt1(:,i) = ceil(lambda*round(Md(:,i-1))+(gamma-1)*Mt(:,i-1));
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

Mt(:,i) = [start(1)-0.015*(i-24)^2 start(2)-0.05*(i-24)^2 start(3)-0.1*(i-24)^2]';
end

figure(1)
subplot(3,1,1)
U = plot(Mt(1,2:48),'LineWidth',LW,'DisplayName','User performance (M_{t})')
hold on
P = plot(Mt1(1,2:48),'LineWidth',LW,'DisplayName','Adapted game parameters (M_{t+1})')
D = plot(Md(1,2:48),'LineWidth',LW,'DisplayName','Desired performance (M_{d})')
xlabel('Time period (T)','FontSize',fs)
ylabel('Repetitions (R)','FontSize',fs)
lgd = legend([U,P,D],'FontSize',fs)
lgd.Orientation = 'horizontal'
subplot(3,1,2)
plot(Mt(2,2:48),'LineWidth',LW)
hold on
plot(Mt1(2,2:48),'LineWidth',LW)
plot(Md(2,2:48),'LineWidth',LW)
xlabel('Time period (T)','FontSize',fs)
ylabel('Score (S)','FontSize',fs)

subplot(3,1,3)
plot(Mt(3,2:48),'LineWidth',LW)
hold on
plot(Mt1(3,2:48),'LineWidth',LW)
plot(Md(3,2:48),'LineWidth',LW)
xlabel('Time period (T)','FontSize',fs)
ylabel('Goal (\chi)','FontSize',fs)

