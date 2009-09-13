//
//  HNStory.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"



@interface HNStory : NSObject {
	
	NSString*	title;
	NSNumber*	points;
	NSString*	user;
	NSURL*		url;
	NSString*	time_ago;
	NSNumber*	comments_count;
	
	BOOL		nocomments;
	NSNumber*	story_id;
	NSString*	subtext;
	NSString*	fulltext;
	NSString*	voteup_url;
	NSString*	reply_url;
	NSString*	replyFNID;
	BOOL		voted;

}

@property (nonatomic, retain)	NSString*	fulltext;
@property (nonatomic, retain) 	NSString*	title;
@property (nonatomic, retain) 	NSNumber*	points;
@property (nonatomic, retain) 	NSString*	user;
@property (nonatomic, retain) 	NSURL*		url;
@property (nonatomic, retain) 	NSString*	time_ago;
@property (nonatomic, retain) 	NSNumber*	comments_count;
@property (nonatomic, retain) 	NSNumber*	story_id;
@property						BOOL		nocomments;
@property (nonatomic)			BOOL	voted;
@property(nonatomic,readonly) NSString *subtext;
@property(nonatomic,retain) NSString*	voteup_url;
@property(nonatomic,retain) NSString*	reply_url;
@property(nonatomic,retain) NSString*	replyFNID;


-(void) voteUpWithDelegate:(id)delegate;

@end
