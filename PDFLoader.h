//
//  PDFLoader.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFPage.h"

@interface PDFLoader : NSObject
{

	NSString* mPath;
	
	CGPDFDocumentRef mPDF;
}


-(id)initWithPath:(NSString*)pPath;

-(void)openPDF;
-(void)closePDF;

-(PDFPage*)pageAtIndex:(uint)pPageIndex;
-(PDFPage*)doublePageAtIndex:(uint)pPageIndex andIndex:(uint)pPageIndex2 pageID:(uint)pID;

@property(nonatomic,readonly)uint pageCount;

@end
