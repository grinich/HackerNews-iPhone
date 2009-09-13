//
//  HNCommentReplyItem.m
//  HackerNews
//
//  Created by Michael Grinich on 7/20/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentReplyItem.h"
#import "HNStyle.h"
#import "HNComment.h"
#import "ElementParser.h"

@implementation HNCommentReplyItem

@synthesize replyFNID, indentationLevel, replyURL;

- (void)dealloc {
	TT_RELEASE_SAFELY(indentationLevel);
	TT_RELEASE_SAFELY(replyFNID);
	[super dealloc];
}



- (void)layoutSubviews {
	
	CGFloat kIndentationPadding = 10.0;
	CGFloat maxWidth = 300;
	CGFloat indent_by = kIndentationPadding * [self.indentationLevel floatValue];
	
	self.textView.frame = CGRectMake(10 + indent_by, 
									 0, 
									 maxWidth - indent_by, 
									 self.height - 10 );
	self.textView.backgroundColor = TTSTYLEVAR(composeReplyColor);
	
	self.frame = CGRectMake(self.frame.origin.x, 
							self.frame.origin.y, 
							self.frame.size.width, 
							self.frame.size.height + 10);
	
	self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


	

@end