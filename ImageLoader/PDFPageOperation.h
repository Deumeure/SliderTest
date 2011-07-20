//
//  PDGFPageOperation.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFPage.h"

@protocol PDFPageOperationDelegate;


@interface PDFPageOperation : NSOperation
{

	PDFPage* mPDFPage;
	CGRect mOutRect;
	UIImage* mImage;
	
	id<PDFPageOperationDelegate> mDelegate;
	
}

-(id)initWithPDFPage:(PDFPage*)pPage outRect:(CGRect)pRect;


@property(nonatomic,readonly)PDFPage* pdfPage;
@property(nonatomic,assign)id<PDFPageOperationDelegate> delegate;

@end



@protocol PDFPageOperationDelegate

-(void)pdfFPageOperationDelegate:(PDFPageOperation*)pOperation image:(UIImage*)pImage fromPage:(PDFPage*)pPage;

@end
