function [qA,qB,qC,qD,qE] = MatchDataReceive(ser,qa,qb,qc,qd,qe)

qA = qa;
qB = qb;
qC = qc;
qD = qd;
qE = qe;

flg = 0;
i = 1;
datamodified = ["0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0"];
bytes = ser.Bytesavailable;
% while bytes<=250
% bytes = ser.Bytesavailable;    
% end
if bytes < 250
    pause((250-bytes)*0.001)
    bytes = ser.Bytesavailable;
end
str = strsplit(convertCharsToStrings(char(fread(ser,bytes))),'\n');
str = fliplr(str(2:length(str)-1));
% length(str)
while i<=length(str)
    data = strsplit(str(i),',');
    if length(data)==5 && ~any(data(1)==datamodified(:,1)) 
       switch data(1)
           case 'a'
               datamodified(1,:) = data; 
               flg = flg +1;
               
               qA = qconvert(datamodified(1,:));
               qA = match_frame('a',qA);
               

           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
               qB = qconvert(datamodified(2,:));
               qB = match_frame('b',qB);
                    
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
               qC = qconvert(datamodified(3,:));
               qC = match_frame('c',qC);
                    

           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
               qD = qconvert(datamodified(4,:));
               qD = match_frame('d',qD);
            

           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;
               
               qE = qconvert(datamodified(5,:));
               qE = match_frame('e',qE);
               
       end
    end
    if flg == 5
        break
    end
    i = i + 1;
end            
            
            

                    

                    

end

