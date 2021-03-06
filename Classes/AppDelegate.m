//
//  AppDelegate.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright Michael Grinich 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "HNStoryTableViewController.h"
#import "HNCommentsTableViewController.h"
#import "LoginViewController.h"
#import "HNStyle.h"
#import "HNAuth.h"

#import "HNWebController.h"


@implementation AppDelegate

@synthesize window;



#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
		
	[window makeKeyAndVisible];
	[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;	

	
	TTURLMap* map = navigator.URLMap;
	
	// Any URL that doesn't match will fall back on this one, and open in the web browser
	[map from:@"*" toViewController:[HNWebController class]];
	
	
	[map from:@"tt://home" toSharedViewController:[HNStoryTableViewController class]];
	[map from:@"tt://home/comments/(initWithStory:)" toViewController:[HNCommentsTableViewController class]];
	[map from:@"http://news.ycombinator.com/item?id=(initWithStory:)" toViewController:[HNCommentsTableViewController class]];
	[map from:@"tt://login" toSharedViewController:[LoginViewController class]];
	
	
	//	 best	Highest voted recent links.
	//	 active	Most active current discussions.
	//	 bestcomments	Highest voted recent comments.
	//	 noobs	Submissions from new accounts.
	
	
	
	NSURL *hnURL = [NSURL URLWithString:@"http://news.ycombinator.com/"];
	NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hnURL];
	if ([cookies count] > 0 ) {
		// TODO : check date and make sure that it's not expired
		[[HNAuth sharedHNAuth] setLoggedin:YES];
	} else {
		[[HNAuth sharedHNAuth] setLoggedin:NO];
	}
	
	
	if (![navigator restoreViewControllers]) {
		// [navigator openURL:@"tt://home" animated:NO];	// Deprecated
		TTOpenURL(@"tt://home");
		//		[navigator openURL:@"http://news.ycombinator.com/item?id=486755" animated:NO];	// Large comment set
		//		[navigator openURL:@"http://news.ycombinator.com/item?id=1019939" animated:NO]; // TO show code formatting
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

