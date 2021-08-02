function [outputArg1,outputArg2] = areaCalSegRGB(img,threshold, blobpixels)
%calculate area and perform segmentation based on prozentual RGB value
%   perform segmentation and calculate area of segmented object
%   img: rgb-matrix of the image
%   threshold: prozentual threshold, green_percent > threshold
%   blobpixels: number of pixels to remove unrelevant small blob in the image for
%   correct and stable segmentation
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
black = zeros(size(img,1),size(img,2));
greenOnly = cat(3, black, green, black);
total = double(red)+double(green)+double(blue);
green_percent = double(green)./total;
imCircle = (green_percent >0.45);
imCircle = bwareaopen(imCircle, 100000);
figure; imshow(imCircle);
area = sum(imCircle(:))*scale
end

