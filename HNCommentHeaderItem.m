//
//  HNCommentHeaderItem.m
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentHeaderItem.h"

#import "HNStory.h"


@implementation HNCommentHeaderItem

@synthesize story;
@synthesize text = _text;


///////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+ (HNCommentHeaderItem *)itemWithStory:(HNStory *)aStory {
	
	//	TTTableTextItem* item = [[[self alloc] init] autorelease];
	HNCommentHeaderItem* item = [[HNCommentHeaderItem alloc] init];
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
