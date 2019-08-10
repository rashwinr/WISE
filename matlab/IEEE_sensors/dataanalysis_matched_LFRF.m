clc;clear all;close all
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors\');
cd(strcat('F:\github\wearable-jacket\matlab\IEEE_sensors\data_matched\LF,RF\'));
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
sts = 'F:\github\wearable-jacket\matlab\IEEE_sensors\data_matched\LF,RF\';
for i = 3:size(list,1)
    AX(i-2) = list(i).name;
end

figure(1)
sgtitle('WISE Sensor LA angles')
figure(2)
sgtitle('WISE Sensor RA angles')

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
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 figure(1)
                                 hold on
                                 subplot(9,3,1)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,1)
                                 hold on

                             case '20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,4)
                                 hold on
                                 plot(t1,theta2)
                             case '-20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,7)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,7)
                                 hold on

                             case '40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,10)
                                 hold on
                                 plot(t1,theta2)

                             case '-40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,13)
                                 hold on
                                 plot(t1,theta2)

                             case '60'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,16)
                                 hold on
                                 plot(t1,theta2)

                             case '-60'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,19)
                                 hold on
                                 plot(t1,theta2)

                             case '80'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,22)
                                 hold on
                                 plot(t1,theta2)
                             case '-80'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,25)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,25)
                                 hold on

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
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);figure(1)
                                 hold on
                                 subplot(9,3,2)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,2)
                                 hold on
                                 plot(t1,theta2)

                             case '20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,5)
                                 hold on
                                 plot(t1,theta2)

                             case '-20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,8)
                                 hold on
                                 plot(t1,theta2)

                             case '40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,11)
                                 hold on
                                 plot(t1,theta2)

                             case '-40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,14)
                                 hold on
                                 plot(t1,theta2)

                             case '60'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,17)
                                 hold on
                                 plot(t1,theta2)

                             case '-60'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,20)
                                 hold on
                                 plot(t1,theta2)

                             case '80'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,23)
                                 hold on
                                 plot(t1,theta2)

                             case '-80'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,26)
                                 hold on
                                 plot(t1,theta2)

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
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 hold on
                                 subplot(9,3,3)
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,3)
                                 hold on
                                 plot(t1,theta2)

                             case '20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,6)
                                 hold on
                                 plot(t1,theta2)

                             case '-20'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,9)
                                 hold on
                                 plot(t1,theta2)

                             case '40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,12)
                                 hold on
                                 plot(t1,theta2)

                             case '-40'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,15)
                                 hold on
                                 plot(t1,theta2)

                             case '60'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,18)
                                 hold on
                                 plot(t1,theta2)

                             case '-60'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,21)
                                 hold on
                                 plot(t1,theta2)

                             case '80'
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,24)
                                 hold on
                                 plot(t1,theta2)

                             case '-80'                              
                                 [theta1,theta2]=importangles(spike_files(k).name,[1,200]);
                                 t1 = importtime(spike_files(k).name,[1,200]);
                                 [theta1,theta2] = anglerad2degreesLFRF(theta1,theta2,f2(1),AX(i),fid);
                                 figure(1)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta1)
                                 figure(2)
                                 subplot(9,3,27)
                                 hold on
                                 plot(t1,theta2)

              end
        end        
        
        
end
end

fclose(fid);