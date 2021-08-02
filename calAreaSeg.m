function [area] = calAreaSeg(img,lowerhuethreshold, upperhuethreshold, satthreshold, blobpixels)
%calculate area
%   perform segmentation and calculate area of segmented object
%   img: rgb-matrix of the image
%   lowerhuethreshold, upperhuethreshold: Segmentation is performed by
%   segmenting the image with hue value satisfying
%   lowerhuethreshold < hue value < upperhuethreshold
%   satthreshold: saturation threshold, satvalue must > satthreshold
%   blobpixels: number of pixels to remove unrelevant small blob in the image for
%   correct and stable segmentation

hsv = rgb2hsv(img);
figure; imshow(hsv);
hue = 360*hsv(:,:,1);
saturation = hsv(:,:,2);
v = hsv(:,:,3);
imSeg = (hue >lowerhuethreshold & hue<upperhuethreshold & saturation > satthreshold );
imSeg = medfilt2(imSeg);
imSeg = imclearborder(imSeg,4);
imSeg = bwareaopen(imSeg, blobpixels);
imSeg = imfill(imSeg, 'holes');
figure; imshow(imSeg);

area = bwarea(imSeg);

end

