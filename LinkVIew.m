//
//  LinkButton.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LinkVIew.h"


@implementation LinkVIew


- (id)initWithLinkInfos:(NSDictionary*)pLinkInfos 
{
    
    self = [super init];
    if (self) 
	{
        self.linkInfos = pLinkInfos;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


-(void)animate
{
}

@synthesize linkInfos = mLinkInfos;

@end
