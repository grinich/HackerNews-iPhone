//
//  HNComment.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class HNCommentsTableViewController;

@interface HNComment : NSObject <TTURLRequestDelegate> {

	NSString*	text;
	NSNumber*	points;
	NSString*	user;
	NSURL*		url;
	NSString*		reply_url;
	NSString*	time_ago;
	NSNumber*	indentationLevel;
	NSString*	contentsSource;
	
	NSString*	upvotelink;
	NSString*	downvotelink;

	BOOL	replyEnabled;
	BOOL	voted;
	HNCommentsTableViewController *delegate;
	BOOL	deletable;
	
}
@property (nonatomic, retain)	NSString*	contentsSource;
@property (nonatomic, retain)	NSString*	text;
@property (nonatomic, retain)	NSNumber*	points;
@property (nonatomic, retain)	NSString*	user;
@property (nonatomic, retain)	NSURL*		url;
@property (nonatomic, retain)	NSString*		reply_url;
@property (nonatomic, retain)	NSString*	time_ago;
@property (nonatomic, retain)			NSNumber*	indentationLevel;

@property (nonatomic, retain)	NSString*	upvotelink;
@property (nonatomic, retain)	NSString*	downvotelink;

@property (nonatomic)			BOOL	voted;

@property (nonatomic)			BOOL	deletable;
@property (nonatomic)			BOOL	replyEnabled;


-(void) voteUpWithDelegate:(id)commentDelegate;
-(void) voteDownWithDelegate:(id)commentDelegate;
@property(nonatomic,retain) HNCommentsTableViewController *delegate;


@end
