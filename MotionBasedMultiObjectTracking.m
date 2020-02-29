videoSource = vision.VideoFileReader('source_sequence.avi',...
    'ImageColorSpace','Intensity','VideoOutputDataType','uint8');
% Specify name for output video
v = VideoWriter('peaks.avi');
open(v);
%Foreground Detector
detector = vision.ForegroundDetector(...
       'NumTrainingFrames',250, ...
       'InitialVariance', 30*30);
%Create the blob
   blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
   
   %Place shape for the blob coordinates
   shapeInserter = vision.ShapeInserter('BorderColor','Black');
   videoPlayer = vision.VideoPlayer();
N_frames=utilities.videoReader.NumberOfFrames;   
while ~isDone(videoSource)
    
     frame  = videoSource();
     frame=frame+imread('bwmask.png');%add the mask to frame
     writeVideo(v,frame);
     fgMask = detector(frame);%detect the objects in the frame
     bbox   = blob(fgMask);%get the coordinates for the detected objects
     out    = shapeInserter(frame,bbox);%draw shape around objects
     videoPlayer(out);
end
close(v)