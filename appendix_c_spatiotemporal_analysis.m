% Appendix C: Spatio-Temporal Wavefront Analysis
% Analyze wave propagation in radial direction using RGB video frames

clc; clear;

videoFile = 'IMG_5155 2.MOV';  
vid = VideoReader(videoFile);
frameRate = vid.FrameRate;

firstFrame = readFrame(vid);
figure; imshow(firstFrame);
title('Click TOP-LEFT and BOTTOM-RIGHT of ROI');
[x, y] = ginput(2); close;
x = round(x); y = round(y);
x1 = min(x); x2 = max(x);
y1 = min(y); y2 = max(y);

W = x2 - x1 + 1;
H = y2 - y1 + 1;
centerX = round(W / 2);
centerY = round(H / 2);
maxRadius = floor(min(H, W) / 2);
theta = linspace(0, 2*pi, 100);

spatialProfile = [];
spatialProfile_R = [];
spatialProfile_G = [];
spatialProfile_B = [];

vid.CurrentTime = 0;
while hasFrame(vid)
    rgb = readFrame(vid);
    roi = rgb(y1:y2, x1:x2, :);
    red   = double(roi(:,:,1));
    green = double(roi(:,:,2));
    blue  = double(roi(:,:,3));
    grayFrame = 0.2989 * red + 0.5870 * green + 0.1140 * blue;

    rRow = zeros(1, maxRadius);
    for r = 1:maxRadius
        xCirc = round(centerX + r * cos(theta));
        yCirc = round(centerY + r * sin(theta));
        valid = xCirc > 0 & xCirc <= W & yCirc > 0 & yCirc <= H;
        idx = sub2ind([H W], yCirc(valid), xCirc(valid));
        rRow(r) = mean(red(idx));
    end
    spatialProfile_R = [spatialProfile_R; rRow];
end

imagesc(spatialProfile_R); colormap(jet);
xlabel('Radius (pixels)'); ylabel('Time (frames)');
title('Spatio-Temporal RED Profile');
