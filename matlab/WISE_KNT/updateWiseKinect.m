function [] = updateWiseKinect(char,kin,imu,time,anline,anline1)

imustr = strcat('IMU');kntstr = strcat('KINECT');
lftstr = strcat('Left arm angles');rgtstr = strcat('Right arm angles');
efstr = strcat('Flex-Ext');bdstr = strcat('Abd-Add');iestr = strcat('Int-Ext Rot.');
psstr = strcat('Pro-Sup');jtext = strcat('Joint');etext = strcat('Elbow');
stext = strcat('Shoulder');ftext = strcat('Forearm');
fs = 24;s=35;fontdiv = 1.3;limulocationdiv = 1.9/2.2;rimulocationdiv = 2.1/2.4;lkinlocationdiv = 1.75;rkinlocationdiv = 1.75;
ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     %rectangle coordinates
text(ls+lw/3,1050,'Time (seconds)','Color','white','FontSize',fs/(fontdiv),'FontWeight','bold','HorizontalAlignment','center');
text(ls+(limulocationdiv*lw),1000,num2str(time,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

switch char(1)
    
    case 'l'
        
        text(ls+lw/2,s,lftstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/2,s,strcat('(Mirrored image in display)'),'Color','white','FontSize',20,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');

    case 'r'
        
        text(rs+rw/2,s,rgtstr,'Color','white','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/2,s,strcat('(Mirrored image in display)'),'Color','white','FontSize',20,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,4*s,jtext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),4*s,kntstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),4*s,imustr,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');

end

switch char
    
    case 'offset'
    
    case 'lef'  

        text(ls+lw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

    case 'lbd'
      
        text(ls+lw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,8*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
   
    case {'lelb','lelb1'}
        
        text(ls+lw/5,7*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

    case 'lps'
        
        text(ls+lw/5,7*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,8*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),7.5*s,'NA','Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

    case {'lie','lie1'}
    
        kiniestr = num2str(kin,'%.2f');    
        if kin==666
            kiniestr = strcat('NA');
            kin = 0;
        end
        text(ls+lw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(ls+lw/5,8*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(lw/lkinlocationdiv),7.5*s,kiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(ls+(limulocationdiv*lw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

    case 'ref'
        
        text(rs+rw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');

    case 'rbd'
        
        text(rs+rw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,8*s,bdstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        
    case {'relb','relb1'}
        
        text(rs+rw/5,7*s,etext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,8*s,efstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),7.5*s,num2str(kin,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');   
    
    case 'rps'
        
        text(rs+rw/5,7*s,ftext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,8*s,psstr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),7.5*s,'NA','Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
    
    case {'rie','rie1'}
        
        kiniestr = num2str(kin,'%.2f');    
        if kin==666
            kiniestr = strcat('NA');
            kin = 0;
        end
        text(rs+rw/5,7*s,stext,'Color','white','FontSize',fs/fontdiv,'FontWeight','bold','HorizontalAlignment','center');
        text(rs+rw/5,8*s,iestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rw/rkinlocationdiv),7.5*s,kiniestr,'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        text(rs+(rimulocationdiv*rw),7.5*s,num2str(imu,'%.2f'),'Color','white','FontSize',fs/fontdiv,'FontWeight','normal','HorizontalAlignment','center');
        
end

addpoints(anline,time,kin); 
addpoints(anline1,time,imu);
drawnow;

end

