//
//  CachingTool.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CachingTool.h"
#import "NSFileUtility.h"

@implementation CachingTool



-(id)initWithIndex:(uint)pIndex andTag:(NSString*)pTag
{
	mIndex = pIndex;
	mTag = [pTag retain];
	return self;
}


#define PATH [NSString stringWithFormat:@"page%d_%@.png",mIndex,mTag]

-(UIImage*)readCache
{
//	if(![self isCached])
//		return nil;
//	

	return [UIImage imageWithContentsOfFile:[NSFileUtility retourneDocumentPath:PATH]];
}

-(bool)isCached
{
	return  [NSFileUtility verifyIfFileExistInDocument:PATH];

}

-(void)writeToCache:(UIImage*)pImage
{
//	if([self isCached])
//		return;
//	
	NSData *lImageData = [NSData dataWithData:UIImagePNGRepresentation(pImage)];
	[lImageData writeToFile:[NSFileUtility retourneDocumentPath:PATH] atomically:YES];
}

+(CachingTool*)cachingToolWithIndex:(uint)pIndex andTag:(NSString*)pTag
{
	return [[[CachingTool alloc]initWithIndex:pIndex andTag:pTag] autorelease];
}


-(void)dealloc
{
	[mTag release];
	[super dealloc];
}

@end
