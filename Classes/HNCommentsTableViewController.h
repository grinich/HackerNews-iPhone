//
//  HNCommentsTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HNComment;

@interface HNCommentsTableViewController :  TTTableViewController <TTPostControllerDelegate> {
	
	NSString		*storyID;
}

@property (nonatomic, retain)	NSString	*storyID;

- (id)initWithStory:(NSString *)storyIN;


@end
