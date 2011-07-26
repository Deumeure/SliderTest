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
-(void)initialize;
@end

@implementation PDFPageView


-(id)initWithPageIndex:(uint)pIndex
{
    self = [super init];
    if (self) 
    {
        mDoublePage = NO;
        mIndex1 =pIndex;
        
          
        [self initialize];

        
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
        

        [self initialize];
        
        NSLog(@"rtyuiokmljkhgcxgnfc,hjkl546789087654324567890°98765434567890°9876543");
    }
    return self;

}

-(void)initialize
{
    
    
    self.canCancelContentTouches = YES;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 2;
    self.delegate = self;
    
    
    mImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backgroundColor = [UIColor yellowColor];
    mImageView.backgroundColor = [UIColor greenColor];
    mImageView.userInteractionEnabled = YES;
    [self addSubview:mImageView];
    
	mLoadingIndicator  =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	mLoadingIndicator.hidesWhenStopped = YES;
	
  
    [mImageView addSubview:mLoadingIndicator];
	[mLoadingIndicator startAnimating];
   
    

    UILongPressGestureRecognizer* lTapGesture = [[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)] autorelease];
    
    //    lTapGesture.numberOfTouchesRequired = 1;
    //    lTapGesture.numberOfTapsRequired=1;
    //    lTapGesture.minimumPressDuration = 1.0f;
    
    [mImageView addGestureRecognizer:lTapGesture];
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)sender 
{    
 
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
       CGPoint lPoint =  [sender locationInView:self];
        for (UIView* lView in self.subviews)
        {
            if([lView class] != [LinkVIew class])
                continue;
            
            if(CGRectContainsPoint(lView.frame, lPoint))
            {
                LinkVIew* lLinkView = (LinkVIew*)lView;
                
                [lLinkView animate];
                [mDelegate pdfPageView:self linkDidSelectWithType:lLinkView.linkType andDatas:@""];
                return;
            }
        }
    

    }
    
}


- (void)dealloc 
{
	[mImageView release];
    [super dealloc];
}


-(void)pageDidShow
{
    if(mImageView.image)
        [self animateLinks];
    else
        mHasToAnimate = YES;
    
}


-(void)pageDidHide
{
    mHasToAnimate = NO;
}
#pragma mark-
#pragma UIScrollView delegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{

	if (scale == self.minimumZoomScale) 
        return;
    
    
    self.zoomScale = 1.0f;
    [mDelegate pdfPageView:self zoomDidBeginWithScale:scale];
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return mImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    
}

#pragma mark-
#pragma Maths functions

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


-(CGRect)rightPageFitRect:(CGRect) innerRect rect:(CGRect) outerRect
{
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation(outerRect.size.width  ,  0 );
	
	return CGRectApplyAffineTransform(scaledInnerRect,translation);
	
}


#pragma mark-
#pragma Link functions

-(void)loadLinks
{
    
    //On efface tout les anciens liens 
    for (UIView* lView in self.subviews)
    {
        if([lView class] != [LinkVIew class])
            continue;
        
        
        [lView removeFromSuperview];
    }
    
    if(mDoublePage)
    {
        
        //On cherche le rectangle de la page
        CGSize lOriginalSize = CGSizeMake(340, 581);
        
        CGRect lRect1 = CGRectMake(0, 0, mImageView.frame.size.width /2, mImageView.frame.size.height);
		CGRect lRect2 = CGRectMake(mImageView.frame.size.width /2, 0, mImageView.frame.size.width /2, mImageView.frame.size.height);
		
        
        //On s'occupe de la age de gauche
        
        
        CGRect lRightRect =  [self rightPageFitRect:CGRectMake(0, 0,lOriginalSize.width,lOriginalSize.height) rect:lRect2];
        CGRect lLeftRect = CGRectMake(lRightRect.origin.x-lRightRect.size.width, lRightRect.origin.y
                                      ,lRightRect.size.width,lRightRect.size.height);
        
        [self loadLinksOnPage:mIndex1 onRect:lRightRect];
        [self loadLinksOnPage:mIndex1 onRect:lLeftRect];
        
      
    }else
    {
        
        
        //On cherche le rectangle de la page
        CGSize lOriginalSize = CGSizeMake(340, 581);
        
        //Le rect aspectfit
        CGRect lNewRect = [self aspectFitRect:CGRectMake(0, 0,lOriginalSize.width,lOriginalSize.height) rect:mImageView.frame];
        
        CGRect lFinalRect = CGRectMake(mImageView.frame.size.width/2- lNewRect.size.width/2.0f, mImageView.frame.size.height/2- lNewRect.size.height/2.0f, mImageView.frame.size.width, mImageView.frame.size.height);
        
        [self loadLinksOnPage:mIndex1 onRect:lFinalRect];
        
    }
    
}


-(void)loadLinksOnPage:(uint)pIndex onRect:(CGRect)pFrame
{
    

    NSMutableDictionary* lArray = [NSMutableDictionary dictionary];
    
    
    [lArray setObject:[NSNumber numberWithInt:0] forKey:@"x"];
    [lArray setObject:[NSNumber numberWithInt:0]  forKey:@"y"];
    [lArray setObject:[NSNumber numberWithInt:340]  forKey:@"w"];
    [lArray setObject:[NSNumber numberWithInt:581]  forKey:@"h"];
    
    [lArray setObject:[NSNumber numberWithInt:2]  forKey:@"type"];
    [lArray setObject:[NSString stringWithFormat:@"monurl"] forKey:@"url"];
    [lArray setObject:[NSString stringWithFormat:@""] forKey:@"target"];
    
    
    //On trouve le ration pour
    CGSize lOriginalSize = CGSizeMake(340, 581);
    float lWidthScale = (pFrame.size.width/lOriginalSize.width);
    float lHeightScale = (pFrame.size.height/lOriginalSize.height);
    float lScale = MIN(lWidthScale,lHeightScale);
    

    CGFloat lXDecal = mImageView.frame.origin.x +pFrame.origin.x;
    CGFloat lYDecal =mImageView.frame.origin.x +pFrame.origin.y;
    
    NSArray* lLinks = [NSArray arrayWithObjects:lArray, nil];
    
 
    
    for (NSDictionary* lLink in lLinks) 
    {
        
        LinkVIew* lView= [[[LinkVIew alloc]initWithLinkInfos:nil] autorelease];
        
        CGRect lienRect = CGRectMake(([[lLink objectForKey:@"x"] intValue]*lScale) + (lXDecal),
                                     ([[lLink objectForKey:@"y"] intValue]*lScale) + (lYDecal),
                                     [[lLink objectForKey:@"w"] intValue]*lScale, 
                                     [[lLink objectForKey:@"h"] intValue]*lScale);
        
        lView.frame =lienRect;
    NSLog(@"lienRect  %@",NSStringFromCGRect(lienRect));
        [self addSubview:lView];
    }

}


-(void)animateLinks
{
    
        NSLog(@"HJKLJHKLBVHJKLM %d",mIndex1);
    
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
  
 
    [mLoadingIndicator stopAnimating];
    
	mImageView.image =pImage;
    
    //On charfe les liens
    [self loadLinks];
    
    
    //Si on doit animer
    if(mHasToAnimate)
        [self animateLinks];
    
    mHasToAnimate = NO;
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
    mLoadingIndicator.center = mImageView.center;
}

@dynamic image;
@synthesize borders = mBorders;
@synthesize pdfpagedelegate = mDelegate;

@end
