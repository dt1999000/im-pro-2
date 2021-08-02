clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.


%-------------using segmentation to optimize ROI---------------------------

I = imread('Pflanze 2.jpg');
hsv = rgb2hsv(I);
hue = 360*hsv(:,:,1);
binaryMask = (hue > 70 & hue <85);
binaryMask = imclearborder(binaryMask,4);% clear border
binaryMask = bwareaopen(binaryMask,30000); %remove blobs
binaryMask = imfill(binaryMask,'holes');
figure; imshow(binaryMask);


ImGray = im2double(rgb2gray(I));
ImGray = ImGray.*binaryMask;
figure; imshow(ImGray);


%--------------feature detection-------------------------------------------
FASTcorners = detectFASTFeatures(ImGray);
SURFcorners = detectSURFFeatures(ImGray,'ROI',[1166,1000,3000,1300]);
HARRIScorners = detectHarrisFeatures(ImGray);
BRISKcorners = detectBRISKFeatures(ImGray);
figure, imshow(I); hold on;
plot(SURFcorners);

[features, validPoints] = extractFeatures(ImGray, SURFcorners);
location = SURFcorners.Location;

%------splitting the points into top and bottom points and interpolate-----

x = location(:,1);
y = location(:,2);
[max, max_index] = max(x);
[min, min_index] = min(x);


topLocation = location(min_index(1),:); 
bottomLocation = location(max_index(1),:); 


if bottomLocation(2)>topLocation(2)
    leftPointsLogical = location(:,2) > bottomLocation(2);
    leftPointsLocation = cat(2,x(leftPointsLogical),y(leftPointsLogical));
    rightPointsLogical = location(:,2) < topLocation(2);
    rightPointsLocation = cat(2,x(rightPointsLogical),y(rightPointsLogical));
else 
    leftPointsLogical = location(:,2) > topLocation(2);
    leftPointsLocation = cat(2,x(leftPointsLogical),y(leftPointsLogical));
    rightPointsLogical = location(:,2) < bottomLocation(2);
    rightPointsLocation = cat(2,x(rightPointsLogical),y(rightPointsLogical));
end

xTop = rightPointsLocation(:,1);
yTop = rightPointsLocation(:,2);

figure, imshow(I); hold on;
plot(topLocation(1), topLocation(2),'r*');

option = fitoptions('Method','NearestInterpolant');
curve = fit(xTop,yTop,'linearinterp',option);
figure, imshow(I); hold on;
plot(curve);

%--------image windowing around interesting points and img histogram-------
windowSize = 200;
windowTop = I((topLocation(2)-windowSize):(topLocation(2)+windowSize),(topLocation(1)-windowSize):(topLocation(1)+ windowSize),:);
figure, imshow(windowTop);
[rTop,gTop,bTop] = imsplit(windowTop);
gray = rgb2gray(windowTop);
[hue,saturation,value] = rgb2hsv(windowTop);
hue = hue*360;
saturation = saturation *100;
value = value *100;

figure;
subplot(2,2,1),histRedTop = histogram(rTop),title('red');

subplot(2,2,2),histGreenTop = histogram(gTop),title('blue');
subplot(2,2,3),histBlueTop = histogram(bTop),title('green');

figure;
subplot(2,2,1), surf(rTop);
subplot(2,2,3), surf(bTop);
subplot(2,2,2), surf(gTop);
subplot(2,2,4), surf(gray);

figure;
subplot(2,2,1), surf(hue);
subplot(2,2,2), surf(saturation);
subplot(2,2,3), surf(value);

%---------------print out the location matrix to work with scipy----------- 
writematrix(location);
type 'location.txt';


%---------------k-means clustering-----------------------------------------
[index, clusterCentroid] = kmeans(location,9);

figure, imshow(I);
hold on;
gscatter(location(:,1),location(:,2),index, 'rgbwkymcr');
hold on;
plot(clusterCentroid(:,1), clusterCentroid(:,2), 'kx');
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6','Cluster 7','Cluster 8','Cluster 9','Cluster Centroid')
writematrix(clusterCentroid);
type 'clusterCentroid.txt';