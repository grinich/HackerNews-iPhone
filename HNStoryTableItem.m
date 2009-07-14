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
@synthesize text = _text;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+ (HNStoryTableItem *)itemWithStory:(HNStory *)aStory {
	
	//	TTTableTextItem* item = [[[self alloc] init] autorelease];
	HNStoryTableItem* item = [[[HNStoryTableItem alloc] init] autorelease];
	item.story = aStory;

	//item.URL = [[story url] absoluteURL];
	
	item.URL = [NSString stringWithFormat: @"%@", [aStory.url absoluteURL]];
	
	item.text = @"";	// Fails without this!?

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
	TT_RELEASE_MEMBER(story);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding

// TODO Modify this

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
