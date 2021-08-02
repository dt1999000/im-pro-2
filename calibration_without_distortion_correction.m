%load the image and separate the red green blue value
clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.

img= imread('Pflanze 3.jpg'); 



%------------------------shadow detection and removal----------------------

%using median filter
r = medfilt2(double(img(:,:,1)), [3,3]); 
g = medfilt2(double(img(:,:,2)), [3,3]);
b = medfilt2(double(img(:,:,3)), [3,3]);

%calculate shadow ratio
shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
figure, imshow(shadow_ratio, []); colormap(jet); colorbar;

%thresholding
shadow_mask = shadow_ratio<-0.25; % threshhold value
figure, imshow(shadow_mask, []), title('shadow binary mask'); 
shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;
non_shadow_mask = ~shadow_mask;

%calculate the difference in the mean pixels value between the shadow area 
%and every where else
shadow_image = bsxfun(@times, img, cast(shadow_mask, 'like', img));
non_shadow_image = bsxfun(@times, img, cast(non_shadow_mask, 'like', img));

shadow_image_hsv = rgb2hsv(shadow_image);
non_shadow_image_hsv = rgb2hsv(non_shadow_image);

mean_shadow = sum(shadow_image_hsv(:,:,3),'all')/sum(shadow_mask(:));
mean_non_shadow = sum(non_shadow_image_hsv(:,:,3),'all')/sum(non_shadow_mask(:));
mean_color = (sum(non_shadow_image,'all')/(3*sum(non_shadow_mask(:)))-sum(shadow_image,'all')/(3*sum(shadow_mask(:))))/255;

%perform shadow compensation

%compensate with multiple of white light
img_hsv = rgb2hsv(img);
img = im2double(img);
img(:,:,1) = img(:,:,1) + (mean_color.*shadow_mask);
img(:,:,2) = img(:,:,2) + (mean_color.*shadow_mask);
img(:,:,3) = img(:,:,3) + (mean_color.*shadow_mask);
figure, imshow(img), title('shadow removal with multiple of white light');

%compensate with hue value
img_hsv(:,:,3) = img_hsv(:,:,3) + ((mean_non_shadow-mean_shadow).*shadow_mask);
img_rgb = hsv2rgb(img_hsv);
figure, imshow(img_rgb), title('shadow removal with V value in hsv color space');




%--------------------------------------calibration-------------------------
%load the image and separate the red green blue value


imagePoints = [598 521; 5170 533; 5208 2856; 515 2794; 598 521];
imageX = imagePoints(:,1);
imageY = imagePoints(:,2);
%calculate the factor that specify the correlation between value of pixel
%and their area in the world scale = area/number of pixels


scale = 1; %when set to 1, the number of pixel will be calculate
%scale = (29.2*59.3)/ polyarea(imageX,imageY);




%-----------------------------segmentation and calculate-------------------
%segmentation with green percentage thresholding


%area is calculated in mm2

%segmentation with hue value thresholding in color space


areaCircle = calAreaSeg(img,140,155,0.2,10000)* scale %when scale is set to 1 the number of pixel will be calculated
areaPflanze = calAreaSeg(img, 50,85, 0.1, 400000) * 50.25/ areaCircle
