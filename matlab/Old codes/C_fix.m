function fix = C_fix(q)
    qOFF = [-0.9766    0.0070    0.0070    0.2149];
    
    fix = quatmultiply(quatconj(qOFF),q);
end