//
//  SliderDelegate.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SliderViewController.h"
#import "PDFLoader.h"
#import "PDFImageLoader.h"
#import "SliderViewController.h"

@interface SliderDelegate : NSObject <SliderViewControllerDelegate,SliderViewControllerDataSource,PDFImageLoaderDelegate>
{

	PDFLoader* mLoader;
	PDFImageLoader* mImageloader;
	
	SliderViewController* mSliderController;
	

}

-(void)start;


@end
