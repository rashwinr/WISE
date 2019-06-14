function [flg,Offsets] = find_offsets(qa,qb,qc,qd,qe)
tol = 10^-1;
flg = 0;
Offsets = zeros(5,4);
ref = [1 0 0 0];

Rqa = [0.9407    0.0692    0.0297   -0.3309];
Rqb = [0.9907   -0.0081    0.0199    0.1343];
Rqc = [-0.9649   -0.0182   -0.0290    0.2604];
Rqd = [-0.9982   -0.0175   -0.0498    0.0272];

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