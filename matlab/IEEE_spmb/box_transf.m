function q = box_transf(char,Q)
qK = [0,0,0,1];
    switch char
        case 'a'
            th1 = 0.0283;
            qv1 = [0,0.5121,-0.8589,0]; % imu frame
            th2 = -0.0277;
        case 'b'
            th1 = 0.0741;
            qv1 = [0,  0.9065,-0.4223,0];
            th2 = -0.0332;
        case 'c'
            th1 = 0.0216;
            qv1 = [0,  0.9042,0.4271,0];
            th2 = -0.0051;
        case 'd'
            th1 = 0.1973;
            qv1 = [0, 0.7493,-0.6623,0];
            th2 = -0.0266;
        case 'e'
            th1 = 0.1277;
            qv1 = [0,0.9814,-0.1921,0];
            th2 = -0.0335;
    end
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qv1,quatconj(Q)))));
    qv1 = [cos(th1/2),x*sin(th1/2),y*sin(th1/2),z*sin(th1/2)]; %world frame
    Q = quatmultiply(qv1,Q);
%     q = quatmultiply(qv1,Q);
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qK,quatconj(Q)))));
    qv2 = [cos(th2/2),x*sin(th2/2),y*sin(th2/2),z*sin(th2/2)];
    q = quatmultiply(qv2,Q);

end