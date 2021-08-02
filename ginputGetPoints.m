I = imread('Pflanze 3.jpg');
imshow(I);
[x,y] = ginput(15);
Pflanze3Nummer8 = cat(2,x,y);
writematrix(Pflanze3Nummer8);
clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.


