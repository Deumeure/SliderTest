//
//  CachingTool.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CachingTool : NSObject 
{
	uint mIndex;
	NSString* mTag;
}


-(id)initWithIndex:(uint)pIndex andTag:(NSString*)pTag;

-(bool)isCached;
-(UIImage*)readCache;
-(void)writeToCache:(UIImage*)pImage;


+(CachingTool*)cachingToolWithIndex:(uint)pIndex andTag:(NSString*)pTag;


@end
