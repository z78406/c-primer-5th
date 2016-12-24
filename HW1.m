% I1 = imread('taj1.jpg');
% I2 = imread('taj2.jpg');
% cpselect(I2,I1);
% uiwait(msgbox('Click OK after closing the CPSELECT window.','Waiting...'))
% save('movingPoints.mat');
% save('fixedPoints.mat');
load('movingPoints.mat');
load('fixedPoints.mat');

H2to1 = computeH(fixedPoints,movingPoints);


warp_im = warpH(I2,H2to1,size(I2));
imshow(warp_im);
