#ifndef MAIN_H
#define MAIN_H

#include "_Header.h"
#include "vpLane.h"
#include "vp.h"

const string inputPath = "/Users/Joe/Documents/MSRT/sensor project/opencv/pics";
const string outputPath = "/Users/Joe/Documents/MSRT/sensor project/opencv/pics";



int main()
{

	int Height = 188;
	int Width = 620;

	for (int id = 0; id <4540; id++)
	{

		Mat colorImgL, colorImgR, GrayImg, DispImg, Result, Mask, EdgeImg, CostVal, Dir;
		DispImg.create(Height, Width, CV_8UC1);
		Mask.create(Height, Width, CV_8UC1);
		Result.create(Height, Width, CV_8UC3);
		//EdgeImg.create(Height, Width, CV_8UC1);
		CostVal.create(Height, Width, CV_8UC1);
		Dir.create(Height, Width, CV_8UC1);
		int hl;
		//int *vp = new int[2];
		int vp[2] = { 94, 318 };
		//vp[0] = 120;
		//vp[1] = 240;
		int leftp[2] = { Height - 3, 178 }; //initialization
		int rightp[2] = { Height - 3, 432 };


		string str1;
		stringstream ss;//可从string ss读写数据
		ss << id;
		if (id < 10)
			str1 = "00000";
		else if (id < 100)
			str1 = "0000";
		else if (id< 1000)
			str1 = "000";
		else if (id < 10000)
			str1 = "00";
		colorImgL = imread(inputPath + "pics/left" + str1 + ss.str() + ".png");//***
		resize(colorImgL, colorImgL, Size(Width, Height));
		colorImgR = imread(inputPath + "pics/right" + str1 + ss.str() + ".png");//***
		resize(colorImgR, colorImgR, Size(Width, Height));


		Vec4i line;
		hl = DispWay(colorImgL, colorImgR, outputPath, id, line, Result, DispImg, Mask);
		vp = findVP(colorImgL, Result, Mask, hl, state, EdgeImg, outputPath, id);//*****
		cvtColor(colorImgL, GrayImg, CV_BGR2GRAY);//颜色转变


		// get edge
		//Canny(GrayImg, EdgeImg, 50, 100);
		getNonHorizontalCannyEdge(GrayImg, EdgeImg, 80, 160);
		imwrite(outputPath + ss.str() + "_EdgeImg.png", EdgeImg);
		// get light road markers 
		float markerWidthThr = (float)Width / 40;
		Mat roadMarker = detectLightRoadMarker(GrayImg, (int)markerWidthThr);
		imwrite(outputPath + ss.str() + "_roadMarker.png", roadMarker);
		//imshow("EdgeImg", EdgeImg);
		//imwrite(outputPath + ss.str() + "_Edge.png", EdgeImg);

		EdgeImg = EdgeImg+roadMarker;
		//findvp(GrayImg, colorImgL, EdgeImg, 18, vp, outputPath, hl, id);
		findVp_via_roadMask(colorImgL, DispImg, Mask, vp, outputPath, hl, id);




		Mat PtrX = Mat::zeros(Height, Width, CV_8SC1);
		Mat PtrY = Mat::zeros(Height, Width, CV_8SC1);
		DetLane(colorImgL, EdgeImg, DispImg, Mask, line, vp, leftp, rightp, PtrX, PtrY, outputPath, id);

		waitKey(1);
	}
	return 0;
}


#endif