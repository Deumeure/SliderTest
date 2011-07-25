//
//  SliderDelegate.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderDelegate.h"


@implementation SliderDelegate

#define MAX_OPERATION 2

-(void)start
{
	mLoader = [[PDFLoader alloc]initWithPath:@"mobile.pdf"];
	
	[mLoader openPDF];
	
	mPageLoadingQueue = [[NSOperationQueue alloc] init];
	[mPageLoadingQueue setMaxConcurrentOperationCount:3];
	
}

-(void)dealloc
{
	[mLoader release];
	[mPageLoadingQueue release];
	
	[super dealloc];
}

-(CGSize)sliderViewController:(SliderViewController*)pController sizeForOrientation:(uint)pOrientation
{
	return CGSizeMake(768, 1024);
}

-(NSDictionary*)sliderViewController:(SliderViewController*)pController loadLinkInfoForPageAtIndex:(uint)pPageIndex
{
    
}

-(NSDictionary*)sliderViewController:(SliderViewController*)pController loadLinkInfoForDoublePageAtIndex:(uint)pPageIndex
{
    
    
}


-(void)sliderViewController:(SliderViewController*)pController renderDoublePageAtIndex:(uint)pPageIndex andIndex:(uint)pPageIndex2 size:(CGSize)pSize
{
	mSliderController =pController;
	
	
	
	NSLog(@"CACHE PAGE");
	PDFPageRenderer* lPage = [mLoader doublePageAtIndex:pPageIndex andIndex:pPageIndex2];
	
	bool lCancel =[self findAndRemoveSameOperation:pController.currentPage page:lPage];
	
	if(lCancel)
	{
		NSLog(@"l'opératipon est déja en cours , je ne fais rien");
		return;
		
	}
	
	//Le rectangle de l'image
	CGRect lRect =CGRectMake(0, 0, pSize.width, pSize.height);
	
	NSLog(@"%@",NSStringFromCGRect(lRect));
	NSLog(@"operation count %d",[mPageLoadingQueue operationCount]);
	
	PDFPageOperation* lOperation= [[PDFPageOperation alloc]initWithPDFPage:lPage outRect:lRect];
	lOperation.target =self;
	lOperation.selector = @selector(pdfFPageOperationDelegate:image:fromPage:);
	
	[mPageLoadingQueue addOperation:lOperation];
	[lOperation release];
	
}

-(void)sliderViewController:(SliderViewController*)pController renderPageAtIndex:(uint)pPageIndex size:(CGSize)pSize
{
	mSliderController =pController;
	
	
	
	NSLog(@"CACHE PAGE");
	PDFPageRenderer* lPage = [mLoader pageAtIndex:pPageIndex];
	
	bool lCancel =[self findAndRemoveSameOperation:pController.currentPage page:lPage];
	
	if(lCancel)
	{
		NSLog(@"l'opératipon est déja en cours , je ne fais rien");
		return;
	
	}
	

	//Le rectangle de l'image
	CGRect lRect =CGRectMake(0, 0, pSize.width, pSize.height);
	
	NSLog(@"%@",NSStringFromCGRect(lRect));
	NSLog(@"operation count %d",[mPageLoadingQueue operationCount]);
	
	PDFPageOperation* lOperation= [[PDFPageOperation alloc]initWithPDFPage:lPage outRect:lRect];
	lOperation.target =self;
	lOperation.selector = @selector(pdfFPageOperationDelegate:image:fromPage:);
	
	[mPageLoadingQueue addOperation:lOperation];
	[lOperation release];
	
}

-(bool)findAndRemoveSameOperation:(uint)pIndex page:(PDFPageRenderer*)pPage
{
	
	NSArray* lOPArray = [mPageLoadingQueue operations];
	
	
	for (PDFPageOperation* lOP in lOPArray)
	{
		
		//Si la page est finie , on continue
		if([lOP isFinished])
			continue;
		
		//Si la page est cancel , on continue
		if([lOP isCancelled])
			continue;
		
		//Si 'opératione est en train de s'executer
		if([lOP isExecuting])
		{
		
			NSLog(@"L'operation sexecute");
			
			//Si elle n'est plus dans les bornes
			//On la cancel
			if(lOP.pdfPage.pageIndex < pIndex - MAX_OPERATION || lOP.pdfPage.pageIndex > pIndex + MAX_OPERATION )
			{
				NSLog(@"l'opératipon n'est plus dans les bornes");
				[lOP cancel];
			}
			
			//Si l'indice est le même que la page demandée (et le formt identique)
			//On annule la page demandée
			if(lOP.pdfPage.pageIndex == pPage.pageIndex && lOP.pdfPage.isSinglePage == pPage.isSinglePage)
				return YES;
		
			continue;
		}
		
		
		
		//Ici les pages ne sont ni canceed ni en cours d'exection, ni finie (en attente quoi....)
		
		//Si la page n'est pa finie
		if(![lOP isFinished])
		{
			NSLog(@"L'operation est en attente");
			
			
			//Même que nous ?
			if(lOP.pdfPage.pageIndex == pPage.pageIndex && lOP.pdfPage.isSinglePage == pPage.isSinglePage)
			{
				return YES;
			}
			
			//Si elle n'est plus dans les bornes
			//On la cancel
			if(lOP.pdfPage.pageIndex < pIndex - MAX_OPERATION || lOP.pdfPage.pageIndex > pIndex + MAX_OPERATION )
			{
				NSLog(@"l'opératipon n'est plus dans les bornes");
				[lOP cancel];
			}
			
		}
		
		
		
	}
	
	return FALSE;
}



-(void)sliderViewControllerFreeMemory:(SliderViewController*)pController
{

	NSLog(@"***********RTHJK");
	[mLoader closePDF];
	[mLoader openPDF];
}
 
 

-(void)pdfFPageOperationDelegate:(PDFPageOperation*)pOperation image:(UIImage*)pImage fromPage:(PDFPageRenderer*)pPage
{
	[pImage retain];
	[mSliderController setImage:pImage forIndex:pPage.pageIndex];
	

}





@end
