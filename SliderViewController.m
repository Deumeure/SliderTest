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

-(uint)convertDoublePageIndexToSinglePageIndex:(uint)pIndex;
-(uint)convertSinglePageIndexToDoublePageIndex:(uint)pIndex;
-(uint)getRealPageIndex:(uint)pIndex;
@end

#define CACHE_NUM 1

#define isSinglePage (self.presentation == sliderPresentationSinglePage)
#define isDoublePage (self.presentation == sliderPresentationDoublePage)

@implementation SliderViewController


-(id)initWithPageCount:(uint)pPageCount
{
	self = [super init];
	
	if(self)
	{
		mPageCount = pPageCount;
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
	
	self.presentation = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? sliderPresentationSinglePage	: sliderPresentationDoublePage;
	mScrollView.bounces=NO;

	
}

-(void)updateDatas
{

	mScrollView.frame = self.view.bounds;
	
	//Le calcul lors du passage a une autre orientation
	
	
	uint lPageCount = mPageCount;
	
	if(self.presentation == sliderPresentationDoublePage)
	{
		lPageCount = [self convertSinglePageIndexToDoublePageIndex:mPageCount];
		
		NSLog(@"je passe de la page %d a la page %d",mPageCount,lPageCount);
	}

	mScrollView.contentSize = CGSizeMake(lPageCount* mScrollView.bounds.size.width, mScrollView.bounds.size.height);
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	mScrollView.scrollEnabled=NO;
	
	[mDelegate sliderViewControllerFreeMemory:self];
	mScrollView.scrollEnabled=YES;
	
	
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

	NSLog(@"------- GOTOPAGE");
	
	mCurrentPage = pPageIndex;
	
	int lLimitInf = pPageIndex - (isDoublePage ? 2*  CACHE_NUM: CACHE_NUM);
	int lLimitSup = pPageIndex + (isDoublePage ? 2*  CACHE_NUM: CACHE_NUM);
	
	uint lIncement = (isDoublePage) ? 2 : 1 ;
	for(int i = lLimitInf	; i<= lLimitSup ; i+=lIncement)
	{
		[self cachePage:i];
	}
	
	
	//On cherche le "vrai" index de page pour placer la scrollbar
	uint lRealPageIndex = [self getRealPageIndex:pPageIndex];
	
	mScrollView.delegate = nil;
	mScrollView.contentOffset =CGPointMake((self.view.bounds.size.width *(lRealPageIndex-1)), 0) ;
	mScrollView.delegate = self;
	[self cachePage:pPageIndex];
	
	
}

-(void)setImage:(UIImage*)lImage forIndex:(uint)pIndex
{
		
	NSLog(@"Je recois l'image pour la %d",pIndex);
	
	PDFPageView* lScrollView  =(PDFPageView*) [mScrollView viewWithTag:pIndex];
    lScrollView.contentSize = CGSizeMake(lScrollView.frame.size.width, lScrollView.frame.size.height);
		
	if(lScrollView == nil)
		return;
	
//	UIImageView* lImageView = (UIImageView*)[lScrollView viewWithTag:1851];
//	UIActivityIndicatorView* lIndicator =[lImageView viewWithTag:1826];
//	[lIndicator stopAnimating];
	//
//	if([lImageView class] [])
//	NSLog(@"set image for page : %d",pIndex);
//	
//	NSLog(@" lScrollView  = %@",lScrollView );
//	
//	NSLog(@"lImageView = %@",lImageView);
	
//   
//    lImageView.frame = CGRectMake(0, 0, lImage.size.width, lImage.size.height);
//    lImageView.center = lScrollView.superview.center;
////    
//    lImageView.contentMode = UIViewContentModeCenter;
//    
//    NSLog(@"lImage.size %@",NSStringFromCGSize(lImage.size));
    
	
    
    lScrollView.image = lImage;

	
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
		
		PDFPageView* lScrollView  =(PDFPageView*) [mScrollView viewWithTag:pPageIndex];
		
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
	PDFPageView* lScrollView  =(PDFPageView*) [mScrollView viewWithTag:pPageIndex];
	

	//Déja cache ?? on quitte
	if(lScrollView)
	{
		NSLog(@"DEJA CACHE");
		
		return;
	}
	
	//On cherche le "vrai" index de page pour placer la scrollbar
	uint lRealPageIndex = [self getRealPageIndex:pPageIndex];
		
	//On créé la PDFPageView

	
    if(isDoublePage)
    {
        PageIndex lIndexes = [self giveDoublePageIndexesFromSinglePageIndex:pPageIndex];
        lScrollView = [[[PDFPageView alloc]initWithDoublePageIndex:lIndexes.index1 andIndex:lIndexes.index2] autorelease];
    }else
	lScrollView = [[[PDFPageView alloc]initWithPageIndex:pPageIndex] autorelease];
	lScrollView.pdfpagedelegate=self;
    
    lScrollView.frame =CGRectMake(self.view.bounds.size.width * (lRealPageIndex-1), 0, self.view.bounds.size.width, self.view.bounds.size.height);
    lScrollView.borders = self.presentation == sliderPresentationSinglePage  ? self.singlePageBorders : self.doublePageBorders  ;
    lScrollView.tag =pPageIndex;
    
	//On l'ajoute
	[mScrollView addSubview:lScrollView];
	
	NSLog(@"*ADD scrollview %d",lScrollView.tag);
	

    CGRect lBorders = self.presentation == sliderPresentationSinglePage  ? self.singlePageBorders : self.doublePageBorders;
	//Le rectangle de l'image
	CGSize lSize = CGSizeMake( self.view.bounds.size.width - (lBorders.origin.x+lBorders.size.width), self.view.bounds.size.height - (lBorders.origin.y+lBorders.size.height));
	
	//On demande l'image au datasource
	if(self.presentation == sliderPresentationSinglePage)
		[mDataSource sliderViewController:self renderPageAtIndex:pPageIndex size:lSize];
	else {
		
		
		PageIndex lIndex = [self giveDoublePageIndexesFromSinglePageIndex:pPageIndex];
		
		NSLog(@"Je doit cache la page %d",pPageIndex);
		NSLog(@"Je recoi %d   %d",lIndex.index1,lIndex.index2);
		
		[mDataSource sliderViewController:self renderDoublePageAtIndex:lIndex.index1 andIndex:lIndex.index2 size:lSize];
	}
    
    
  
    
	
}



//Passe à la page suivante
-(void)pagePlus
{
	
	if(mCurrentPage == mPageCount)
		return;
	
    
    [self pageDidHide];
    
    //On prévient la page qu'elle n'est plus affichée

	//TODO Ce code est assez pourri mais il fonctionne correctement....
	//On decache la page la plus en arriere
	if(self.presentation == sliderPresentationSinglePage)
	{
		[self unCachePage:mCurrentPage - CACHE_NUM];
	}else {
		//Si on est a la derniere double page
		if(mCurrentPage - 2*CACHE_NUM <1)
			[self unCachePage:mCurrentPage-CACHE_NUM];
		else
			[self unCachePage:mCurrentPage - 2*CACHE_NUM];
	}

	
	//On passe à la page suivante
	
	//Si c'est double page on augnment de deux
	if(self.presentation == sliderPresentationDoublePage)
	{
		
		//Si on est en page 1 , on rajoute que 1
		if(mCurrentPage == 1)
			mCurrentPage++;
		else
			mCurrentPage +=2;
		
		
	}else
		mCurrentPage++;
	
	
	//On render la page courante
	//[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
	
	
	//On cache la page suivante
	if(self.presentation == sliderPresentationSinglePage)
	{
		[self cachePage:mCurrentPage + CACHE_NUM];
	}else {
		//Si on est a la derniere double page
		if(mCurrentPage + 2*CACHE_NUM > mPageCount)
			[self cachePage:mCurrentPage+CACHE_NUM];
		else
			[self cachePage:mCurrentPage + 2*CACHE_NUM];
	}

	
	NSLog(@"page %d",mCurrentPage);

    
    //On prévient la page qu'elle est affichée
  
    [self pageDidShow];
}


//Page à la page précédente
-(void)pageMinus
{
	
	if(mCurrentPage == 0)
		return;
	
    //On prévient la page qu'elle n'est plus affichée
    [self pageDidHide];
    
    //TODO Ce code est assez pourri mais il fonctionne correctement....
	//On decache la page la plus en avant
	if(self.presentation == sliderPresentationSinglePage)
	{
		[self unCachePage:mCurrentPage + CACHE_NUM];
	}else {
		//Si on est a la derniere double page
		if(mCurrentPage + 2*CACHE_NUM <1)
			[self unCachePage:mCurrentPage + CACHE_NUM];
		else
			[self unCachePage:mCurrentPage + 2 *CACHE_NUM];
	}
	
	
	
	//On passe à la page précédente
	
	//Si c'est une double page
	if(self.presentation == sliderPresentationDoublePage)
	{
		//Si on était en page 2
		if(mCurrentPage == 2)
			mCurrentPage--;
		else
			mCurrentPage-=2;
		
	}else
		mCurrentPage--;
	
	//On render la page courante
	//[mDataSource sliderViewController:self renderPageAtIndex:mCurrentPage];
	
	//On cache la page précédente
	if(self.presentation == sliderPresentationSinglePage)
	{
		[self cachePage:mCurrentPage - CACHE_NUM];
	}else {
		//Si on est a la derniere double page
		if(mCurrentPage - 2*CACHE_NUM > mPageCount)
			[self cachePage:mCurrentPage-CACHE_NUM];
		else
			[self cachePage:mCurrentPage - 2*CACHE_NUM];
	}
	

	NSLog(@"page %d",mCurrentPage);
    
    //On prévient la page qu'elle est affichée
    [self pageDidShow];
    
}
-(void)pageDidHide
{
    [mLinkAnimationTimer release];
    [mLinkAnimationTimer invalidate];
    mLinkAnimationTimer= nil;
    
    PDFPageView* lPageHidden = (PDFPageView*)[mScrollView viewWithTag:mCurrentPage];
    [lPageHidden pageDidHide];
    
    
}


-(void)pageDidShow
{
    
    [mLinkAnimationTimer release];
    [mLinkAnimationTimer invalidate];
    mLinkAnimationTimer= nil;
    
    mLinkAnimationTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showLinkFireMethod:) userInfo:[NSNumber numberWithInt:mCurrentPage] repeats:NO] retain];
}

