//
//  main.cpp
//  disparityCal
//
//  Created by Zhenyu Zhou on 11/15/16.
//  Copyright © 2016 zzy. All rights reserved.



#include "_Header.h"
//#include "vpLane.h"
//#include "vp.h"

int main ()
{ //calculate the disparity of the input image
 Mat leftImg  = imread("/Users/Joe/Documents/MSRT/sensor project/opencv/pics/left/000000.png");
 Mat rightImg = imread("/Users/Joe/Documents/MSRT/sensor project/opencv/pics/right/000000.png");
 cvtColor(leftImg, leftImg, CV_BGR2GRAY);
 cvtColor(rightImg, rightImg, CV_BGR2GRAY);

 Mat D1;
 Mat D2;
 computeDisparity(leftImg, rightImg, D1, D2);
  //imshow("disparityl",D1);
  //imshow("disparityr",D2);
 
//detect features and match the points
    int minHessian = 300;
    SURF detector( minHessian );
    std::vector<KeyPoint> keypoints_1,keypoints_2;
    detector.detect( leftImg,keypoints_1);
    detector.detect( rightImg,keypoints_2);
    
    SURF extractor;
    Mat descriptors_1,descriptors_2;
    extractor.compute( leftImg,keypoints_1, descriptors_1 );
    extractor.compute( rightImg,keypoints_2, descriptors_2 );
    
    FlannBasedMatcher matcher;
    std::vector< DMatch > matches;
    matcher.match ( descriptors_1, descriptors_2, matches);
    double max_dist = 0; double min_dist = 100;
    
    for ( int i=0; i<descriptors_1.rows; i++)
    {double dist = matches[i].distance;
        if(dist < min_dist )min_dist= dist;
        if(dist > max_dist )max_dist= dist;
    }

        
    std::vector<DMatch> good_matches;
    for( int i =0; i <descriptors_1.rows; i++ )
    { if (matches[i].distance<2*min_dist)
    { good_matches.push_back( matches[i]); }
    }
     
    Mat img_matches;
    drawMatches(leftImg,keypoints_1,rightImg,keypoints_2,good_matches,img_matches,Scalar::all(-1),Scalar::all(-1),vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS);
    
    imshow("matches result",img_matches);
    
    

    waitKey(0);
    return 0;
}

