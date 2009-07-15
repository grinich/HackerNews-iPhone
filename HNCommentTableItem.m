//
//  HNCommentTableItem.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentTableItem.h"
#import "HNComment.h"


@implementation HNCommentTableItem

@synthesize text = _text, margin = _margin, padding = _padding;
@synthesize comment, subtext, indentationLevel;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+ (HNCommentTableItem *)itemWithComment:(HNComment *)aComment {
	HNCommentTableItem *item = [HNCommentTableItem new];
	item.comment = aComment;
	item.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"%@", aComment.contentsSource]];	
	
	if ([aComment.points intValue] > 1) {
		item.subtext = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ points</b> by %@ %@", 
													[aComment.points stringValue], 
													aComment.user, 
													aComment.time_ago]];
	} else{
		
		item.subtext = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ point</b> by %@ %@", 
													[aComment.points stringValue], 
													aComment.user, 
													aComment.time_ago]];
		
	}
	
	
	item.indentationLevel = aComment.indentationLevel;
	//item.URL = @"http://www.google.com";	// TODO: Specify this for adding a comment!
	
	return item;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		comment = nil;
		_text = nil;
		_margin = UIEdgeInsetsZero;
		_padding = UIEdgeInsetsMake(5, 10, 10, 10);    
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_MEMBER(_text);
	TT_RELEASE_MEMBER(comment);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding

- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.text = [decoder decodeObjectForKey:@"text"];
		self.comment = [decoder decodeObjectForKey:@"comment"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.text) {
		[encoder encodeObject:self.text forKey:@"text"];		
		[encoder encodeObject:self.comment forKey:@"comment"];

	}
}
@end