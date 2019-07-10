clc;clear all;close all
cd(strcat('F:\github\wearable-jacket\matlab\IEEE_spmb\data\'));
list1 = dir();
t1 = zeros(200,1);
q1 = zeros(200,4);
q2 = zeros(200,4);
theta = zeros(200,1);

IMUID = strings(size(list1,1)-2,1);
for i = 3:size(list1,1)
IMUID(i-2) = list1(i).name;
end

for i=1:length(IMUID)
    
    
    
    switch IMUID(i)
        case 'D'
        figure(1)
        sgtitle('IMU D angle testing');
        hold on
        sts = strcat('F:\github\wearable-jacket\matlab\IEEE_spmb\data\',IMUID(i));
        cd(sts);
        list2 = dir();
        AXISID = strings(size(list2,1)-2,1);
        for j = 3:size(list2,1)
            AXISID(j-2) = list2(j).name;
            switch AXISID(j-2)

                case 'X'
                    cd(strcat(sts,'\',AXISID(j-2)));
                    spike_files=dir('*.txt');
                    for k=1:length(spike_files)
                         f1 = strsplit(spike_files(k).name,'.');
                         f2 = strsplit(string(f1(1)),'_');
                         switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,1)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,4)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,7)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,10)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,13)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,16)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,19)
                                 hold on
                                 plot(t1,theta*180/pi)
                         end
                    end
                case 'Y'
                    cd(strcat(sts,'\',AXISID(j-2)));
                    spike_files=dir('*.txt');
                    for k=1:length(spike_files)
                         f1 = strsplit(spike_files(k).name,'.');
                         f2 = strsplit(string(f1(1)),'_');
                         switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,2)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,5)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,8)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,11)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,14)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,17)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,20)
                                 hold on
                                 plot(t1,theta*180/pi)
                         end
                    end
                case 'Z'
                    cd(strcat(sts,'\',AXISID(j-2)));
                    spike_files=dir('*.txt');
                    for k=1:length(spike_files)
                         f1 = strsplit(spike_files(k).name,'.');
                         f2 = strsplit(string(f1(1)),'_');
                         switch f2(1)

                             case '0'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,3)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,6)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-20'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,9)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,12)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-40'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,15)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '60'
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,18)
                                 hold on
                                 plot(t1,theta*180/pi)
                             case '-60'                              
                                 [t1,q1(:,1),q1(:,2),q1(:,3),q1(:,4),q2(:,1),q2(:,2),q2(:,3),q2(:,4),theta]=importfile1(spike_files(k).name,[1,200]);
                                 subplot(7,3,21)
                                 hold on
                                 plot(t1,theta*180/pi)
                         end
                    end
            end
        end
    end


%     for k = 1:length(spike_files)
%     f1 = strsplit(spike_files(k).name,'.');
%     f2 = strsplit(string(f1(1)),'_');
%     end

end