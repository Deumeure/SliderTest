//
//  PDFPageView.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFPageView : UIScrollView 
{
	UIImageView* mImageView;

    bool mDoublePage;
    CGRect mBorders;
    
    uint mIndex1;
    uint mIndex2;

}

-(id)initWithPageIndex:(uint)pIndex;
-(id)initWithDoublePageIndex:(uint)pIndex andIndex:(uint)pIndex2;

-(void)animateLinks;
-(void)loadLinks;

@property(nonatomic,retain)UIImage* image;
@property(nonatomic,assign)CGRect borders;

@end
