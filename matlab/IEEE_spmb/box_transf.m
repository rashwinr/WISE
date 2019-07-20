function q = box_transf(char,Q)
qK = [0,0,0,1];
    switch char
        case 'a'
            qt = [0.9999    0.0050   -0.0090   -0.0090];
        case 'b'
            qt = [-0.9990   -0.0370    0.0190    0.0190];
        case 'c'
            qt = [-0.9999   -0.0090   -0.0050    0.0110];
        case 'd'
            qt = [0.9942    0.0931   -0.0531   -0.0090];
        case 'e'
            qt = [-0.9972   -0.0690   -0.0010    0.0290];
    end
    
    qt = quatmultiply(Q,quatmultiply(qt,quatconj(Q)));
    q = quatmultiply(qt,Q);

end