- (void)showLinkFireMethod:(NSTimer*)theTimer
{
    NSLog(@"showLinkFireMethod");
    PDFPageView* lPageShown = (PDFPageView*)[mScrollView viewWithTag:[theTimer.userInfo intValue]];
    [lPageShown pageDidShow];
    
    NSLog(@"EndshowLinkFireMethod");
    
    [mLinkAnimationTimer release];
    mLinkAnimationTimer = nil;
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

	NSLog(@"++++++ switchToSinglePage");
	[self updateDatas];
	//On reset les pages
	[self gotoPage:mCurrentPage];
	
}

-(void)switchToDoublePage
{
	//Toujours une page paire aest toujours a gauche
    
    PageIndex lIndexes = [self giveDoublePageIndexesFromSinglePageIndex:mCurrentPage];
    
    if(lIndexes.index1 %2 !=0 && lIndexes.index2!=1)
    {
        
        mCurrentPage--;
    }
    
    
	NSLog(@"++++++ switchToDoublePage");
	[self updateDatas];

	//On reset les pages
	[self gotoPage:mCurrentPage];
	
}

#pragma mark-
#pragma mark UiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	//On trouve le num de la page correspondant
	uint lCalculatedCurrentPage = (uint) scrollView.contentOffset.x  /self.view.bounds.size.width  +1;
	//lCalculatedCurrentPage = [self getRealPageIndex:lCalculatedCurrentPage];
	
	uint lRealCurrentPage = [self getRealPageIndex:mCurrentPage];
	
