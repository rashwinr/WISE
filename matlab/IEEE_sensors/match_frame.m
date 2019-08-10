function q = match_frame(char,Q)
qK = [0,0,0,1];
    switch char
        case 'a'
            th1 = 0.0600;
            qv1 = [0,0.5021,-0.8648,0]; % imu frame
            th2 = -0.0504;
        case 'b'
            th1 = 0.0977;
            qv1 = [0,  0.8925,-0.4511,0];
            th2 = -0.0335;
        case 'c'
            th1 = 0.0385;
            qv1 = [0,  0.7330,0.6802,0];
            th2 = -0.0497;
        case 'd'
            th1 = 0.1948;
            qv1 = [0, 0.8521,-0.5233,0];
            th2 = -0.0232;
        case 'e'
            th1 = 0.1329;
            qv1 = [0,0.9591,-0.2832,0];
            th2 = -0.0343;
    end
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qv1,quatconj(Q)))));
    qv1 = [cos(th1/2),x*sin(th1/2),y*sin(th1/2),z*sin(th1/2)]; %world frame
    Q = quatmultiply(qv1,Q);
%     q = quatmultiply(qv1,Q);
    
    [~,x,y,z] = parts(quaternion(quatmultiply(Q,quatmultiply(qK,quatconj(Q)))));
    qv2 = [cos(th2/2),x*sin(th2/2),y*sin(th2/2),z*sin(th2/2)];
    q = quatmultiply(qv2,Q);

end