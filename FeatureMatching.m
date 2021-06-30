clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.

%read the image 
reference_image = imread('DSC_0312.jpg');
reference_gray = im2double(rgb2gray(reference_image));
cluttered_plant_image = imread('DSC_0309.jpg');
plant_gray = im2double(rgb2gray(cluttered_plant_image));

[hue,saturation,value] = rgb2hsv(reference_image);
hue = 360*hue;
binaryMask = (hue > 75 & hue <130);
figure; imshow(binaryMask);
reference_gray = reference_gray.*binaryMask;
figure, imshow(reference_gray);

hsv = rgb2hsv(cluttered_plant_image);
hue = 360*hsv(:,:,1);
binaryMask = (hue > 75 & hue <130);
figure; imshow(binaryMask);
plant_gray = plant_gray.*binaryMask;
figure, imshow(plant_gray);
%detect SURF feature points in reference image
reference_points = detectSURFFeatures(reference_gray,'ROI',[1166,1000,3000,1300]);
imshow(reference_image); hold on;
plot(selectStrongest(reference_points, 400));



plant_points = detectSURFFeatures(plant_gray, 'ROI', [1100,1,2000,3300]);
%detect SURF feature points in cluttered image 
imshow(cluttered_plant_image); hold on;
plot(selectStrongest(plant_points, 300));

%extract feature

[reference_features, reference_points] = extractFeatures(reference_gray, reference_points);
[plant_feature, plant_points] = extractFeatures(plant_gray, plant_points);

%feature matching 

match_pairs = matchFeatures(reference_features, plant_feature);
match_reference_points = reference_points(match_pairs(:,1),:);
match_plant_points = plant_points(match_pairs(:,2),:);
figure;
showMatchedFeatures(reference_image, cluttered_plant_image, match_reference_points,...
    match_plant_points,'montage');
title('Putatively matching points(With Outlier');

%feature matching without outlier
[tform, inlierIdx] = estimateGeometricTransform(match_reference_points, match_plant_points, 'similarity');
inlier_reference  = match_reference_points(inlierIdx, :);
inlier_plant = match_plant_points(inlierIdx, :);

figure;
showMatchedFeatures(reference_image, cluttered_plant_image, inlier_referenc, ...
    inlier_plant, 'montage');
title('Matched Points (Without Outlier)');

%create bounding box

boxPolygon = [1166, 1000;...                           % top-left
        4166, 1000;...                 % top-right
        4166, 2300;... % bottom-right
        1166, 2300;...                 % bottom-left
        1166, 1000];  
newBoxPolygon = transformPointsForward(tform, boxPolygon);
figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected mint stem');