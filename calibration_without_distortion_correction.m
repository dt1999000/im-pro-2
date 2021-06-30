%load the image and separate the red green blue value
clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.

img= imread('DSC_0237.jpg'); 




%------------------------shadow detection and removal----------------------

%using median filter
r = medfilt2(double(img(:,:,1)), [3,3]); 
g = medfilt2(double(img(:,:,2)), [3,3]);
b = medfilt2(double(img(:,:,3)), [3,3]);

%calculate shadow ratio
shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
figure, imshow(shadow_ratio, []); colormap(jet); colorbar;

%thresholding
shadow_mask = shadow_ratio<-0.25;
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
img_rgb = im2double(img);
img_rgb(:,:,1) = img_rgb(:,:,1) + (mean_color.*shadow_mask);
img_rgb(:,:,2) = img_rgb(:,:,2) + (mean_color.*shadow_mask);
img_rgb(:,:,3) = img_rgb(:,:,3) + (mean_color.*shadow_mask);
figure, imshow(img_rgb), title('shadow removal with multiple of white light');

%compensate with hue value
img_hsv(:,:,3) = img_hsv(:,:,3) + ((mean_non_shadow-mean_shadow).*shadow_mask);
img = hsv2rgb(img_hsv);
figure, imshow(img), title('shadow removal with hue value');




%--------------------------------------calibration-------------------------
%load the image and separate the red green blue value

red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
black = zeros(size(img,1),size(img,2));
imagePoints = [598 521; 5170 533; 5208 2856; 515 2794; 598 521];
imageX = imagePoints(:,1);
imageY = imagePoints(:,2);
%calculate the factor that specify the correlation between value of pixel
%and their area in the world scale = area/number of pixels

scale = (29.2*59.3)/ polyarea(imageX,imageY);




%-----------------------------segmentation and calculate-------------------
%segmentation with green percentage thresholding

greenOnly = cat(3, black, green, black);
total = double(red)+double(green)+double(blue);
green_percent = double(green)./total;
imCircle = (green_percent >0.45);
imCircle = bwareaopen(imCircle, 100000);
figure; imshow(imCircle);
area = sum(imCircle(:))*scale

%area is calculated in mm2

%segmentation with hue value thresholding in color space

hsv = rgb2hsv(img);
figure; imshow(hsv);
hue = 360*hsv(:,:,1);
saturation = hsv(:,:,2);
v = hsv(:,:,3);
imCircle2 = (hue >105 & hue<140 );
imCircle2 = medfilt2(imCircle2);
imCircle2 = bwareaopen(imCircle2, 1000);
figure; imshow(imCircle2);

area2 = sum(imCircle2(:)) * scale;