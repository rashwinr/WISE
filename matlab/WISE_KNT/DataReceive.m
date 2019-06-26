function [qA,qB,qC,qD,qE] = DataReceive(ser,qa,qb,qc,qd,qe,thg,thl)
qJ = [0,0,1,0];
qK = [0,0,0,1];

qA = qa;
qB = qb;
qC = qc;
qD = qd;
qE = qe;
ind = ["0","0","0","0","0","0","0","0","0","0"];

parfor (i = 1:10,0)
      ind(1,i) = convertCharsToStrings(fscanf(ser));
end

        flushinput(ser);
        
for j=1:10
    
    data = strsplit(ind(1,j),',');
    
    if(length(data) == 5)
        
            switch data(1)
                case 'e'
                    
                    qE = qconvert(data);
                    qE = match_frame('e',qE);

                    qZ = quatmultiply(qE,quatmultiply(qK,quatconj(qE)));

                    qZ = [cos(thg/2),qZ(2)*sin(thg/2),qZ(3)*sin(thg/2),qZ(4)*sin(thg/2)];
                    qE = quatmultiply(qZ,qE);

                    qY = quatmultiply(qE,quatmultiply(qJ,quatconj(qE)));
                    qY = [cos(thl/2),qY(2)*sin(thl/2),qY(3)*sin(thl/2),qY(4)*sin(thl/2)];
                    qE = quatmultiply(qY,qE);

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

