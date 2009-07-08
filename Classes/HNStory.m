//
//  HNStory.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStory.h"


@implementation HNStory

@synthesize title;
@synthesize points;
@synthesize user;
@synthesize url;
@synthesize time_ago;
@synthesize comments_count;
@synthesize nocomments;
@synthesize story_id;

- (id)init
{
    self = [super init];
    if (self) {
        nocomments = NO; // default
    }
    return self;
}

- (void) dealloc {
	[title	release];
	[points release];
	[user release];
	[time_ago release];
	[comments_count release];
}

@end
