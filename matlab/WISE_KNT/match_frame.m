function q = match_frame(char,Q)
qK = [0,0,0,1];
    switch char
        case 'a'
            th1 = 0.0464;
            qv1 = [0,  0.9492,-0.3146,0]; % imu frame
            th2 = -0.0613;
        case 'b'
            th1 = 0.1264;
            qv1 = [0,  0.9957,-0.0922,0];
            th2 = -0.0359;
        case 'c'
            th1 = 0.0262;
            qv1 = [0,  0.4807,0.8769,0];
            th2 = -0.0555;
        case 'd'
            th1 = 0.1730;
            qv1 = [0,  0.7588,-0.6513,0];
            th2 = -0.0298;
        case 'e'
            th1 = 0.1053;
            qv1 = [0,  0.9921,0.1258,0];
            th2 = -0.0227;
    end
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qv1,quatconj(Q)))));
    qv1 = [cos(th1/2),x*sin(th1/2),y*sin(th1/2),z*sin(th1/2)]; %world frame
    Q = quatmultiply(qv1,Q);
%     q = quatmultiply(qv1,Q);
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qK,quatconj(Q)))));
    qv2 = [cos(th2/2),x*sin(th2/2),y*sin(th2/2),z*sin(th2/2)];
    q = quatmultiply(qv2,Q);

end