function [qA,qB,qC,qD,qE] = DataRecieve_Relative(ser,qa,qb,qc,qd,qe)

qA = qa;
qB = qb;
qC = qc;
qD = qd;
qE = qe;
Qa = [ -0.5479    0.5579    0.4337   -0.4477];
Qb = [-0.5718    0.6038    0.4055   -0.3795];
Qc = [-0.5642    0.5602    0.4259   -0.4319];
Qd = [ -0.5372    0.6053    0.4452   -0.3832];
Qe = [ -0.5302    0.6144    0.4240   -0.4019];
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
               qA = quatmultiply(quatconj(Qa),qA);
           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
               qB = qconvert(datamodified(2,:));
               qB = quatmultiply(quatconj(Qb),qB);     
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
               qC = qconvert(datamodified(3,:));
               qC = quatmultiply(quatconj(Qc),qC);
           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
               qD = qconvert(datamodified(4,:));
               qD = quatmultiply(quatconj(Qd),qD);               
           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;               
               qE = qconvert(datamodified(5,:));
               qE = quatmultiply(quatconj(Qe),qE);
       end
    end
    
    if flg == 5
        break
    end
    i = i + 1;
end            
            
            

                    

                    

end

