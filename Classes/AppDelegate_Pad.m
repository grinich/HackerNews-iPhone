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
#import "HNWebController.h"
#import "BlankViewController.h"


@implementation AppDelegate_Pad


@synthesize window;



#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	[window makeKeyAndVisible];
	[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];
	
	
	TTURLMap *map;

	
	TTSplitNavigator *splitNavigator = [TTSplitNavigator splitNavigator];
	map = splitNavigator.URLMap;
	splitNavigator.popoverTitle = @"Catalog";
	splitNavigator.rightNavigator.supportsShakeToReload = YES;
	splitNavigator.leftNavigator.persistenceMode = TTNavigatorPersistenceModeNone;
	splitNavigator.rightNavigator.persistenceMode = TTNavigatorPersistenceModeAll;


	

	[map from:@"*" toModalViewController:[HNWebController class] presentationStyle:UIModalPresentationPageSheet];
	
	[map from:@"tt://home/comments/(initWithStory:)" toEmptyHistoryViewController:[HNCommentsTableViewController class]
  inSplitView:TTSplitNavigationTargetLeft];
	
	[map from:@"http://news.ycombinator.com/item?id=(initWithStory:)" toEmptyHistoryViewController:[HNCommentsTableViewController class]
	 inSplitView:TTSplitNavigationTargetRight];

    [map from:@"tt://home" toEmptyHistoryViewController:[HNStoryTableViewController class] inSplitView:TTSplitNavigationTargetLeft];

	
	
	// Restore ViewControllers
	if (TTIsPad()) {
		[[TTSplitNavigator splitNavigator] restoreViewControllersWithDefaultURLs: [NSArray arrayWithObjects: @"tt://home", @"tt://blank", nil]];
	} else {
		TTNavigator *navigator = [TTNavigator navigator];
		if (![navigator restoreViewControllers]) {
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://home"]];
		}
	}

	
	
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
