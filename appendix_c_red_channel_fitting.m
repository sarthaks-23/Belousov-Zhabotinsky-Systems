% Appendix C: RED Channel Analysis and Model Fitting
% Place your video file in the directory and name it 'IMG_5146.MOV'
% This script extracts the RED intensity, detects valleys, and fits Oregonator output

clear; clc; close all;

videoFile = 'IMG_5146.MOV';       
vid = VideoReader(videoFile);
numFrames = floor(vid.Duration * vid.FrameRate);

firstFrame = readFrame(vid);
figure; imshow(firstFrame);
title('Click TOP-LEFT, then BOTTOM-RIGHT of ROI');
[x, y] = ginput(2); close;
x = round(x); y = round(y);
x1 = max(1, min(x(1), x(2))); x2 = min(size(firstFrame, 2), max(x));
y1 = max(1, min(y(1), y(2))); y2 = min(size(firstFrame, 1), max(y));

% Extracting RGB from ROI
frameRGB = zeros(numFrames, 3);
vid.CurrentTime = 0;
for k = 1:numFrames
    frame = readFrame(vid);
    roi = frame(y1:y2, x1:x2, :);
    roiDouble = im2double(roi);
    frameRGB(k, :) = squeeze(mean(mean(roiDouble, 1), 2));
end

% Normalize and smooth
frameRGB_normalized = frameRGB ./ sum(frameRGB, 2);
windowSize = 15;
r = movmean(frameRGB_normalized(:,1), windowSize);
t = linspace(0, vid.Duration, numFrames)';

% Plot RED channel
plot(t, r); xlabel('Time (s)'); ylabel('Normalized RED');
title('Smoothed RED Channel Time-Series');
