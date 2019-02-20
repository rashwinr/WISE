cd('F:\Jacket\data\raw\');
list=dir();  
clc
clear all
close all
format bank
spike_files=dir('*.txt');  
fid = fopen('F:\Jacket\data\euleranglesummary.txt','w');
fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Applied angle','aX','aY','aZ','bX','bY','bZ','cX','cY','cZ','dX','dY','dZ');
for i = 1:length(spike_files)     
   filename = strcat('F:\Jacket\data\raw\',spike_files(i).name);
   formatSpec = '%s%[^\n\r]';
   fileID = fopen(filename,'r');
   dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
   dataArray{1} = strtrim(dataArray{1});
   fclose(fileID);
   Untitled = [dataArray{1:end-1}];
   for j = 2:length(Untitled)
       C = strsplit(string(char(Untitled{j})),',');
        time(1,j-1) = double(C(1,17));
       ceulerangle(1:3,j-1) = double(C(1,10:12));
       ceulerangle(1:3,j-1) = xyzoffset(ceulerangle(1:3,j-1));
       aeulerangle(1:3,j-1) = double(C(1,2:4));
       aeulerangle(1:3,j-1) = xyzoffset(aeulerangle(1:3,j-1));
       beulerangle(1:3,j-1) = double(C(1,6:8));
       beulerangle(1:3,j-1) = xyzoffset(beulerangle(1:3,j-1));
       deulerangle(1:3,j-1) = double(C(1,14:16));
       deulerangle(1:3,j-1) = xyzoffset(deulerangle(1:3,j-1));

   end
   name = string(char(strsplit(spike_files(i).name,'.')));
   name2 = string(char(strsplit(name(1),'_')));
   
    if(double(name2(1))>=0)
   [peak,t] = findpeaks(beulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
    end
    if(double(name2(1))<=0)
   [peak,t] = findpeaks(-beulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
   peak = -1*peak;
    end
    
    
    if(double(name2(1))>=0)
   [peaks,t1] = findpeaks(deulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
    end
    if(double(name2(1))<=0)
   [peaks,t1] = findpeaks(-deulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
   peaks = -1*peaks;
    end
    
    
        if(double(name2(1))>=0)
   [peakC,tC] = findpeaks(ceulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
    end
    if(double(name2(1))<=0)
   [peakC,tC] = findpeaks(-ceulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
   peakC = -1*peakC;
    end
    if(double(name2(1))>=0)
   [peaksA,tA] = findpeaks(aeulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
    end
    if(double(name2(1))<=0)
   [peaksA,tA] = findpeaks(-aeulerangle(1,:),'MinPeakDistance',25,'MinPeakProminence',5);
   peaksA = -1*peaksA;
    end
%    figure(i)
%    figure('NumberTitle', 'off', 'Name',spike_files(i).name);
%    subplot(2,1,1)
%    plot(time,ceulerangle);
%       hold on
%    scatter(time(tC),peakC)
%    subplot(2,1,2)
%    plot(time,aeulerangle);
%    hold on
%    scatter(time(tA),peaksA)
%    hold off
fprintf( fid, '%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',name(1)+' _max ',max(aeulerangle(1,:)),max(aeulerangle(2,:)),max(aeulerangle(3,:)),max(beulerangle(1,:)),max(beulerangle(2,:)),max(beulerangle(3,:)),max(ceulerangle(1,:)),max(ceulerangle(2,:)),max(ceulerangle(3,:)),max(deulerangle(1,:)),max(deulerangle(2,:)),max(deulerangle(3,:)));
fprintf( fid, '%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',name(1)+' _min ',min(aeulerangle(1,:)),min(aeulerangle(2,:)),min(aeulerangle(3,:)),min(beulerangle(1,:)),min(beulerangle(2,:)),min(beulerangle(3,:)),min(ceulerangle(1,:)),min(ceulerangle(2,:)),min(ceulerangle(3,:)),min(deulerangle(1,:)),min(deulerangle(2,:)),min(deulerangle(3,:)));
fprintf(fid, '%s,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,',name(1)+'_peaksB_Y  ',peak);
fprintf(fid,'\n');
fprintf(fid, '%s,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,',name(1)+'_peaksD_Y  ',peaks);
fprintf(fid,'\n');
fprintf(fid, '%s,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,',name(1)+'_peaksC_Y  ',peakC);
fprintf(fid,'\n');
fprintf(fid, '%s,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,',name(1)+'_peaksA_Y  ',peaksA);
fprintf(fid,'\n');
clearvars filename formatSpec fileID dataArray ans str1 deulerangle ceulerangle aeulerangle beulerangle time C Untitled;% peak peaks t t1; 
end
 fclose(fid);
 
 %%
 function xyzoff = xyzoffset(euler)
  if(euler(1,1)>=180)
           euler(1,1) = euler(1,1)-360;
  end
  if(euler(3,1)>=180)
           euler(3,1) = euler(3,1)-360;
  end
  if(euler(2,1)>=180)
           euler(2,1) = euler(2,1)-360;
  end
  
  xyzoff = euler;
 end