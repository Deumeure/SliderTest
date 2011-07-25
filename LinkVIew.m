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
       
        mLinkType  = [[pLinkInfos objectForKey:@"type"]intValue];
        mLinkDatas =[pLinkInfos retain];
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

- (void)dealloc 
{
    [mLinkDatas release];
    [super dealloc];
}

#pragma mark -
#pragma mark Animation functions

-(void)show
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];

    self.alpha = 1.0f;
    
    [UIView commitAnimations];
}


-(void)hide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
 
    self.alpha = 0.0f;
    
    [UIView commitAnimations];
}

-(void)animate
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];

    self.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelay:1.0f];
    self.alpha = 0.0f;
    
    [UIView commitAnimations];
}




@synthesize linkDatas = mLinkDatas;
@synthesize linkType = mLinkType;

@end

