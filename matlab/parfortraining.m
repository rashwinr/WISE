clear all
close all
clc
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200,'InputBufferSize',200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
data = ["0","0","0","0","0";
         "0","0","0","0","0";
         "0","0","0","0","0";
         "0","0","0","0","0";
         "0","0","0","0","0";];
q = [1,0,0,0;
    1,0,0,0;
    1,0,0,0;
    1,0,0,0;
    1,0,0,0;];
ind = ["0","0","0","0","0"];
     %%
tic
 parfor (i = 1:5,0)
      ind(1,i) = convertCharsToStrings(fscanf(ser));       
%       ind(i) = strsplit(string(line),',');
 end
 toc
  flushinput(ser)
  ind
 %%
 tic
 for i = 1:5
      line = fscanf(ser);       
      data(i,:) = strsplit(string(line),',');
 end
 toc
%  parfor (i = 1:5,0)
%      ind(i) = data(i,1);
%         if ind(i) == 'e'
%             qE = q(i,:);
%         end
%  end
%  
 flushinput(ser)
 
 

%      switch ind(i)
%          case 'e'
%             qE = q(i,:);
%         case 'a'
%             qA = q(i,:);
%         case 'c'
%             qC = q(i,:);
%         case 'd'
%             qD = q(i,:);
%         case 'b'
%             qB = q(i,:);
%      end

 
%  parfor (i = 1:5,4)
%      dat(1,i) = data(i,:);
% %      switch dat(i)
% %         case 'e'
% %             qE = [1,0,0,1];
% % %             qE = [str2double(data(i,2))*m+p, str2double(data(i,2))*m+p , str2double(data(i,2))*m+p , str2double(data(i,2))*m+p ];
% %         case 'a'
% % %             qA = [str2double(data(i,2))*m+p, str2double(data(i,2))*m+p , str2double(data(i,2))*m+p , str2double(data(i,2))*m+p ];
% %         case 'c'
% % %             qC = [str2double(data(i,2))*m+p, str2double(data(i,2))*m+p , str2double(data(i,2))*m+p , str2double(data(i,2))*m+p ];
% %         case 'd'
% % %             qD = [str2double(data(i,2))*m+p, str2double(data(i,2))*m+p , str2double(data(i,2))*m+p , str2double(data(i,2))*m+p ];
% %         case 'b'
% % %             qB = [str2double(data(i,2))*m+p, str2double(data(i,2))*m+p , str2double(data(i,2))*m+p , str2double(data(i,2))*m+p ];
% %      end
%  end