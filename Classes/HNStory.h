//
//  HNStory.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNStory : NSObject {
	
	NSString*	title;
	NSNumber*	points;
	NSString*	user;
	NSURL*		url;
	NSString*	time_ago;
	NSNumber*	comments_count;
	
	BOOL		nocomments;
	BOOL		internal_story;
	NSNumber*	story_id;
	NSString*	subtext;

}

@property (nonatomic, retain) 	NSString*	title;
@property (nonatomic, retain) 	NSNumber*	points;
@property (nonatomic, retain) 	NSString*	user;
@property (nonatomic, retain) 	NSURL*		url;
@property (nonatomic, retain) 	NSString*	time_ago;
@property (nonatomic, retain) 	NSNumber*	comments_count;
@property (nonatomic, retain) 	NSNumber*	story_id;
@property						BOOL		nocomments;
@property						BOOL		internal_story;

@property(nonatomic,readonly) NSString *subtext;

@end
