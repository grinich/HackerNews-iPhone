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
	NSString*	time_ago;
	NSNumber*	comments_count;

}

@end
