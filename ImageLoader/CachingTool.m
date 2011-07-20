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



-(id)initWithIndex:(uint)pIndex
{
	mIndex = pIndex;
	
	return self;
}


#define PATH [NSString stringWithFormat:@"page%d.png",mIndex]

-(UIImage*)readCache
{
//	if(![self isCached])
//		return nil;
//	

	return [UIImage imageWithContentsOfFile:[NSFileUtility retourneDocumentPath:PATH]];
}

-(bool)isCached
{
	return  [NSFileUtility verifyIfFileExistInDocument:[NSString stringWithFormat:@"page%d.png",mIndex]];

}

-(void)writeToCache:(UIImage*)pImage
{
//	if([self isCached])
//		return;
//	
	NSData *lImageData = [NSData dataWithData:UIImagePNGRepresentation(pImage)];
	[lImageData writeToFile:[NSFileUtility retourneDocumentPath:PATH] atomically:YES];
}

+(CachingTool*)cachingToolWithIndex:(uint)pIndex
{
	return [[[CachingTool alloc]initWithIndex:pIndex] autorelease];
}


//-(void)dealloc
//{
//
//	[super dealloc];
//}

@end
