function fix = axis_fix(q,qOFF)
    
    fix = quatmultiply(quatconj(qOFF),q);
end