//
//  PDFPage.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPage.h"
#import "GraphicsUtils.h"


#define PAIR(X) (((X) % 2)==0)
@implementation PDFPage

-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex
{
	//TODO vier le retain
	mPDFPage = 	CGPDFPageRetain(pPage);
	mPageIndex = pPageIndex;

	mDoublePage =NO;
	mID = pPageIndex;
	
	return self;
}



-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex  PDFPage2:(CGPDFPageRef)pPage2 pageIndex2:(uint)pPageIndex2 pageID:(uint)pID
{	
	
	
	//La page 1 est toujours PAIR
	if(PAIR(pPageIndex))
	{
		mPageIndex= pPageIndex;
		mPDFPage = 	CGPDFPageRetain(pPage);

		
		mPageIndex2= pPageIndex2;
		mPDFPage2 = 	CGPDFPageRetain(pPage2);
		
	}else {
		mPageIndex2= pPageIndex;
		mPDFPage2 = 	CGPDFPageRetain(pPage);
		
		
		mPageIndex= pPageIndex2;
		mPDFPage = 	CGPDFPageRetain(pPage2);
	}

	mDoublePage = YES;
	mID = pID;
	return self;
}



//Renvoi la page valide en cas de solopage
#define soloPage (mPageIndex ==0 ? mPDFPage2 : mPDFPage)

//Renvoi l'index valide en cas de solopage
#define soloIndex (mPageIndex ==0 ? mPageIndex2	: mPageIndex)

-(CGSize)originaleSize
{
	CGSize lSize = CGSizeZero;
	
	if(!self.isSinglePage)
	{
		CGRect lRect  = CGPDFPageGetBoxRect(mPDFPage, kCGPDFCropBox);
		
		lSize = CGSizeMake(lRect.size.width*2, lRect.size.height*2);
		
	}else {
		
		CGRect lRect  = CGPDFPageGetBoxRect(soloPage, kCGPDFCropBox);
		
		lSize = CGSizeMake(lRect.size.width, lRect.size.height);
		
	}

	
		
	return lSize;
}


CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) {
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}

CGRect aspectFit2(CGRect innerRect, CGRect outerRect) {
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);

	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	
	return CGRectApplyAffineTransform(scaledInnerRect,translation);
	
}

-(UIImage*)imageForRect:(CGRect)pImageRect
{
	UIImage* lImage = nil;
	
		NSLog(@"pImageRect %@",NSStringFromCGRect(pImageRect));
	if(!self.isSinglePage)
	{
	
		//On fait les deux rect des pages
		CGRect lRect1 = CGRectMake(0, 0, pImageRect.size.width /2, pImageRect.size.height);
		CGRect lRect2 = CGRectMake(pImageRect.size.width /2, 0, pImageRect.size.width /2, pImageRect.size.height);
		
		
		
		//On créé le context
		CGSize cachePageSize = CGSizeMake(pImageRect.size.width, pImageRect.size.height);
		
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef ctx = CGBitmapContextCreate(NULL, 
												 cachePageSize.width, 
												 cachePageSize.height, 
												 8,						/* bits per component*/
												 cachePageSize.width * 4, 	/* bytes per row */
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast);
		CGColorSpaceRelease(colorSpace);



		
					CGContextSetRGBFillColor(ctx, 0, 255, 0, 1);
					CGContextFillRect(ctx, pImageRect);
		
		//On dessine la première page si elle existe
		if(mPageIndex != 0)
		{
		
			CGRect lPageRect = CGPDFPageGetBoxRect(mPDFPage, kCGPDFCropBox);
			
			lPageRect = CGRectIntegral(lPageRect);
			
			CGRect lAspectRect = aspectFit2(lPageRect, lRect1);
			lAspectRect = CGRectIntegral(lAspectRect);
			
			NSLog(@"lAspectRect %@",NSStringFromCGRect(lAspectRect));
			CGImageRef lImageRef = [self drawPage:mPDFPage onRect:CGRectMake(0,0, lAspectRect.size.width, lAspectRect.size.height)];
			CGContextDrawImage(ctx, CGRectMake(lRect1.size.width-lAspectRect.size.width, 0, lAspectRect.size.width, lAspectRect.size.height), lImageRef);
			CGImageRelease(lImageRef);
			
			
//			CGPDFPageRef lPage = mPDFPage;
//			
//			CGRect rect = CGPDFPageGetBoxRect(lPage, kCGPDFCropBox);
//			
//			rect = CGRectIntegral(rect);
//			
//			CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
//			CGContextFillRect(ctx, aspectFit2(rect, lRect1));
//			
//			CGAffineTransform transform = aspectFit(rect,lRect1);
//			
//			
//			CGContextConcatCTM(ctx, transform);
//			
//			CGContextDrawPDFPage(ctx, lPage);
//			
//			
//			CGContextConcatCTM(ctx, CGAffineTransformIdentity);
		}
		
		NSLog(@"mPageIndex2 %d",mPageIndex2);
		
		if(mPageIndex2 != 0)
		{
			
//			CGRect lPageRect = CGPDFPageGetBoxRect(mPDFPage2, kCGPDFCropBox);
//			
//			lPageRect = CGRectIntegral(lPageRect);
//			
//			CGRect lAspectRect = aspectFit2(lPageRect, lRect2);
//			lAspectRect = CGRectIntegral(lAspectRect);
//			
//			NSLog(@"lAspectRect %@",NSStringFromCGRect(lAspectRect));
//			CGImageRef lImageRef = [self drawPage:mPDFPage2 onRect:CGRectMake(0,0, lAspectRect.size.width, lAspectRect.size.height)];
//			CGContextDrawImage(ctx, CGRectMake(lRect2.size.width-lAspectRect.size.width, 0, lAspectRect.size.width, lAspectRect.size.height), lImageRef);
//			CGImageRelease(lImageRef);
//			
//			NSLog(@"HJKLM");
			
	//		CGImageRef lImageRef = [self drawPage:mPDFPage2 onRect:CGRectMake(0,0, lRect2.size.width, lRect2.size.height)];
//			CGContextDrawImage(ctx, lRect2, lImageRef);
//			CGImageRelease(lImageRef);
//			
			
//			CGPDFPageRef lPage = mPDFPage2;
//			
//			CGRect rect = CGPDFPageGetBoxRect(lPage, kCGPDFCropBox);
//			
//			rect = CGRectIntegral(rect);
//			
//			CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
//			CGContextFillRect(ctx, aspectFit2(lRect2, pImageRect));
//			
//			CGAffineTransform transform = aspectFit(rect,pImageRect);
//			
//			
//			//CGContextConcatCTM(ctx, transform);
//			
//			CGContextDrawPDFPage(ctx, lPage);
//			
//	CGContextDrawImage(<#CGContextRef c#>, <#CGRect rect#>, <#CGImageRef image#>)
//	
			
			
		}

		
		CGImageRef lImageRef = CGBitmapContextCreateImage(ctx);
		lImage = [UIImage imageWithCGImage:lImageRef] ;
		
		CGImageRelease(lImageRef);
		CGContextRelease(ctx);

		return lImage;
		
	}else {

		CGPDFPageRef lPage = soloPage;
//		
//		CGRect rect = CGPDFPageGetBoxRect(lPage, kCGPDFCropBox);
//		
//		rect = CGRectIntegral(rect);
//		
//		//CGContextRef ctx = [GraphicsUtils newRGBABitmapContextWithSize:CGSizeMake(pImageRect.size.width, pImageRect.size.height)];
//		
//		
//		
//		CGSize cachePageSize = CGSizeMake(pImageRect.size.width, pImageRect.size.height);
//		
//		
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//		CGContextRef ctx = CGBitmapContextCreate(NULL, 
//										cachePageSize.width, 
//										cachePageSize.height, 
//										8,						/* bits per component*/
//										cachePageSize.width * 4, 	/* bytes per row */
//										colorSpace, 
//										kCGImageAlphaPremultipliedLast);
//		CGColorSpaceRelease(colorSpace);
//
//	
//		
//		CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
//		CGContextFillRect(ctx, aspectFit2(rect, pImageRect));
//	
//		CGAffineTransform transform = aspectFit(rect,pImageRect);
//		
//		
//		CGContextConcatCTM(ctx, transform);
//		
//		CGContextDrawPDFPage(ctx, lPage);
//		
//		
//		CGImageRef lImageRef = CGBitmapContextCreateImage(ctx);
//		lImage = [UIImage imageWithCGImage:lImageRef] ;
//		
//		CGImageRelease(lImageRef);
//		CGContextRelease(ctx);

		CGImageRef lImageRef = [self drawPage:lPage onRect:pImageRect];
		lImage = [UIImage imageWithCGImage:lImageRef] ;
		CGImageRelease(lImageRef);
		
	}


		NSLog(@"lImage.retaincount ,%d",[lImage retainCount]);
	return lImage;
}



