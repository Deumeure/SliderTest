//
//  LinkButton.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LinkVIew : UIButton 
{
	NSDictionary* mLinkInfos;
}

- (id)initWithLinkInfos:(NSDictionary*)pLinkInfos ;

-(void)animate;

@property(nonatomic,retain)NSDictionary* linkInfos;


@end
