//
//  HNCommentsTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"


@class HNComment;

@interface HNCommentsTableViewController :  TTTableViewController {
	
	NSString		*_storyID;
}

@property (nonatomic, retain)	NSString	*storyID;


- (id)initWithStory:(NSString *)storyIN;


@end