-(CGImageRef)drawPage:(CGPDFPageRef)pPage onRect:(CGRect)pRect
{
	
	
	CGRect rect = CGPDFPageGetBoxRect(pPage, kCGPDFCropBox);
	
	rect = CGRectIntegral(rect);
	
	//CGContextRef ctx = [GraphicsUtils newRGBABitmapContextWithSize:CGSizeMake(pImageRect.size.width, pImageRect.size.height)];
	
	
	
	CGSize cachePageSize = CGSizeMake(pRect.size.width, pRect.size.height);
	
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(NULL, 
											 cachePageSize.width, 
											 cachePageSize.height, 
											 8,						/* bits per component*/
											 cachePageSize.width * 4, 	/* bytes per row */
											 colorSpace, 
											 kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
	
	
	CGContextSetRGBFillColor(ctx, 0, 0, 255, 1);
	CGContextFillRect(ctx, pRect);
	
	
	CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
	CGContextFillRect(ctx, aspectFit2(rect, pRect));
	
	CGAffineTransform transform = aspectFit(rect,pRect);
	
//	CGAffineTransform transform = CGPDFPageGetDrawingTransform(pPage,
//																  kCGPDFCropBox,
//																  pRect,
//																  0, YES);
	
	
	CGContextConcatCTM(ctx, transform);
	
	CGContextDrawPDFPage(ctx, pPage);
	
	
	CGImageRef lImageRef = CGBitmapContextCreateImage(ctx);
	
	//CGImageRelease(lImageRef);
	CGContextRelease(ctx);
	
	return lImageRef;
}

-(void)dealloc
{
	
//	NSLog(@"mPDFPage retain count %d",CFGetRetainCount(mPDFPage));
	CGPDFPageRelease(mPDFPage);
	CGPDFPageRelease(mPDFPage2);
	
	[super dealloc];
}

#pragma mark -
#pragma mark Properties

-(uint)singlePageIndex
{
	return mPageIndex == 0 ? mPageIndex2 : mPageIndex; 
}

-(bool)isSinglePage
{
	return !mDoublePage;
}

@synthesize pageIndex = mPageIndex;
@synthesize pageIndex2 =  mPageIndex2;
@synthesize ID = mID;
@dynamic singlePageIndex;
@dynamic isSinglePage;
@end
