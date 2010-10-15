//
//  AppDelegate_Pad.m
//  HackerNews
//
//  Created by Michael Grinich on 10/15/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "HNStoryTableViewController.h"
#import "HNCommentsTableViewController.h"
#import "LoginViewController.h"
#import "HNStyle.h"
#import "HNAuth.h"


@implementation AppDelegate_Pad


@synthesize window;



#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	[window makeKeyAndVisible];
	[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];
	
	
	TTNavigator* rightSideNavigator = [[TTSplitNavigator splitNavigator]
									   navigatorAtIndex:TTNavigatorSplitViewRightSide];
	
	rightSideNavigator.persistenceMode = TTNavigatorPersistenceModeNone; //TTNavigatorPersistenceModeAll;
	
	
	TTURLMap* rightSideMap = rightSideNavigator.URLMap;
	
	
	[rightSideMap from:@"*"  toEmptyHistoryViewController:[HNWebController class]];
	
	[rightSideMap from:@"tt://home/comments/(initWithStory:)" 
toEmptyHistoryViewController:[HNCommentsTableViewController class]];
	
	[rightSideMap from:@"http://news.ycombinator.com/item?id=(initWithStory:)" 
toEmptyHistoryViewController:[HNCommentsTableViewController class]];
	
	
	
	TTNavigator* leftSideNavigator = [[TTSplitNavigator splitNavigator]
									  navigatorAtIndex:TTNavigatorSplitViewLeftSide];
	leftSideNavigator.persistenceMode = TTNavigatorPersistenceModeNone;
	
	TTURLMap* leftSideMap = leftSideNavigator.URLMap;
	
	[leftSideMap from:@"tt://home" toViewController:[HNStoryTableViewController class]];
	
	
	[[TTSplitNavigator splitNavigator]
	 restoreViewControllersWithDefaultURLs:[NSArray arrayWithObjects:
											@"tt://home",
											@"http://three20.info",
											nil]];
	
	
	NSURL *hnURL = [NSURL URLWithString:@"http://news.ycombinator.com/"];
	NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hnURL];
	if ([cookies count] > 0 ) {
		// TODO : check date and make sure that it's not expired
		[[HNAuth sharedHNAuth] setLoggedin:YES];
	} else {
		[[HNAuth sharedHNAuth] setLoggedin:NO];
	}
	
	
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}



@end
