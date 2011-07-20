//
//  SliderDelegate.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderDelegate.h"


@implementation SliderDelegate


-(void)start
{
	mLoader = [[PDFLoader alloc]initWithPath:@"mobile.pdf"];
	
	[mLoader openPDF];
	
	mImageloader = [[PDFImageLoader alloc] init];
	mImageloader.delegate = self;
	[mImageloader start];
}

-(void)dealloc
{
	[mLoader release];
	[mImageloader release];
	
	[super dealloc];
}

-(CGSize)sliderViewController:(SliderViewController*)pController sizeForOrientation:(uint)pOrientation
{
	return CGSizeMake(768, 1024);
}

-(void)sliderViewController:(SliderViewController*)pController cachePageAtIndex:(uint)pPageIndex
{
	mSliderController =pController;
	
	
	PDFPage* lPage = [mLoader pageAtIndex:pPageIndex];
	
	
	[mImageloader loadImageForPage:lPage outRect:CGRectMake(0, 0, 384, 512)];
}

-(void)sliderViewController:(SliderViewController*)pController renderPageAtIndex:(uint)pPageIndex
{

//	[pController setImage:lImage forIndex:pPageIndex];
	
	
	mSliderController =pController;
	
	
	PDFPage* lPage = [mLoader pageAtIndex:pPageIndex];

	
	[mImageloader loadImageForPage:lPage outRect:CGRectMake(0, 0, 768, 1024)];
	
}


-(void)pdfImageLoader:(PDFImageLoader*)pLoader image:(UIImage*)pImage fromPage:(PDFPage*)pPage
{
	[mSliderController setImage:pImage forIndex:pPage.pageIndex];
}

@end
