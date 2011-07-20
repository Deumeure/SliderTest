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

-(PDFPage*)pageAtIndex:(uint)pPageIndex
{
	CGPDFPageRef page = CGPDFDocumentGetPage(mPDF, pPageIndex );
	
	//[(id)page autorelease];
	return [[[PDFPage alloc]initWithPDFPage:page pageIndex:pPageIndex] autorelease];
}

-(PDFPage*)doublePageAtIndex:(uint)pPageIndex
{
	return nil;
}


-(uint)pageCount
{
	return CGPDFDocumentGetNumberOfPages(mPDF);	
}

@dynamic pageCount;
@end
