//
//  PDGFPageOperation.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFPageRenderer.h"

@protocol PDFPageOperationDelegate;


@interface PDFPageOperation : NSOperation
{

	PDFPageRenderer* mPDFPage;
	CGRect mOutRect;
	UIImage* mImage;
	
//	id<PDFPageOperationDelegate> mDelegate;
//	
	id mTarget;
	SEL mSelector;
}

-(id)initWithPDFPage:(PDFPageRenderer*)pPage outRect:(CGRect)pRect;


@property(nonatomic,readonly)PDFPageRenderer* pdfPage;
@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL selector;

@end



//@protocol PDFPageOperationDelegate
//
//-(void)pdfFPageOperationDelegate:(PDFPageOperation*)pOperation image:(UIImage*)pImage fromPage:(PDFPageRenderer*)pPage;
//
//@end
