//
//  BlockingQueue.m
//  book
//
//  Created by Coutris Jean-Pascal on 22/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlockingQueue.h"




@implementation BlockingQueue

- (id)init 
{
    if ((self = [super init])) 
	{
        queueLock = [[NSConditionLock alloc] initWithCondition:kNoWorkQueued];
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [queueLock release];
    [queue release];
    [super dealloc];
}

- (id)pop 
{
    id unitOfWork = nil;
	[queueLock lockWhenCondition:kWorkQueued];
	unitOfWork = [[[queue objectAtIndex:0] retain] autorelease];
	[queue removeObjectAtIndex:0];
	[queueLock unlockWithCondition:([queue count] ? kWorkQueued : kNoWorkQueued)];
    
    return unitOfWork;
}

- (void)push:(id)unitOfWork {
	NSLog(@"queue.count %d",queue.count);
    [queueLock lock];
    [queue addObject:unitOfWork];
    [queueLock unlockWithCondition:kWorkQueued];
}

//TODO Vérifier le thread safe
- (void)clear 
{
	
	
	NSMutableArray *discardedItems = [NSMutableArray array];
	NSObject *item;
	
	for (item in queue) 
	{
			[discardedItems addObject:item];
	}
	
	[queue removeObjectsInArray:discardedItems];
	[queueLock unlockWithCondition:([queue count] ? kWorkQueued : kNoWorkQueued)];
    
}
@end