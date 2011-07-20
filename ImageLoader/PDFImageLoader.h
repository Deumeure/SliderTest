//
//  ImageLoader.h
//  ImageLoader
//
//  Created by Mac5 on 09/08/10.
//  Copyright 2010 Anuman Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockingQueue.h"
#import "PDFPage.h"


@protocol PDFImageLoaderDelegate;


@interface PDFImageLoader : NSObject 
{

	BlockingQueue* mWorkingQueue;
	NSObject* mLockObject;
	bool mIsWorking;
	
	
	id<PDFImageLoaderDelegate>mDelegate;
}


//Demmarre l'imageLoader
-(void)start;

//Ajoute une image à la file d'attente
-(void)loadImageForPage:(PDFPage*)pPage outRect:(CGRect)pRect;


@property(assign)id<PDFImageLoaderDelegate> delegate;
@property(assign)bool isWorking;
@end


@protocol PDFImageLoaderDelegate

-(void)pdfImageLoader:(PDFImageLoader*)pLoader image:(UIImage*)pImage fromPage:(PDFPage*)pPage;

@end
