function [qA,qB,qC,qD,qE] = DataReceive(ser,qa,qb,qc,qd,qe)
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
                case 'a'
                qA = qconvert(data);
                case 'c'
                qC = qconvert(data);
                case 'd'
                qD = qconvert(data);
                case 'b'
                qB = qconvert(data);   
            end 
    end
    
end


end

