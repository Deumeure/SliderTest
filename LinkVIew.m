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
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
        

        
        
    }
    return self;
}







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

    self.alpha = 0.5f;
    
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

    self.alpha = 0.0f;
    [UIView beginAnimations:@"ss" context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.alpha = 0.5f;
    
    [UIView commitAnimations];
    
    
 
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self hide];
}


@synthesize linkDatas = mLinkDatas;
@synthesize linkType = mLinkType;

@end

