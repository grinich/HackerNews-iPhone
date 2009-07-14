//
//  HNTableViewDataSource.m
//  Three20
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNTableViewDataSource.h"


@implementation HNTableViewDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableItem class]]) {
		
		if ([object isKindOfClass:[HNStoryTableItem class]]) {
			return [HNStoryTableItemCell class];
		} else if ([object isKindOfClass:[HNCommentTableItem class]]) {
			return [HNCommentTableItemCell class];
		}
	} 
	/*
	else if ([object isKindOfClass:[UIControl class]]
			   || [object isKindOfClass:[UITextView class]]
			   || [object isKindOfClass:[TTTextEditor class]]) {
		return [TTTableControlCell class];
	} else if ([object isKindOfClass:[UIView class]]) {
		return [TTTableFlushViewCell class];
	}
	 */
	
	return [super tableView:(UITableView*)tableView cellClassForObject:(id)object];
}


@end
