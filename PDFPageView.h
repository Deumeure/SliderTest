//
//  PDFPageView.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDFPageViewDelegate;

@interface PDFPageView : UIScrollView 
{
	UIImageView* mImageView;

    bool mDoublePage;
    CGRect mBorders;
    
    uint mIndex1;
    uint mIndex2;

    UIActivityIndicatorView* mLoadingIndicator;
    
    bool mHasToAnimate;
    
    id<PDFPageViewDelegate> mDelegate;
}

-(id)initWithPageIndex:(uint)pIndex;
-(id)initWithDoublePageIndex:(uint)pIndex andIndex:(uint)pIndex2;

-(void)animateLinks;
-(void)loadLinks;

-(void)pageDidShow;
-(void)pageDidHide;

@property(nonatomic,retain)UIImage* image;
@property(nonatomic,assign)CGRect borders;
@property(nonatomic,assign)id<PDFPageViewDelegate> delegate;
@end


@protocol PDFPageViewDelegate <NSObject>

-(void)pdfPageView:(PDFPageView*)pSender linkDidSelectWithType:(uint)pType andDatas:(NSString*)pLinkDatas;
-(void)pdfPageView:(PDFPageView*)pSender zoomDidBeginWithScale:(CGFloat)pScale;

@end