//	NSLog(@"lCalculatedCurrentPage %d",lCalculatedCurrentPage);
//	NSLog(@"lRealurrentPage %d",lRealCurrentPage);
//	
	float lkk =  (scrollView.contentOffset.x  / self.view.bounds.size.width +1.0f) -((int)scrollView.contentOffset.x  / self.view.bounds.size.width  +1);
	

    lkk = (lCalculatedCurrentPage * mScrollView.frame.size.width) -mScrollView.contentOffset.x ;
    
//	NSLog(@"");
//	NSLog(@"");
//	NSLog(@"");
    
	
	
	//Verifier que la page correspond a l'index de la double page histroire de pas faire tourner pour rien
//	if(lCalculatedCurrentPage != lRealCurrentPage && isDoublePage)
//	{
//		if([self convertSinglePageIndexToDoublePageIndex:lCalculatedCurrentPage] == [self convertSinglePageIndexToDoublePageIndex:lCalculatedCurrentPage])
//			return;
//	}

    NSLog(@"kk %f",lkk);
    
	if (lRealCurrentPage > lCalculatedCurrentPage)
	{
		if(lkk <mScrollView.frame.size.width-100)
			return;
		
		[self pageMinus];
		
		NSLog(@"mCurrenPage %d",mCurrentPage);
	}
	
	if(lRealCurrentPage < lCalculatedCurrentPage)
	{

		[self pagePlus];
		NSLog(@"mCurrenPage %d",mCurrentPage);
	}
//
//	NSLog(@"lCurrentPage %d",lCurrentPage);
//	NSLog(@"mCurrentPage %d",mCurrentPage);
}


#pragma mark-
#pragma PDFPageView delegate

-(void)pdfPageView:(PDFPageView*)pSender linkDidSelectWithType:(uint)pType andDatas:(NSString*)pLinkDatas
{
    
}
-(void)pdfPageView:(PDFPageView*)pSender zoomDidBeginWithScale:(CGFloat)pScale
{
    
}

#pragma mark -
#pragma mark Paging utils functions

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
    
//    //Si la page est impaire
//    if(pIndex %2 == 0)
//    {
//        
//        
//        NSLog(@"******pIndex %d",pIndex);
//        return PageIndexMake(pIndex-1, pIndex);
//    }
//    
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

-(uint)convertDoublePageIndexToSinglePageIndex:(uint)pIndex
{
	if(pIndex == 1)
		return 1;
	
	return (pIndex-1 )*2;
}

//TODO Gerer le cop de la derniere page
-(uint)convertSinglePageIndexToDoublePageIndex:(uint)pIndex
{
	if(pIndex == 1)
		return 1;
	
	
	return pIndex/2+1;
}


//Donne la numéro de page (pour la scroll Bar) en fonction du mode
-(uint)getRealPageIndex:(uint)pIndex
{
	if(isDoublePage)
		return [self convertSinglePageIndexToDoublePageIndex:pIndex];

	return pIndex;
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




