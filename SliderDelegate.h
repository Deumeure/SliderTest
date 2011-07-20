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
#import "PDFPageOperation.h"
#import "SliderViewController.h"

@interface SliderDelegate : NSObject <SliderViewControllerDelegate,SliderViewControllerDataSource,PDFPageOperationDelegate>
{

	PDFLoader* mLoader;
	NSOperationQueue* mPageLoadingQueue;
	
	SliderViewController* mSliderController;
	

}

-(void)start;


@end
