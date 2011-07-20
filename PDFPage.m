//
//  PDFPage.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPage.h"
#import "GraphicsUtils.h"

@implementation PDFPage

-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex
{
	mPDFPage = 	CGPDFPageRetain(pPage);
	mPageIndex = pPageIndex;

	return self;
}

-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex  PDFPage2:(CGPDFPageRef)pPage2 pageIndex2:(uint)pPageIndex2
{
	mPDFPage = 	CGPDFPageRetain(pPage);
	mPageIndex = pPageIndex;
	
	mPDFPage2 = 	CGPDFPageRetain(pPage2);
	mPageIndex2 = pPageIndex2;
	
	return self;
}

//Renvoi si oui ou on c'est une double page
#define isDoublePage (mPageIndex2 != 0 && mPageIndex != 0)

//Renvoi la page valide en cas de solopage
#define soloPage (mPageIndex ==0 ? mPDFPage2 : mPDFPage)

//Renvoi l'index valide en cas de solopage
#define soloIndex (mPageIndex ==0 ? mPageIndex2	: mPageIndex)

-(CGSize)originaleSize
{
	CGSize lSize = CGSizeZero;
	
	if(isDoublePage)
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


-(UIImage*)imageForRect:(CGRect)pImageRect
{
	UIImage* lImage = nil;
	
	if(isDoublePage)
	{
		
	}else {
//		
		CGPDFPageRef lPage = soloPage;
		
		CGRect rect = CGPDFPageGetBoxRect(lPage, kCGPDFCropBox);
		
		rect = CGRectIntegral(rect);
		
		CGContextRef ctx = [GraphicsUtils newRGBABitmapContextWithSize:CGSizeMake(pImageRect.size.width, pImageRect.size.height)];
		
		CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
		
		CGContextFillRect(ctx, pImageRect);
		

		CGAffineTransform transform = aspectFit(rect,pImageRect);
		
		CGContextConcatCTM(ctx, transform);
		
		CGContextDrawPDFPage(ctx, lPage);
		
		
		CGImageRef lImageRef = CGBitmapContextCreateImage(ctx);
		lImage = [UIImage imageWithCGImage:lImageRef] ;
		
		CGImageRelease(lImageRef);
		CGContextRelease(ctx);

//		CGPDFPageRef lPage = soloPage;
//		
//		CGSize cachePageSize = CGSizeMake(pImageRect.size.width, pImageRect.size.height);
//		
//		
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//		CGContextRef context = CGBitmapContextCreate(NULL, 
//													 cachePageSize.width, 
//													 cachePageSize.height, 
//													 8,						/* bits per component*/
//													 cachePageSize.width * 4, 	/* bytes per row */
//													 colorSpace, 
//													 kCGImageAlphaPremultipliedLast);
//		CGColorSpaceRelease(colorSpace);
//		
//		//
////		CGContextClipToRect(context, CGRectMake(0, 0, cachePageSize.width, cachePageSize.height));		
////		
//		CGContextDrawPDFPage(context, lPage);
////		
////
//		CGImageRef image = CGBitmapContextCreateImage(context);
//		CGContextRelease(context);
//		
//	lImage = [UIImage imageWithCGImage:image];
//		CGImageRelease(image);
//		
		
	}


		NSLog(@"lImage.retaincount ,%d",[lImage retainCount]);
	return lImage;
}

-(void)dealloc
{
	CGPDFPageRelease(mPDFPage);
	CGPDFPageRelease(mPDFPage2);
	
	[super dealloc];
}

@synthesize pageIndex = mPageIndex;
@synthesize pageIndex2 =  mPageIndex2;

@end
