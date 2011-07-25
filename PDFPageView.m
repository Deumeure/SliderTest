//
//  PDFPageView.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageView.h"
#import "LinkVIew.h"

@interface PDFPageView (Private) 

-(void)loadLinksOnPage:(uint)pIndex onRect:(CGRect)pFrame;

@end

@implementation PDFPageView


-(id)initWithPageIndex:(uint)pIndex
{
    self = [super init];
    if (self) 
    {
        mDoublePage = NO;
        mIndex1 =pIndex;
        
        
        mImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    
        self.backgroundColor = [UIColor yellowColor];
        mImageView.backgroundColor = [UIColor greenColor];
        
        [self addSubview:mImageView];
    }
    
    return self;
    
}



-(id)initWithDoublePageIndex:(uint)pIndex andIndex:(uint)pIndex2
{
    self = [super init];
    if (self) 
    {
        mDoublePage = YES;
  
        mIndex1 = pIndex;
        mIndex2 = pIndex2;
        
        mImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:mImageView];
    }
    return self;

}


- (void)dealloc 
{
	[mImageView release];
    [super dealloc];
}







-(CGRect) aspectFitRect:(CGRect)innerRect rect:(CGRect) outerRect
{
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
    
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	
	return CGRectApplyAffineTransform(scaledInnerRect,translation);
	
}


-(void)loadLinks
{
    
    for (UIView* lView in self.subviews)
    {
        if([lView class] != [LinkVIew class])
            continue;
        
        
        [lView removeFromSuperview];
    }
    
    if(mDoublePage)
    {
        
    }else
    {
        
        
        //On cherche le rectangle de la page
        CGSize lOriginalSize = CGSizeMake(500, 500);
        
        //Le rect aspectfit
        CGRect lNewRect = [self aspectFitRect:CGRectMake(0, 0,lOriginalSize.width,lOriginalSize.height) rect:mImageView.frame];
        
        CGRect lFinalRect = CGRectMake(mImageView.frame.size.width- lNewRect.size.width/2.0f, mImageView.frame.size.height- lNewRect.size.height/2.0f, mImageView.frame.size.width, mImageView.frame.size.height);
        
        [self loadLinksOnPage:mIndex1 onRect:lFinalRect];
        
    }
    
}


-(void)loadLinksOnPage:(uint)pIndex onRect:(CGRect)pFrame
{
    
    NSMutableDictionary* lArray = [NSMutableDictionary array];
    
    
    [lArray setObject:[NSNumber numberWithInt:20] forKey:@"x"];
    [lArray setObject:[NSNumber numberWithInt:20]  forKey:@"y"];
    [lArray setObject:[NSNumber numberWithInt:100]  forKey:@"w"];
    [lArray setObject:[NSNumber numberWithInt:100]  forKey:@"h"];
    
    [lArray setObject:[NSNumber numberWithInt:2]  forKey:@"type"];
    [lArray setObject:[NSString stringWithFormat:@"monurl"] forKey:@"url"];
    [lArray setObject:[NSString stringWithFormat:@""] forKey:@"target"];
    
    //On trouve le ration pour
    float lWidthScale = (mImageView.frame.size.width/pFrame.size.width);
    float lHeightScale = (mImageView.frame.size.height/pFrame.size.height);
    float lScale = MIN(lWidthScale,lHeightScale);
    
    CGFloat lXDecal = mImageView.frame.origin.x;
    CGFloat lYDecal = mImageView.frame.origin.y;
    
    NSArray* lLinks = [NSArray arrayWithObjects:lArray, nil];
    
    
    for (NSDictionary* lLink in lLinks) 
    {
        
        LinkVIew* lView= [[LinkVIew alloc]initWithLinkInfos:nil];
        
        CGRect lienRect = CGRectMake(([[lLink objectForKey:@"x"] intValue]*lScale) + (lXDecal),
                                     ([[lLink objectForKey:@"y"] intValue]*lScale) + (lYDecal),
                                     [[lLink objectForKey:@"w"] intValue]*lScale, 
                                     [[lLink objectForKey:@"h"] intValue]*lScale);
        
        lView.frame =lienRect;
 
        [self addSubview:lView];
    }

}


-(void)animateLinks
{
    
    //Pas d'image = pas d'animation
    if(mImageView.image == nil)
        return;
    
    
    for (UIView* lView in self.subviews)
    {
        if([lView class] != [LinkVIew class])
            continue;
        
        LinkVIew* lLinkView = (LinkVIew*)lView;
        
        [lLinkView animate];
    }
}

#pragma mark -
#pragma mark Properties

-(void)setImage:(UIImage*)pImage
{
    NSLog(@"GFHJKLMGHJKL----_______++++%%¨¨¨****************");  
	mImageView.image =pImage;
    
}

-(UIImage*)image
{
	return mImageView.image;
}

-(void)setBorders:(CGRect)pBorders
{
    mBorders = pBorders;
    CGRect lImageRect = CGRectMake(mBorders.origin.x,mBorders.origin.y , self.bounds.size.width - (mBorders.origin.x+mBorders.size.width), self .bounds.size.height - (mBorders.origin.y+mBorders.size.height));
    
    mImageView.frame =lImageRect;
}

@dynamic image;
@synthesize borders = mBorders;

@end
