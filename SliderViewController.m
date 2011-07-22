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

-(PageIndex)giveDoublePageIndexesFromSinglePageIndex:(uint)pIndex;
-(uint)giveSingllePageIndexeFromDoublePageIndexes:(PageIndex)pIndexes;

@end

#define CACHE_NUM 2

#define isSinglePage (self.presentation == sliderPresentationSinglePage)
#define isDoublePage (self.presentation == sliderPresentationDoublePage)

@implementation SliderViewController


-(id)initWithPageCount:(uint)pPageCount
{
	self = [super init];
	
	if(self)
	{
		mPageCount = pPageCount;
	//	mRealPageCount = pPageCount;
		mCurrentPage = 0;
	
		mLockObject = [[NSObject alloc]init];
	}
	
		
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
	mScrollView.backgroundColor = [UIColor redColor];
//	self.view.backgroundColor  = [UIColor blueColor];

	mPresentation = sliderPresentationSinglePage;
	[self.view addSubview:mScrollView];
	
	mSinglePageBorders = CGRectMake(10,10,10,10);
	mDoublePageBorders = CGRectMake(20, 20, 20, 20);
	
	[self updateDatas];
	
	//[self gotoPage:1];
	
}

-(void)updateDatas
{

	mScrollView.frame = self.view.bounds;
	
	//Le calcul lors du passage a une autre orientation
	
	

	

	mScrollView.contentSize = CGSizeMake(mPageCount* mScrollView.bounds.size.width, mScrollView.bounds.size.height);

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


//WARNING
-(void)resetPages
{

	for (UIView* lView in mScrollView.subviews)
	{
		[lView removeFromSuperview];
	}
}

-(void)gotoPage:(uint)pPageIndex
{
	mScrollView.contentOffset =CGPointMake((self.view.bounds.size.width *(pPageIndex-1)), 0) ;
	
	mCurrentPage = pPageIndex;
	int lLimitInf = pPageIndex- CACHE_NUM;
	int lLimitSup = pPageIndex+ CACHE_NUM;
	
	for(int i = lLimitInf	; i<= lLimitSup ;i++)
	{
		[self cachePage:i];
	}
}

-(void)setImage:(UIImage*)lImage forIndex:(uint)pIndex
{
		
	UIScrollView* lScrollView  =(UIScrollView*) [mScrollView viewWithTag:pIndex];
		
		
	if(lScrollView == nil)
		return;
	
	UIImageView* lImageView = (UIImageView*)[lScrollView viewWithTag:1851];
		
	//
//	if([lImageView class] [])
//	NSLog(@"set image for page : %d",pIndex);
//	
//	NSLog(@" lScrollView  = %@",lScrollView );
//	
//	NSLog(@"lImageView = %@",lImageView);
	
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
		
		NSLog(@"*REMOVE scrollview %d",lScrollView.tag);
		
		
		//[self setImage:nil forIndex:pPageIndex];
		
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
	lScrollView = [[[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (pPageIndex-1), 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
	lScrollView.tag = pPageIndex;
	
	//On créé  l' imageView
	UIImageView* lImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 768, 1024)] autorelease];
	lImageView.tag = 1851;
	lImageView.backgroundColor  = [UIColor yellowColor];
	
	
	//On met la frame en fonction des bordures
	CGRect lBorders = self.presentation == sliderPresentationSinglePage  ? self.singlePageBorders : self.doublePageBorders  ;
	CGRect lRect = CGRectMake(lBorders.origin.x,lBorders.origin.y , self.view.bounds.size.width - (lBorders.origin.x+lBorders.size.width), self.view.bounds.size.height - (lBorders.origin.y+lBorders.size.height));

	lImageView.frame =lRect;
	
	[lScrollView addSubview:lImageView];
	
	
	//On l'ajoute
	[mScrollView addSubview:lScrollView];
	
	NSLog(@"*ADD scrollview %d",lScrollView.tag);
	


	//On demande l'image au datasource
	if(self.presentation == sliderPresentationSinglePage)
		[mDataSource sliderViewController:self cachePageAtIndex:pPageIndex];
	else {
		
		PageIndex lIndex = [self giveDoublePageIndexesFromSinglePageIndex:pPageIndex];
		
		
		[mDataSource sliderViewController:self cachePageAtIndex:lIndex.index1 andIndex:lIndex.index2];
	}

	
}



//Passe à la page suivante
-(void)pagePlus
{
	
	if(mCurrentPage == mPageCount)
		return;
	
	//On decache la page la plus en arriere
	[self unCachePage:mCurrentPage - CACHE_NUM];
	
	//On passe à la page suivante
	
	mCurrentPage++;
	
	
	//On render la page courante
	[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
	
	//On cache la page suivante
	[self cachePage:mCurrentPage + CACHE_NUM];
	
	
	NSLog(@"page %d",mCurrentPage);
}


//Page à la page précédente
-(void)pageMinus
{
	
	if(mCurrentPage == 0)
		return;
	
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
#pragma mark Rotation functions

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	NSLog(@"HJKL");
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self resetPages];
	
	//self.presentation = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? sliderPresentationSinglePage	: sliderPresentationDoublePage;
	

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	self.presentation = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? sliderPresentationSinglePage	: sliderPresentationDoublePage;
	
}




-(void)switchToSinglePage
{

	[self updateDatas];
	//On reset les pages
	[self gotoPage:mCurrentPage];
	
}

-(void)switchToDoublePage
{
	[self updateDatas];

	//On reset les pages
	[self gotoPage:mCurrentPage];
	
}

#pragma mark-
#pragma mark UiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	

	uint lCurrentPage = (uint) scrollView.contentOffset.x  /self.view.bounds.size.width  +1;
	
	float lkk =  (scrollView.contentOffset.x  / self.view.bounds.size.width +1.0f) -((int)scrollView.contentOffset.x  / self.view.bounds.size.width  +1);
	
	
	if (mCurrentPage > lCurrentPage)
	{
		if(lkk >0.2f)
			return;
		
		[self pageMinus];
		NSLog(@"mCurrenPage %d",mCurrentPage);
	}
	
	if(mCurrentPage < lCurrentPage)
	{

		[self pagePlus];
		NSLog(@"mCurrenPage %d",mCurrentPage);
	}

}


