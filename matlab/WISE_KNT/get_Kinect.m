function [lef,ref,lbd,rbd,lie,rie,lelb,relb] = get_Kinect(pos2Dxxx)

                %Left Side Joints
                leftShoulder = pos2Dxxx(:,5);leftElbow = pos2Dxxx(:,6);leftWrist = pos2Dxxx(:,7);
                %Right Side Joints
                rightShoulder = pos2Dxxx(:,9);rightElbow = pos2Dxxx(:,10);rightWrist = pos2Dxxx(:,11);
                %Spine Joints
                spineShoulder = pos2Dxxx(:,21);
                spinebase = pos2Dxxx(:,1);
                %BACK REFERENCE
                TrunkVector = spinebase-spineShoulder;
                RSLS = (leftShoulder-rightShoulder)/norm(leftShoulder-rightShoulder);
                                                                                            %normal to transversal plane
                trans_X = (TrunkVector/norm(TrunkVector)); 
                                                                                            %normal to saggital plane
                sag_Y = ((RSLS-dot(RSLS,trans_X)*trans_X)/norm(RSLS-dot(RSLS,trans_X)*trans_X)); 
                                                                                            %normal to coronal plane 
                cor_Z = (cross(trans_X,sag_Y)/norm(cross(trans_X,sag_Y)));
                                                                                            %Shoulder orientation computation
                L_arm = leftElbow-leftShoulder;
                L_arm = (L_arm/norm(L_arm));
                L_arm = [dot(L_arm,trans_X) , dot(L_arm,sag_Y) , dot(L_arm,cor_Z)];
                R_arm = rightElbow-rightShoulder;
                R_arm = (R_arm/norm(R_arm));
                R_arm = [dot(R_arm,trans_X) , dot(R_arm,sag_Y) , dot(R_arm,cor_Z)];
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
                rbd = atan2d(-R_arm(2),R_arm(1));
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
                lie = 666;
                if lelb > 30
                    xA = -LA;
                    zA = cross(LFA,LA)/norm(cross(LFA,LA));
                    yA = cross(zA,xA);
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            Xb = -Xb;
                            if Yb(1)>0
                                lie = -atan2d(Xb(2),Xb(3));            
                            else
                                lie = -atan2d(Xb(2),Xb(3));
                            end
                        case 2
                            if Xb(1)>0
                                lie = -atan2d(Yb(2),Yb(3));
                            else
                                Yb = -Yb;
                                lie = -atan2d(Yb(2),Yb(3));
                            end
                        case 3
                            if -Zb(2)>0
                                Zb = -Zb;
                                lie = atan2d(Zb(3),Zb(2));
                            else
                                lie = atan2d(Zb(3),Zb(2));
                            end
                    end
                end
                
                rie = 666;
                if relb > 30
                    xA = RA;
                    zA = cross(RA,RFA)/norm(cross(RA,RFA));
                    yA = cross(zA,xA);
                    
                    Xb = [dot(trans_X,xA),dot(trans_X,yA),dot(trans_X,zA)];
                    Yb = [dot(sag_Y,xA),dot(sag_Y,yA),dot(sag_Y,zA)];
                    Zb = [dot(cor_Z,xA),dot(cor_Z,yA),dot(cor_Z,zA)];
                    
                    PP = [Xb(1),Yb(1),Zb(1)];
                    AbsPP = abs(PP);
                    [~,ind] = min(AbsPP);
                    switch ind
                        case 1
                            Xb = -Xb;
                            if Yb(1)>0
                                rie = -atan2d(Xb(2),Xb(3));            
                            else
                                rie = -atan2d(Xb(2),Xb(3));
                            end
                        case 2
                            if Xb(1)>0
                                rie = -atan2d(Yb(2),Yb(3));
                            else
                                Yb = -Yb;
                                rie = -atan2d(Yb(2),Yb(3));
                            end
                        case 3
                            if -Zb(2)>0
                                Zb = -Zb;
                                rie = atan2d(Zb(3),Zb(2));
                            else
                                rie = atan2d(Zb(3),Zb(2));
                            end
                    end
                end
end

