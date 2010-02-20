//
//  HNCommentsTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "HNCommentReplyItem.h"

@class HNComment;

@interface HNCommentsTableViewController :  TTTableViewController <TTPostControllerDelegate> {
	
	NSString		*storyID;
	HNCommentReplyItem *replyCommentItem;
}

@property (nonatomic, retain)	NSString	*storyID;
@property (nonatomic,retain) HNCommentReplyItem *replyCommentItem;

- (id)initWithStory:(NSString *)storyIN;


@end
