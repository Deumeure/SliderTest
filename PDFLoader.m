//
//  PDFLoader.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFLoader.h"


@implementation PDFLoader





-(id)initWithPath:(NSString*)pPath
{
	mPath = [pPath retain];
	
	return self;
}

-(void)openPDF
{
	CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (CFStringRef)mPath , NULL, NULL);
	mPDF = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	CFRelease(pdfURL);
}

-(void)closePDF
{
	CGPDFDocumentRelease(mPDF);
}

-(void)dealloc
{
	[mPath release];
	[self closePDF];
	[super dealloc];
}

-(PDFPageRenderer*)pageAtIndex:(uint)pPageIndex
{
	CGPDFPageRef page = CGPDFDocumentGetPage(mPDF, pPageIndex );
	
	//[(id)page autorelease];
	return [[[PDFPageRenderer alloc]initWithPDFPage:page pageIndex:pPageIndex] autorelease];
}




-(PDFPageRenderer*)doublePageAtIndex:(uint)pPageIndex andIndex:(uint)pPageIndex2
{
	
//	uint lIndex1 = 0;
//	uint lIndex2 = 0;
//	
//	CGPDFPageRef lPage1;
//	CGPDFPageRef lPage2;
//	
//	if(pPageIndex == 0)
//	{
//		lIndex1 = 0;
//		lPage1 = nil;
//	}else {
//		lIndex1 =pPageIndex;
//		lPage1 = CGPDFDocumentGetPage(mPDF, lIndex1 );
//		
//	}
//	
//	
//	if(pPageIndex2 == 0)
//	{
//		lIndex2 = 0;
//		lPage2 = nil;
//	}else {
//		lIndex2 =pPageIndex;
//		lPage2 = CGPDFDocumentGetPage(mPDF, lIndex2 );
//		
//	}
//	
	

	CGPDFPageRef lPage1 = pPageIndex ==0 ? nil : CGPDFDocumentGetPage(mPDF, pPageIndex );
	CGPDFPageRef lPage2 = pPageIndex2 ==0 ? nil : CGPDFDocumentGetPage(mPDF, pPageIndex2 );
	
	
	
	
	return [[[PDFPageRenderer alloc]initWithPDFPage:lPage1 pageIndex:pPageIndex PDFPage2:lPage2 pageIndex2:pPageIndex2] autorelease];
}


-(uint)pageCount
{
	return CGPDFDocumentGetNumberOfPages(mPDF);	
}

@dynamic pageCount;
@end
