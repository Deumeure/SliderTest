//
//  LinkButton.h
//  testslider
//
//  Created by Jean-Pascal Coutris on 23/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LinkVIew : UIView 
{
    uint mLinkType;
	NSDictionary* mLinkDatas;
    
 
}

- (id)initWithLinkInfos:(NSDictionary*)pLinkInfos ;


-(void)show;
-(void)hide;
-(void)animate;




@property(nonatomic,retain)NSDictionary* linkDatas;
@property(nonatomic,assign)uint linkType;

@end
