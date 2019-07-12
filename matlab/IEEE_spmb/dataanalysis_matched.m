clc;clear all;close all
addpath('F:\github\wearable-jacket\matlab\IEEE_spmb\');
cd(strcat('F:\github\wearable-jacket\matlab\IEEE_spmb\data_matched\A,B,C,D\'));
list = dir();
t1 = zeros(200,1);
q1 = zeros(200,4);
q2 = zeros(200,4);
q3 = zeros(200,4);
q4 = zeros(200,4);
theta1 = zeros(200,1);
theta2 = zeros(200,1);
theta3 = zeros(200,1);
theta4 = zeros(200,1);
AX = strings(size(list,1)-2,1);
sts = 'F:\github\wearable-jacket\matlab\IEEE_spmb\data_matched\A,B,C,D\';
for i = 3:size(list,1)
    AX(i-2) = list(i).name;
end

figure(1)
sgtitle('WISE Sensor A angles')
figure(2)
sgtitle('WISE Sensor B angles')
figure(3)
sgtitle('WISE Sensor C angles')
figure(4)
sgtitle('WISE Sensor D angles')
fname = strcat(sts,'turntablepeaks.txt');
fid = fopen(fname,'wt');
for i=1:length(AX)
    
switch AX(i)
    
    case 'X'
        cd(strcat(sts,AX(i),'\'));
        spike_files=dir('*.txt');
        for k=1:length(spike_files)
             f1 = strsplit(spike_files(k).name,'.');
             f2 = strsplit(string(f1(1)),'_');
             switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 figure(1)
                                 hold on
                                 subplot(9,3,1)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,1)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,1)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,1)
                                 hold on
                                 plot(t1,theta4)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta4)
                                 clearvars tp1 tp2 tp3 tp4
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);                                 
                                 figure(1)
                                 subplot(9,3,7)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,7)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,7)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,7)
                                 hold on
                                 plot(t1,theta4)
                                 clearvars tw1 tw2 tw3 tw4
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta4)
                                 clearvars tp1 tp2 tp3 tp4
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta4)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta4)
                                 clearvars tp1 tp2 tp3 tp4
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta4)
                             case '80'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta4)
                                 clearvars tp1 tp2 tp3 tp4
                             case '-80'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,25)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,25)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,25)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,25)
                                 hold on
                                 plot(t1,theta4)
              end
        end
        
    case 'Y'
        cd(strcat(sts,AX(i),'\'));
        spike_files=dir('*.txt');
        for k=1:length(spike_files)
             f1 = strsplit(spike_files(k).name,'.');
             f2 = strsplit(string(f1(1)),'_');
             switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 figure(1)
                                 hold on
                                 subplot(9,3,2)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,2)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,2)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,2)
                                 hold on
                                 plot(t1,theta4)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta4)
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta4)
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta4)
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta4)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta4)
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta4)
                             case '80'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta4)
                             case '-80'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta4)
              end
        end
        
        
    case 'Z'
        cd(strcat(sts,AX(i),'\'));
        spike_files=dir('*.txt');
        for k=1:length(spike_files)
             f1 = strsplit(spike_files(k).name,'.');
             f2 = strsplit(string(f1(1)),'_');
             switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 figure(1)
                                 hold on
                                 subplot(9,3,3)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,3)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,3)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,3)
                                 hold on
                                 plot(t1,theta4)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta4)
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta4)
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta4)
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta4)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta4)
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta4)
                             case '80'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta4)
                             case '-80'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),q3(:,1),q3(:,2),q3(:,3),q3(:,4),q4(:,1),q4(:,2),q4(:,3),q4(:,4),theta1,theta2,theta3,theta4]=importfile2(spike_files(k).name,[1,200]);
                                 [theta1,theta2,theta3,theta4] = anglerad2degrees(theta1,theta2,theta3,theta4,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta2)
                                 figure(3)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta3)
                                 figure(4)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta4)
              end
        end        
        
        
end
end

fclose(fid);