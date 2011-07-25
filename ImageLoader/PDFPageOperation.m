//
//  PDGFPageOperation.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageOperation.h"
#import "CachingTool.h"
#import "InvocationUtil.h"

@implementation PDFPageOperation



-(id)initWithPDFPage:(PDFPageRenderer*)pPage outRect:(CGRect)pRect
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
	
	
	CachingTool* lCache =[CachingTool cachingToolWithIndex:mPDFPage.pageIndex andTag:NSStringFromCGRect(mOutRect)]; 
	
	if([lCache isCached])
	{
	
		NSLog(@"**************************   Image en Cache");
		mImage =[[[lCache readCache] retain] autorelease];
		
	}else 
	{
	
		NSTimeInterval lBeginTime = [NSDate timeIntervalSinceReferenceDate];
		
		mImage = [mPDFPage imageForRect:mOutRect];
		
		if(mImage == nil)
		{
		
			NSLog(@"NILLLLL");
		}
		
		NSTimeInterval lEndTime = [NSDate timeIntervalSinceReferenceDate];
		
		
		if(lEndTime - lBeginTime >1)
		{
			
			NSLog(@"----------------Cache nécessaire %f",lEndTime - lBeginTime);
			[lCache writeToCache:mImage];
		}
		
		
		

		
	}

	[self performSelectorOnMainThread:@selector(raiseDidFinishEvent:) withObject:nil  waitUntilDone:YES];
	
	[pool release];
	

}


-(void)raiseDidFinishEvent:(NSMutableArray*)lArgs
{

	NSInvocation* lInvoke = createInvocation(mTarget,mSelector);
	
	invoke3(lInvoke,self,mImage,mPDFPage);
	
	//[mDelegate pdfFPageOperationDelegate:self image:mImage fromPage:mPDFPage];
	
}

-(void)dealloc
{

	[mPDFPage release];
	[mImage release];
	
	[super dealloc];
	
}

@synthesize target = mTarget;
@synthesize selector = mSelector;
@synthesize pdfPage  = mPDFPage;
@end
