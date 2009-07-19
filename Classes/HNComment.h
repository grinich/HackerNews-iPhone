//
//  HNComment.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNComment : NSObject {

	NSString*	text;
	NSNumber*	points;
	NSString*	user;
	NSURL*		url;
	NSURL*		reply_url;
	NSString*	time_ago;
	NSNumber*	indentationLevel;
	NSString*	contentsSource;
	
	NSString*	upvotelink;
	NSString*	downvotelink;

	BOOL  voted;
	BOOL  downvoted;
	id *delegate;
	
}
@property (nonatomic, retain)	NSString*	contentsSource;
@property (nonatomic, retain)	NSString*	text;
@property (nonatomic, retain)	NSNumber*	points;
@property (nonatomic, retain)	NSString*	user;
@property (nonatomic, retain)	NSURL*		url;
@property (nonatomic, retain)	NSURL*		reply_url;
@property (nonatomic, retain)	NSString*	time_ago;
@property (nonatomic, retain)			NSNumber*	indentationLevel;

@property (nonatomic, retain)	NSString*	upvotelink;
@property (nonatomic, retain)	NSString*	downvotelink;

@property (nonatomic)			BOOL	voted;
@property (nonatomic)			BOOL	downvoted;

-(BOOL) voteUpWithDelegate:(id)commentDelegate;
-(BOOL) voteDownWithDelegate:(id)commentDelegate;
@property(nonatomic,retain) id *delegate;


@end
