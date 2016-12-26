I1 = imread('taj1.jpg');
I2 = imread('taj2.jpg');
% cpselect(I2,I1);
% uiwait(msgbox('Click OK after closing the CPSELECT window.','Waiting...'))
% save('movingPoints.mat');
% save('fixedPoints.mat');

load('movingPoints.mat');
load('fixedPoints.mat');

H2to1 = computeH(fixedPoints,movingPoints);


warp_im = warpH(I2,H2to1,size(I1));
% imshow(warp_im);

% 2.4 find M and out_size

upper_leftP = (H2to1)*[1;1;1];
lower_leftP = (H2to1)*[1;1068;1];
upper_rightP = (H2to1)*[1608;1;1];
lower_rightP = (H2to1)*[1608;1068;1];
upper_leftP(1,1) = upper_leftP(1,1)/upper_leftP(3,1);
upper_leftP(2,1) = upper_leftP(2,1)/upper_leftP(3,1);
lower_leftP(1,1) = lower_leftP(1,1)/lower_leftP(3,1);
lower_leftP(2,1) = lower_leftP(2,1)/lower_leftP(3,1);
upper_rightP(1,1) = upper_rightP(1,1)/upper_rightP(3,1);
upper_rightP(2,1) = upper_rightP(2,1)/upper_rightP(3,1);
lower_rightP(1,1) = lower_rightP(1,1)/lower_rightP(3,1);
lower_rightP(2,1) = lower_rightP(2,1)/lower_rightP(3,1);

length = fix(lower_rightP(1,1));
width = fix(lower_rightP(2,1)-upper_rightP(2,1)+1)
scale_x = 1028/length;
scale_y = 1068/width;
Y = fix(abs(upper_rightP(2,1)))+1;
M = [scale_x 0 0;0 scale_y Y*scale_y;0 0 1];
warp_im1 = warpH(I1,M,[1068,1028]);
warp_im2 =warpH(I2,M*H2to1,[1068,1028]);
% imshow(warp_im2);
% imshow(warp_im1);

% 2.5 image blending
warp_compimg = warp_im1+warp_im2;

transI1up_leftP = M*[1;1;1];
transI1low_leftP= M*[1;1068;1];
transI1up_rightP= M*[1608;1;1];
transI2up_leftP = M*H2to1*[1;1;1];
transI2up_leftP = transI2up_leftP/transI2up_leftP(3,1);
transI2low_leftP= M*H2to1*[1;1068;1];
transI2low_leftP = transI2low_leftP/transI2low_leftP(3,1);
ind = find(warp_im2);
[ix,iy] = ind2sub([1068,1028],ind);
% rectArea =  warp_im2(294:950,217:544);
for i = 1:size(ix,1)
    if ix(i,1)>=294&&ix(i,1)<=950&&iy(i,1)>=217&&iy(i,1)<=544
        warp_compimg(ix(i,1),iy(i,1),1:3)=0;
        warp_compimg(ix(i,1),iy(i,1),1:3)=0.5*warp_im1(ix(i,1),iy(i,1),1:3)+0.5*warp_im2(ix(i,1),iy(i,1),1:3);
    end;
end;
imshow(warp_compimg);



