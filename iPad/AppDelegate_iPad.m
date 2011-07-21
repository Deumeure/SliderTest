//
//  AppDelegate_iPad.m
//  testslider
//
//  Created by Jean-Pascal Coutris on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "PDFLoader.h"
#import "PDFPage.h"
#import "SliderViewController.h"
#import "SliderDelegate.h"

@implementation AppDelegate_iPad


@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	
//	PDFLoader* lLoader = [[PDFLoader alloc]initWithPath:@"mobile.pdf"];
//	
//	[lLoader openPDF];
//	
//	NSLog(@"nb Page %d",lLoader.pageCount);
//	
//	PDFPage* lPage = [lLoader pageAtIndex:1];
//	UIImage* lImage = [lPage imageForRect:CGRectMake(0, 0, 500,500)];
//	
//	
//	UIImageView* lImageView = [[UIImageView alloc]initWithImage:lImage];
//	lImageView.backgroundColor = [UIColor redColor];
//	[self.window addSubview:lImageView];
//	
	
	
	
	SliderViewController *lController = [[SliderViewController alloc]initWithPageCount:556];
	lController.view.frame = window.bounds;
	
	
	SliderDelegate* lDelegate = [[SliderDelegate alloc]init];
	[lDelegate start];
	
	
	lController.dataSource = lDelegate;
	
	[self.window addSubview:lController.view];
	
	[lController gotoPage:90];
	    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
