%1. input 15 images
% I = imread('/Users/Joe/Documents/MSRT/cv_project/1118/testimg/1.pgm');
% figure,imshow(I);
% I1=imresize(I,[40,40]);
% figure,imshow(I1);
% 
img_path = dir('/Users/Joe/Documents/MSRT/cv_project/1118/testimg/*.pgm');
img_num = length(img_path);
a1 = cell(50,15);  
b1 = zeros(50,15);


for i =1:img_num
   filename = strcat('/Users/Joe/Documents/MSRT/cv_project/1118/testimg/',img_path(i).name);
   I = imread(filename);
   I1 = imresize(I,[40,40]);
  
% 2. get 50 submatrix of 5-by-5 for each image by using cell array
   for j = 1:50
       for k = 1:2
      
          
           
   subm = 5;
   [m,n] = size(I1);
   ind = randi((n-subm+1)*(m-subm+1));% obtain the number of ROI's upper left point randomly
   [ix,iy] = ind2sub([m-subm+1,n-subm+1],ind);%find its corresponding position in the matrix
   I2 = I1(ix:ix+subm-1,iy:iy+subm-1);%build 5-by-5 ROI matrix
   s = sum(I2);
   s1 = s';
   s2 = sum(s1);
   a1{j,i}(1,k) = s2; % get the sum of 5-by-5 matrix 
       end;
   a1{j,i}(1,1) = a1{j,i}(1,1)-a1{j,i}(1,2);% get the value vi as feature set
   b1(j,i) = a1{j,i}(1,1); % saved in a zero matrix
   end;
end;

% % 3. construct searching method
I3 = imread('/Users/Joe/Documents/MSRT/cv_project/1028/boat.bmp'); 
I7 = imread('/Users/Joe/Documents/MSRT/cv_project/1118/testimg/1.pgm');% put the detection pic in any area of the background pic
I3 = rgb2gray(I3);
[m,n] = size(I3);
[m1,n1] = size(I7);
it1 = randi([1,m-m1+1]);
it2 = randi([1,n-n1+1]);
I3(it1:it1+m1-1,it2:it2+n1-1) = I7(1:m1,1:n1);
imshow(I3);


I8 = I3; %I8 is used to draw the bounding box 
count = 0; %record the loop times
d=1;
a2 = cell(50,20000);
b2 = zeros(50,20000);
while (m>40&&n>40) 

   I4 = integralImage(I3); %get the integral image 
   I5 = I4(2:end,2:end);   %get rid of the first row and column which are all zero
   [m,n] = size(I5);       
   subm = 5;
   j = 1;
   
   for iy = 1:20:n-40+1
       for ix = 1:20:m-40+1
           
           for i=1:1:50
               for k=1:2
               ixm = ix+40-1;
               iym = iy+40-1;   
               ix1 = randi([ix,ixm-subm+1]);
               iy1 = randi([iy,iym-subm+1]);
               I6  = I5(ix1:ix1+subm-1,iy1:iy1+subm-1);
               a2{i,j}(1,k) = I6(5,5)-I6(5,1)-I6(1,5)+I6(1,1);%get the sum valuse for each one pair of ROI 
           
           
               end;
               a2{i,j}(1,1) = a2{i,j}(1,1)-a2{i,j}(1,2);     
               b2(i,j) = a2{i,j}(1,1);                        %get the vi feature set,waiting for comparision
           end;
           j = j+d;  
           
           
       end;
   end;
   
   %compute a2 with a1 to get the distance value
   c1 = b1';
   c2 = b2(1:50,1:j-1)';    
   c3 = (pdist2(c1,c2));    %pdist2 is used to get the distance between any two vectors
   c4 = fix(mean(c3));        
   ind= (find(c4<10300));    %set the threshould;
   [iy1,ix1] = ind2sub([(ix-1)/20+1,(iy-1)/20+1],ind);
   rectx = (ix1-1)*20+1;
   recty = (iy1-1)*20+1;     %get the position(rectx,recty) of matched ROI area
   u = size(rectx,2);
   
   for i = 1:u
   I8(fix(rectx(i)*1.2^count),fix(recty(i)*1.2^count):fix(recty(i)*1.2^count+40*1.2^count-1))=0;
   I8(fix(rectx(i)*1.2^count):fix(rectx(i)*1.2^count+40*1.2^count-1),fix(recty(i)*1.2^count))=0;
   I8(fix(rectx(i)*1.2^count+40*1.2^count-1),fix(recty(i)*1.2^count):fix(recty(i)*1.2^count+40*1.2^count-1))=0;
   I8(fix(rectx(i)*1.2^count):fix(rectx(i)*1.2^count+40*1.2^count-1),fix(recty(i)*1.2^count+40*1.2^count-1))=0;
   end;

   
         
   m = fix(m/1.2);
   n = fix(n/1.2);
   I3 = imresize(I3,[m,n]);
   count = count+1;
end;
imshow(I8);

  

    



   



 
