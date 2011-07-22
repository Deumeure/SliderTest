//
//  PDGFPageOperation.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageOperation.h"
#import "CachingTool.h"

@implementation PDFPageOperation



-(id)initWithPDFPage:(PDFPage*)pPage outRect:(CGRect)pRect
{
	
	self = [super init];
	
	if(self)
	{
		mPDFPage = [pPage retain];
		mOutRect = pRect;
		
		mImage =nil;
		
	}

	
	return self;
}


-(void)main
{
	
	
	if([self isCancelled])
		return;
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	
//	CachingTool* lCache =[CachingTool cachingToolWithIndex:mPDFPage.pageIndex]; 
//	
//	if([lCache isCached])
//	{
//	
//		NSLog(@"**************************   Image en Cache");
//		mImage =[[[lCache readCache] retain] autorelease];
//		
//	}else 
//	{
	
		NSTimeInterval lBeginTime = [NSDate timeIntervalSinceReferenceDate];
		
		mImage = [mPDFPage imageForRect:mOutRect];
		
		if(mImage == nil)
		{
		
			NSLog(@"NILLLLL");
		}
		
//		NSTimeInterval lEndTime = [NSDate timeIntervalSinceReferenceDate];
//		
//		
//		if(lEndTime - lBeginTime >1)
//		{
//			
//			NSLog(@"----------------Cache nécessaire %f",lEndTime - lBeginTime);
//			[lCache writeToCache:mImage];
//		}
		
		
		

		
//	}

	if(![self isCancelled])
		[self performSelectorOnMainThread:@selector(raiseDidFinishEvent:) withObject:nil  waitUntilDone:YES];
	else 
		mImage =nil;
	

	[pool release];
	

}


-(void)raiseDidFinishEvent:(NSMutableArray*)lArgs
{

	
	[mDelegate pdfFPageOperationDelegate:self image:mImage fromPage:mPDFPage];
	
}

-(void)dealloc
{

	
	[mPDFPage release];
	
	if(![self isCancelled])
		[mImage release];
	
	[super dealloc];
	
}

@synthesize delegate = mDelegate;
@synthesize pdfPage  = mPDFPage;
@end