#pragma mark -
#pragma mark Paging util function

//convertie des coordonnées silple page en coordonées double page
-(PageIndex)giveDoublePageIndexesFromSinglePageIndex:(uint)pIndex
{
	
	//si c'est 1 , c'est spécial
	if(pIndex == 1)
	{
		return PageIndexMake(0, 1);
	}
	
	
	//uint lFirstPage =  (mCurrentPage/2 + 1);
	
	//Si la dernière page est paire, elle est seule
	if(pIndex == mPageCount && pIndex %2 ==0)
	{
		return PageIndexMake(pIndex,0);
	}
	
	return PageIndexMake(pIndex,pIndex +1);
}


//Converti des coordonnées double page en cordonnées sinple page
-(uint)giveSingllePageIndexeFromDoublePageIndexes:(PageIndex)pIndexes
{
	if(pIndexes.index1 ==0)
		return pIndexes.index2;
	
	return pIndexes.index1;
	//MIN(mPageCount,(pIndexes*2 -1));
}


#pragma mark -
#pragma mark Properties



-(void)setPresentation:(SliderPresentation)pPresentation
{
	
	mPresentation = pPresentation;
	
	if(mPresentation == sliderPresentationSinglePage)
		[self switchToSinglePage];
	else 
		[self switchToDoublePage];
	

	
}


-(void)setPageCount:(uint)pPageCount
{
	
	//Handle change of pagecount (pour ch	ngement d'orientation)
}

@synthesize dataSource = mDataSource;
@synthesize delegate =mDelegate;
@synthesize pageCount = mPageCount;
@synthesize currentPage = mCurrentPage;
@synthesize presentation =  mPresentation;
@synthesize singlePageBorders = mSinglePageBorders;
@synthesize doublePageBorders = mDoublePageBorders;

@end




