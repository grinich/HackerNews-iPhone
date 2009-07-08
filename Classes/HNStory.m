//
//  HNStory.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStory.h"


@implementation HNStory



- (void) dealloc {
	[title	release];
	[points release];
	[user release];
	[time_ago release];
	[comments_count release];
}

@end
