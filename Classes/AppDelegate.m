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

@implementation AppDelegate

@synthesize window;

@synthesize splashView;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window makeKeyAndVisible];
	
	
	// OPEN ANIMATION --> Doesn't work  -- Modify/Subclass TTNavigator later to fix this. 
	/*
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	splashView.frame = CGRectMake(-60, -60, 440, 600);
	[UIView commitAnimations];
	*/
	
	[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];

	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;	
	navigator.supportsShakeToReload = YES;
	
	TTURLMap* map = navigator.URLMap;

	// Any URL that doesn't match will fall back on this one, and open in the web browser
	[map from:@"*" toViewController:[TTWebController class]];

	
	[map from:@"tt://home" toSharedViewController:[HNStoryTableViewController class]];
	[map from:@"tt://home/comments/(initWithStory:)" toViewController:[HNCommentsTableViewController class]];
	[map from:@"http://news.ycombinator.com/item?id=(initWithStory:)" toViewController:[HNCommentsTableViewController class]];
	[map from:@"tt://login" toSharedViewController:[LoginViewController class]];
	
	/*
	best	Highest voted recent links.
	active	Most active current discussions.
	bestcomments	Highest voted recent comments.
	noobs	Submissions from new accounts.
	*/
	
	
	NSURL *hnURL = [NSURL URLWithString:@"http://news.ycombinator.com"];
	NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hnURL];
	if ([cookies count] > 0 ) {
		// TODO : check date and make sure that it's not expired
		[[HNAuth sharedHNAuth] setLoggedin:YES];
		
	} else {
		[[HNAuth sharedHNAuth] setLoggedin:NO];
	}
	
	
	if (![navigator restoreViewControllers]) {
		[navigator openURL:@"tt://home" animated:NO];
//		[navigator openURL:@"http://news.ycombinator.com/item?id=486755" animated:NO];	// Large comment set
	}

}


- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
	[splashView release];
}


- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURL:URL.absoluteString animated:NO];
	return YES;
}




@end

