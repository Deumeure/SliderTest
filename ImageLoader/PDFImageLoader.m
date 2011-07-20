//
//  ImageLoader.m
//  ImageLoader
//
//  Created by Mac5 on 09/08/10.
//  Copyright 2010 Anuman Interactive. All rights reserved.
//

#import "PDFImageLoader.h"


@interface PDFImageLoader (Private)

-(void)loadImageThreadFunc;



@end

@implementation PDFImageLoader

-(id)init
{
//	mLockObject=[[NSObject alloc]init];
//	self.isWorking=NO;
	return self;
}

//-(void)loadImageThreadFunc
//{
//	
//	NSAutoreleasePool* lPool =[[NSAutoreleasePool alloc]init];
//	
//	NSLog(@"Thread démarré");
//	
//	while (self.isWorking) 
//	{
//		
//		NSArray* lArgs =[mWorkingQueue pop];
//	
//		//On récupère les arguments
//		PDFPage* lPage =(PDFPage*)[lArgs objectAtIndex:0];
//		NSString* lKey =(NSString*)[lArgs objectAtIndex:1];
//		
//		CGRect lRect = CGRectFromString(lKey);
//		
//		UIImage* lImage = [lPage imageForRect:lRect];
//		
//		[self performSelectorOnMainThread:@selector(raiseImage:) withObject:[NSMutableArray arrayWithObjects:lPage,lImage,nil]  waitUntilDone:NO];
//	}
//	
//	[lPool release];
//}

-(void)raiseImage:(NSMutableArray*)lArgs
{
	
	UIImage* lImage =(UIImage*)[lArgs objectAtIndex:1];
	PDFPage* lPage =(PDFPage*)[lArgs objectAtIndex:0];
	
	//[lArgs removeAllObjects];
	
	
	[mDelegate pdfImageLoader:self image:lImage fromPage:lPage];
	
}

-(void)bakgroundLoad:(NSArray*)pArgs
{
	
	NSAutoreleasePool* lPool =[[NSAutoreleasePool alloc]init];
	
	

	//On récupère les arguments
		
	PDFPage* lPage =(PDFPage*)[pArgs objectAtIndex:0];
	NSString* lKey =(NSString*)[pArgs objectAtIndex:1];
		
	CGRect lRect = CGRectFromString(lKey);
		
	UIImage* lImage = [lPage imageForRect:lRect];
		
	[self performSelectorOnMainThread:@selector(raiseImage:) withObject:[NSMutableArray arrayWithObjects:lPage,lImage,nil]  waitUntilDone:NO];
	
	
	[lPool release];
}

//Demmarre l'imageLoader
-(void)start
{

//	//Protéger pour ne pas rentrer deux foi
//	@synchronized (mLockObject)
//	{
//		if(!self.isWorking)
//		{
//			mWorkingQueue = [[BlockingQueue alloc]init];
//			
//			self.isWorking=YES;
//			[NSThread detachNewThreadSelector:@selector(loadImageThreadFunc) toTarget:self withObject:nil];
//			
//		}
//	}
}

//Ajoute une image à la file d'attente
-(void)loadImageForPage:(PDFPage*)pPage outRect:(CGRect)pRect
{

		NSArray* lArray =[NSArray arrayWithObjects:pPage,NSStringFromCGRect(pRect),nil];
	
	
	[self performSelectorInBackground:@selector(bakgroundLoad:) withObject:lArray];
		//[mWorkingQueue push:lArray];

}


@synthesize isWorking = mIsWorking;
@synthesize delegate = mDelegate;

@end
