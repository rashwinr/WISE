function [qA,qB,qC,qD,qE] = TransfDataReceive(ser,qa,qb,qc,qd,qe)
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];
G = [0,0,-1];

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
while bytes<=250
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
               qA = box_transf('a',qA);
               

           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
               qB = qconvert(datamodified(2,:));
               qB = box_transf('b',qB);
                    
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
               qC = qconvert(datamodified(3,:));
               qC = box_transf('c',qC);
                    

           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
               qD = qconvert(datamodified(4,:));
               qD = box_transf('d',qD);
            

           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;
               
               qE = qconvert(datamodified(5,:));
               qE = box_transf('e',qE);
               
       end
    end
    if flg == 5
        break
    end
    i = i + 1;
end            
            
            

                    

                    

end

