/*
 *  InvocationUtil.m
 *  book
 *
 *  Created by deumeure tepue on 4/5/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


#import "InvocationUtil.h"


@implementation InvocationUtil


+(NSInvocation*)createInvocation:(NSObject*)pTarget AndSelector:(SEL)pSelector
{
	NSMethodSignature *aSignature;
	aSignature = [pTarget.class instanceMethodSignatureForSelector:pSelector];
	NSInvocation* lInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
	[lInvocation setSelector:pSelector];
	[lInvocation setTarget:pTarget];
	
	return lInvocation;
}


@end
