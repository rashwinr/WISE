function [kinect_ang] = get_Kinect(pos2Dxxx)
% lef,ref,lbd,rbd,lie,rie,lelb,relb
                %Left Side Joints
                leftShoulder = pos2Dxxx(:,5);leftElbow = pos2Dxxx(:,6);leftWrist = pos2Dxxx(:,7);
                %Right Side Joints
                rightShoulder = pos2Dxxx(:,9);rightElbow = pos2Dxxx(:,10);rightWrist = pos2Dxxx(:,11);
                %Spine Joints
                spineShoulder = pos2Dxxx(:,21);
                spinebase = pos2Dxxx(:,1);
                %BACK REFERENCE
                TrunkVector = spinebase-spineShoulder;
                RSLS = (rightShoulder-leftShoulder)/norm(leftShoulder-rightShoulder);
                %normal to transversal plane
                trans_X = (TrunkVector/norm(TrunkVector)); 
                %normal to saggital plane
                sag_Y = ((RSLS-dot(RSLS,trans_X)*trans_X)/norm(RSLS-dot(RSLS,trans_X)*trans_X)); 
                %normal to coronal plane 
                cor_Z = (cross(trans_X,sag_Y)/norm(cross(trans_X,sag_Y)));
                %Shoulder orientation computation
                L_arm = leftElbow-leftShoulder;
                L_arm = (L_arm/norm(L_arm));
                L_arm = [dot(L_arm,trans_X) , dot(L_arm,-sag_Y) , dot(L_arm,-cor_Z)];
                
                R_arm = rightElbow-rightShoulder;
                R_arm = (R_arm/norm(R_arm));
                R_arm = [dot(R_arm,trans_X) , dot(R_arm,sag_Y) , dot(R_arm,-cor_Z)];
                %Shoulder extension flexion
                lef = atan2d(L_arm(3),L_arm(1));
                if lef >= -180 && lef <= -150
                    lef = 360+lef;
                end
                ref = atan2d(R_arm(3),R_arm(1));
                if ref >= -180 && ref <=-150
                    ref = 360+ref;
                end
                %Shoulder abduction adduction
                lbd = atan2d(L_arm(2),L_arm(1));
                if lbd >= -180 && lbd<=-150
                    lbd = 360+lbd;
                end
                rbd = atan2d(R_arm(2),R_arm(1));
                if rbd >= -180 && rbd<=-150
                    rbd = 360+rbd;
                end
                %Elbow joint angle calculation
                LA=(leftElbow-leftShoulder)/norm(leftElbow-leftShoulder);
                LFA=(leftWrist-leftElbow)/norm(leftWrist-leftElbow);
                lelb=acosd(dot(LA,LFA));
                
                RA=(rightElbow-rightShoulder)/norm(rightElbow-rightShoulder);
                RFA=(rightWrist-rightElbow)/norm(rightWrist-rightElbow);
                relb=acosd(dot(RA,RFA));
                %Shoulder internal external calculation
                
                % kinect paper algorithm reduced
                lie = 666;
                if lelb > 30
                    
                    Zref = -(cor_Z-dot(cor_Z,LA)*LA);
                    Zref = Zref/norm(Zref);
                    Yref = sag_Y-dot(sag_Y,LA)*LA;
                    Yref = Yref/norm(Yref);
                    LFA = LFA-dot(LFA,LA)*LA;
                    lie = atan2d(dot(LFA,Yref),dot(LFA,Zref));
                        
                end
                
                rie = 666;
                if relb > 30
                    
                    Zref = -(cor_Z-dot(cor_Z,RA)*RA);
                    Zref = Zref/norm(Zref);
                    Yref = sag_Y-dot(sag_Y,RA)*RA;
                    Yref = -Yref/norm(Yref);
                    RFA = RFA-dot(RFA,RA)*RA;
                    rie = atan2d(dot(RFA,Yref),dot(RFA,Zref));
                    
                end
                
                %JCS algorithm
                %{
                rie = 666;
                if relb > 30
                    thz = -pi/2;
                    Qz = [cos(thz/2),cor_Z(1)*sin(thz/2),cor_Z(2)*sin(thz/2),cor_Z(3)*sin(thz/2)];
                    Rz = quat2rotm(Qz);
                    rY = RA;
                    rX = cross(RFA,rY);
                    rX = rX/norm(rX);
                    rZ = cross(rX,rY);
                    Rb = [trans_X(1),sag_Y(1),cor_Z(1);trans_X(3),sag_Y(3),cor_Z(3);trans_X(3),sag_Y(3),cor_Z(3)];
                    Rb = Rz*Rb;
                    bX = Rb(:,1);
                    bY = Rb(:,2);
                    bZ = Rb(:,3);
                    R = [dot(rX,bX),dot(rY,bX),dot(rZ,bX);dot(rX,bY),dot(rY,bY),dot(rZ,bY);dot(rX,bZ),dot(rY,bZ),dot(rZ,bZ)];
                    rie = -atan2d(R(1,3),R(3,3));
                end
                
                lie = 666;
                if lelb > 30
                    thz = -pi/2;
                    Qz = [cos(thz/2),cor_Z(1)*sin(thz/2),cor_Z(2)*sin(thz/2),cor_Z(3)*sin(thz/2)];
                    Rz = quat2rotm(Qz);
                    lY = LA;
                    lX = cross(LFA,lY);
                    lX = lX/norm(lX);
                    lZ = cross(lX,lY);
                    Rb = [trans_X(1),sag_Y(1),cor_Z(1);trans_X(3),sag_Y(3),cor_Z(3);trans_X(3),sag_Y(3),cor_Z(3)];
                    Rb = Rz*Rb;
                    bX = Rb(:,1);
                    bY = Rb(:,2);
                    bZ = Rb(:,3);
                    R = [dot(lX,bX),dot(lY,bX),dot(lZ,bX);dot(lX,bY),dot(lY,bY),dot(lZ,bY);dot(lX,bZ),dot(lY,bZ),dot(lZ,bZ)];
                    lie = atan2d(R(1,3),R(3,3));
                end
                %}
                
                % kinect paper algorithm
                %{
                lie = 666;
                if lelb > 30
                    PP = [dot(LA,trans_X),dot(LA,sag_Y),dot(LA,cor_Z)];
                    AbsPP = abs(PP);
                    [~,ind] = max(AbsPP);
                    switch ind
                        case 1
                            Zref = -(cor_Z-dot(cor_Z,LA)*LA);
                            Zref = Zref/norm(Zref);
                            Yref = sag_Y-dot(sag_Y,LA)*LA;
                            Yref = Yref/norm(Yref);
                            lie = atan2d(dot(LFA,Yref),dot(LFA,Zref));
                        case 2
                            Zref = -(cor_Z-dot(cor_Z,LA)*LA);
                            Zref = Zref/norm(Zref);
                            Xref = trans_X-dot(trans_X,LA)*LA;
                            Xref = Xref/norm(Xref);
                            lie = atan2d(dot(LFA,Xref),dot(LFA,Zref));
                        case 3
                            Xref = trans_X-dot(trans_X,LA)*LA;
                            Xref = -Xref/norm(Xref);
                            Yref = sag_Y-dot(sag_Y,LA)*LA;
                            Yref = Yref/norm(Yref);
                            lie = atan2d(dot(LFA,Yref),dot(LFA,Xref));
                    end
                end
                
                rie = 666;
                if relb > 30
                    PP = [dot(RA,trans_X),dot(RA,sag_Y),dot(RA,cor_Z)];
                    AbsPP = abs(PP);
                    [~,ind] = max(AbsPP);
                    switch ind
                        case 1
                            Zref = -(cor_Z-dot(cor_Z,RA)*RA);
                            Zref = Zref/norm(Zref);
                            Yref = sag_Y-dot(sag_Y,RA)*RA;
                            Yref = -Yref/norm(Yref);
                            rie = atan2d(dot(RFA,Yref),dot(RFA,Zref));
                        case 2
                            Zref = -(cor_Z-dot(cor_Z,RA)*RA);
                            Zref = Zref/norm(Zref);
                            Xref = trans_X-dot(trans_X,RA)*RA;
                            Xref = Xref/norm(Xref);
                            rie = atan2d(dot(RFA,Xref),dot(RFA,Zref));
                        case 3
                            Xref = trans_X-dot(trans_X,RA)*RA;
                            Xref = -Xref/norm(Xref);
                            Yref = sag_Y-dot(sag_Y,RA)*RA;
                            Yref = -Yref/norm(Yref);
                            rie = atan2d(dot(RFA,Yref),dot(RFA,Xref));
                    end
                    
                end
                %}
                
                % first IMU algorithm
                %{
                LSH = (leftWrist-leftShoulder)/norm((leftWrist-leftShoulder));
                RSH = (rightWrist-rightShoulder)/norm(rightWrist-rightShoulder);
                
                lie = 666;
                if lelb > 30
                    yA = -LA;
                    xA = cross(LSH,LA)/norm(cross(LSH,LA));
                    zA = cross(xA,yA);
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            Xb = -Xb;
                            lie = atan2d(Xb(3),Xb(1));            
                        case 2
                            Yb = -Yb;
                            lie = atan2d(Yb(3),Yb(1));
                        case 3
                            lie = atan2d(-Zb(1),Zb(3)); 
                    end
                end
                
                rie = 666;
                if relb > 30
                    yA = RA;
                    xA = cross(RSH,RA)/norm(cross(RSH,RA));
                    zA = cross(xA,yA);
                    
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            rie = atan2d(-Xb(3),Xb(1));          
                        case 2
                            Yb = -Yb;
                            rie = atan2d(-Yb(3),Yb(1));
                        case 3
                            rie = atan2d(Zb(1),Zb(3));
                    end
                end
                %}
                
                
                kinect_ang = [lef;ref;lbd;rbd;lie;rie;lelb;relb];
                
                
end

