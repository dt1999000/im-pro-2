I = imread('Pflanze 4.jpg');
imshow(I);
[x,y] = ginput(30);
Pflanze4Nummer3 = cat(2,x,y);
writematrix(Pflanze4Nummer3);
clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.


