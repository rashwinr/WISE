function [qA,qB,qC,qD,qE] = DataReceive(ser,qa,qb,qc,qd,qe,thg,thl)
qJ = [0,0,1,0];
qK = [0,0,0,1];

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
while bytes<=200
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

               qZ = quatmultiply(qE,quatmultiply(qK,quatconj(qE)));

               qZ = [cos(thg/2),qZ(2)*sin(thg/2),qZ(3)*sin(thg/2),qZ(4)*sin(thg/2)];
               qE = quatmultiply(qZ,qE);
               
               qY = quatmultiply(qE,quatmultiply(qJ,quatconj(qE)));
               qY = [cos(thl/2),qY(2)*sin(thl/2),qY(3)*sin(thl/2),qY(4)*sin(thl/2)];
               qE = quatmultiply(qY,qE);
       end
    end
    if flg == 5
        break
    end
    i = i + 1;
end            
            
            

                    

                    

end

