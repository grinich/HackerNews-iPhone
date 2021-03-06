//
//  HNStoryTableItem.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableItem.h"

#import "HNStory.h"

@implementation HNStoryTableItem

@synthesize story;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+ (HNStoryTableItem *)itemWithStory:(HNStory *)aStory {
	
	HNStoryTableItem* item = [[HNStoryTableItem alloc] init];

	[item setStory: aStory];

	// Handle the URL opening in the delegate method.
	//item.URL = [[story url] absoluteURL];
		
	return item;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		story = nil;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding


- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.story = [decoder decodeObjectForKey:@"story"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.story) {
		[encoder encodeObject:self.story forKey:@"story"];
	}
}

@end
