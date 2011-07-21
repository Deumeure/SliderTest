//
//  PDFPage.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDFPage : NSObject 
{

	uint mPageIndex;
	uint mPageIndex2;
	
	uint mID;
	
	CGPDFPageRef mPDFPage;
	CGPDFPageRef mPDFPage2;
	
	bool mDoublePage;
}


-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex  PDFPage2:(CGPDFPageRef)pPage2 pageIndex2:(uint)pPageIndex2 pageID:(uint)pID;
-(id)initWithPDFPage:(CGPDFPageRef)pPage pageIndex:(uint)pPageIndex;

-(CGSize)originaleSize;
-(UIImage*)imageForRect:(CGRect)pImageRect;


@property(nonatomic,readonly)uint pageIndex;
@property(nonatomic,readonly)uint pageIndex2;
@property(nonatomic,readonly) uint ID;

@property(nonatomic,assign)bool isSinglePage;
@property(nonatomic,assign) uint singlePageIndex;



@end
