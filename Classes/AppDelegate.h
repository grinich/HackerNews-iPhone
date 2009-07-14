//
//  AppDelegate.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright Michael Grinich 2009. All rights reserved.
//
#import <Three20/Three20.h>

@class HNStoryTableViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

	
    UIWindow *window;
		
	UIImageView *splashView;
}


- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;


@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) IBOutlet UIWindow *window;


@end

