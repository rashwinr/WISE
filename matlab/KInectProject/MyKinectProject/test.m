imaqhwinfo;
%% RGB image
%info.DeviceInfo(1)
colorVid=videoinput('kinect',1);
preview(colorVid);


%%
depthVid=videoinput('kinect',2);
preview(depthVid);