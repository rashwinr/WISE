function [flg,Offsets] = find_offsets(qa,qb,qc,qd,qe)
tol = 10^-1;
flg = 0;
Offsets = zeros(5,4);
ref = [1 0 0 0];

Rqa = [0.9462    0.0441   -0.0089    0.3203];
Rqb = [-0.8582    0.0157    0.0320   -0.5120];
Rqc = [0.9509    0.0499   -0.0263    0.3042];
Rqd = [0.9918    0.0159    0.0481    0.1170];

qrA = quatmultiply(quatconj(qe),qa);
qrB = quatmultiply(quatconj(qe),qb);
qrC = quatmultiply(quatconj(qe),qc);
qrD = quatmultiply(quatconj(qe),qd);

A = quatmultiply(quatconj(qrA),Rqa)
B = quatmultiply(quatconj(qrB),Rqb)
C = quatmultiply(quatconj(qrC),Rqc)
D = quatmultiply(quatconj(qrD),Rqd)

if all(abs(A)-ref<=tol) && all(abs(B)-ref<=tol) && all(abs(C)-ref<=tol) && all(abs(D)-ref<=tol)
    Offsets(1,:) = qa;
    Offsets(2,:) = qb;
    Offsets(3,:) = qc;
    Offsets(4,:) = qd;
    Offsets(5,:) = qe;
    flg=1;
end
end