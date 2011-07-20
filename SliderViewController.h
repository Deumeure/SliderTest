//
//  SliderViewController.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderViewControllerDataSource;
@protocol SliderViewControllerDelegate;

@interface SliderViewController : UIViewController
{
	@private
	
	UIScrollView* mScrollView;
	
	uint mPageCount;
	
	
	uint mCurrentPage;
	
	id<SliderViewControllerDataSource> mDataSource;
	id<SliderViewControllerDelegate> mDelegate;
	
	
	NSObject* mLockObject;
}

-(id)initWithPageCount:(uint)pPageCount;
-(void)gotoPage:(uint)pPageIndex;

-(void)setImage:(UIImage*)lImage forIndex:(uint)Index;

@property(nonatomic,assign)id<SliderViewControllerDataSource> dataSource;
@property(nonatomic,assign)id<SliderViewControllerDelegate> delegate;

@property(nonatomic,assign)uint pageCount;
@property(nonatomic,assign)uint currentPage;
@end


@protocol SliderViewControllerDataSource

-(CGSize)sliderViewController:(SliderViewController*)pController sizeForOrientation:(uint)pOrientation;
-(void)sliderViewController:(SliderViewController*)pController cachePageAtIndex:(uint)pPageIndex;
-(void)sliderViewController:(SliderViewController*)pController renderPageAtIndex:(uint)pPageIndex;;

@end


@protocol SliderViewControllerDelegate

-(void)sliderViewControllerMoveToLeft:(SliderViewController*)pController;
-(void)sliderViewControllerMoveToRight:(SliderViewController*)pController;

-(void)sliderViewController:(SliderViewController*)pController pageChanged:(uint)pPageIndex;


@end