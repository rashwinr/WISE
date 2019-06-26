function fix = E_fix(q)
    qOFF = [-0.9805    0.0230    0.0070    0.1949];
    
    fix = quatmultiply(quatconj(qOFF),q);
end