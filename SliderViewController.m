    //
//  SliderViewController.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderViewController.h"


@interface SliderViewController (Private)

-(void)raisePageChange;
-(void)unCachePage:(uint)pPageIndex;
-(void)cachePage:(uint)pPageIndex;

-(void)updateDatas;

@end

#define CACHE_NUM 2

@implementation SliderViewController


-(id)initWithPageCount:(uint)pPageCount
{
	mPageCount = pPageCount;
	mCurrentPage = 0;
	
	return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	mScrollView = [[[UIScrollView alloc]init] autorelease];
	mScrollView.frame = self.view.bounds;
	mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	mScrollView.pagingEnabled = YES;
	mScrollView.delegate =self;
//	self.view.backgroundColor  = [UIColor blueColor];

	[self.view addSubview:mScrollView];
	
	[self updateDatas];
	
	[self gotoPage:1];
	
}

-(void)updateDatas
{

	mScrollView.frame = self.view.bounds;
	
	//Le calcul lors du passage a une autre orientation
	
	mScrollView.contentSize = CGSizeMake(mPageCount* mScrollView.frame.size.width, mScrollView.frame.size.height);
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


-(void)gotoPage:(uint)pPageIndex
{
	
	mCurrentPage = 1;
	int lLimitInf = pPageIndex- CACHE_NUM;
	int lLimitSup = pPageIndex+ CACHE_NUM;
	
	for(int i = lLimitInf	; i< lLimitSup ;i++)
	{
		[self cachePage:i];
	}
}

-(void)setImage:(UIImage*)lImage forIndex:(uint)pIndex
{
	UIScrollView* lScrollView  =(UIScrollView*) [mScrollView viewWithTag:pIndex];
	

	if(lScrollView == nil)
		return;
	
	UIImageView* lImageView = (UIImageView*)[lScrollView viewWithTag:101];
	
	NSLog(@"seting image");
	lImageView.image = lImage;
}


-(void)raisePageChange
{
	//[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
}

-(void)unCachePage:(uint)pPageIndex
{
	
	if(pPageIndex <= 0 || pPageIndex >mPageCount)
		return;
	
	//On cherche la srollView a l'index
	
	UIScrollView* lScrollView  =(UIScrollView*) [mScrollView viewWithTag:pPageIndex];
	
	//Déja uncache ?? on quitte
	
	if(lScrollView == nil)
		return;
	
	NSLog(@"*REMOVE scrollview %d",lScrollView);
	
	//On remove la scrollView
	[lScrollView removeFromSuperview];
	
	
}

-(void)cachePage:(uint)pPageIndex
{

	
	if(pPageIndex <= 0 || pPageIndex >mPageCount)
		return;
	
	//On cherche la srollView a l'index
	
	UIScrollView* lScrollView  =(UIScrollView*) [mScrollView viewWithTag:pPageIndex];
	
	
	//Déja cache ?? on quitte
	
	if(lScrollView)
	{
		NSLog(@"DEJA CACHE");
		
		return;
	
	}
	//On créé la scrollview
	lScrollView = [[[UIScrollView alloc]initWithFrame:CGRectMake(768 * (pPageIndex-1), 0, 768, 1024)] autorelease];
	lScrollView.tag = pPageIndex;
	
	UIImageView* lImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 768, 1024)] autorelease];
	lImageView.tag = 101;
	lImageView.backgroundColor  = [UIColor yellowColor];
	[lScrollView addSubview:lImageView];
	
	
	//On l'ajoute
	[mScrollView addSubview:lScrollView];
	
		NSLog(@"*ADD scrollview %d",lScrollView);

	//On demande l'image au datasource
	[mDataSource sliderViewController:self cachePageAtIndex:pPageIndex];
}



-(void)pagePlus
{
	NSLog(@"PagePlus");
	
	//On decache la page la plus en arriere
	[self unCachePage:mCurrentPage - CACHE_NUM];
	
	//On passe à la page suivant
	mCurrentPage++;
	
	//On render la page courante
	[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
	
	//On cache la page suivante
	[self cachePage:mCurrentPage + CACHE_NUM];
	
	
	NSLog(@"page %d",mCurrentPage);
}



-(void)pageMinus
{
	
	//On decache la page la plus en avant
	[self unCachePage:mCurrentPage + CACHE_NUM];
	
	//On passe à la page précédente
	mCurrentPage--;
	
	//On render la page courante
	[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
	
	//On cache la page avant
	[self cachePage:mCurrentPage - CACHE_NUM];
	
		NSLog(@"page %d",mCurrentPage);
}



-(void)pppp
{
	mScrollView.scrollEnabled = YES;
}


#pragma mark-
#pragma mark UiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//NSLog(@"scrollViewDidScroll");
	
	uint lCurrentPage = (uint) scrollView.contentOffset.x  /768 +1;
	
		if (mCurrentPage > lCurrentPage)
	{
		[self pageMinus];
	}
	
	if(mCurrentPage < lCurrentPage)
	{
		[self pagePlus];
	}
	
//	if (mCurrentPage != lCurrentPage)
//	{
//		//mCurrentPage = lCurrentPage;
//		NSLog(@"lPage %d",lCurrentPage);
//		[self raisePageChange];
//		
//	}
	//mScrollView.scrollEnabled = NO;
	//[self performSelector:@selector(pppp) withObject:nil afterDelay:0.5];
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//	uint lPage = (uint) scrollView.contentOffset.x  /768;
//	
//	
//		NSLog(@"X %f    Width %f",  scrollView.contentOffset.x,scrollView.contentSize.width );
//	NSLog(@"lPage %d",lPage);
}




#pragma mark -
#pragma mark Properties

-(void)setPageCount:(uint)pPageCount
{
	
	//Handle change of pagecount (pour ch	ngement d'orientation)
}

@synthesize dataSource = mDataSource;
@synthesize delegate =mDelegate;
@synthesize pageCount = mPageCount;

@end




