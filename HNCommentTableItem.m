//
//  HNCommentTableItem.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentTableItem.h"


@implementation HNCommentTableItem

@synthesize comment = _comment, subtext = _subtext, item = _item;

+ (HNCommentTableItem *)itemWithComment:(HNComment*)aComment {

	HNCommentTableItem* item = [[[self alloc] init] autorelease];
	
	/*
	
	// This is the comment data for the views
	item.text = aComment.text;
	item.subtext = [NSString stringWithFormat:@"%@ points | posted by %@ %@", 
					 [[aComment points] stringValue], [aComment user], [aComment time_ago]];

	 */
	 
	return item;
}


@end
