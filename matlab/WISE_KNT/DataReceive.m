function [qA,qB,qC,qD,qE] = DataReceive(ser,qa,qb,qc,qd,qe)
qJ = [0,0,1,0];
th = 20 *pi/180;
qA = qa;
qB = qb;
qC = qc;
qD = qd;
qE = qe;
 ind = ["0","0","0","0","0"];
parfor (i = 1:5,0)
      ind(1,i) = convertCharsToStrings(fscanf(ser));
end
        flushinput(ser);
for j=1:5
    data = strsplit(ind(1,j),',');
    if(length(data) == 5)
            switch data(1)
                case 'e'
                qE = qconvert(data);
                qE = match_frame('e',qE);
                qI = quatmultiply(qE,quatmultiply(qJ,quatconj(qE)));
                qI = [cos(th/2),qI(2)*sin(th/2),qI(3)*sin(th/2),qI(4)*sin(th/2)];
                qE = quatmultiply(qI,qE);
                case 'a'
                qA = qconvert(data);
                qA = match_frame('a',qA);
                case 'c'
                qC = qconvert(data);
                qC = match_frame('c',qC);
                case 'd'
                qD = qconvert(data);
                qD = match_frame('d',qD);
                case 'b'
                qB = qconvert(data);
                qB = match_frame('b',qB);
            end 
    end
    
end


end

