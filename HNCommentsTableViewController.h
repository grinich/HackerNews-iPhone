//
//  HNCommentsTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"


@class HNStory, HNComment;

@interface HNCommentsTableViewController :  TTTableViewController {
	
	
	HNStory		*story;
	NSArray		*commentsArray;
}

@property (nonatomic, retain) 	HNStory		*story;
@property (nonatomic, retain)	NSArray		*commentsArray;


@end
