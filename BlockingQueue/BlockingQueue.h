//
//  BlockingQueue.h
//  book
//
//  Created by Coutris Jean-Pascal on 22/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	kNoWorkQueued = 0,
	kWorkQueued = 1
}kworkType;

@interface BlockingQueue : NSObject 
{
	
    NSMutableArray *queue;
    NSConditionLock *queueLock;

	
}



- (id)pop;
- (void)push:(id)unitOfWork;
- (void)clear;
@end
