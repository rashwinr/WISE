function q = box_transf(char,Q)

    switch char
        case 'a'
            qt = [-0.9992   -0.0190    0.0130    0.0330];
        case 'b'
            qt = [-0.9984   -0.0450    0.0230    0.0270];
        case 'c'
            qt = [-0.9991   -0.0310   -0.0070    0.0270];
        case 'd'
            qt = [0.9938    0.0913   -0.0592   -0.0251];
        case 'e'
            qt = [-0.9967   -0.0750    0.0070    0.0310];
    end
    
    qt = quatmultiply(Q,quatmultiply(qt,quatconj(Q)));
    q = quatmultiply(qt,Q);

end