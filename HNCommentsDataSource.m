//
//  HNCommentsDataSource.m
//  HackerNews
//
//  Created by Michael Grinich on 7/13/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsDataSource.h"

#import "HNComment.h"
#import "HNCommentTableItem.h"
#import "HNCommentTableItemCell.h"

#import "HNCommentModel.h"

#import "HNCommentHeaderItem.h"
#import "HNCommentHeaderItemCell.h"
#import "HNCommentReplyItem.h"

#import "TempItems.h"

@implementation HNCommentsDataSource


- (id)initWithStory:(NSString *)story_id {
	if (self = [super init]) {
		self.model = [[HNCommentModel alloc] init];
		((HNCommentModel*)self.model).story_id = story_id;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	
	[self.items addObject:[HNCommentHeaderItem itemWithStory:[[TempItems sharedTempItems] tempHNStory]]];
	
	for (HNComment* comment in ((HNCommentModel*)self.model).comments) {
		[self.items addObject:[HNCommentTableItem itemWithComment:comment]];
	}
}


- (NSString*)titleForLoading:(BOOL)refreshing {
	if (refreshing) {
		return TTLocalizedString(@"Updating Comments...", @"");
	} else {
		return TTLocalizedString(@"Loading Comments...", @"");
	}
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {	
	if ([object isKindOfClass:[HNCommentTableItem class]]) {
		return [HNCommentTableItemCell class];
	} else if ([object isKindOfClass:[HNCommentHeaderItem class]]) {
		return [HNCommentHeaderItemCell class];
	} else if ([object isKindOfClass:[HNCommentReplyItem class]]) {
		return [TTTableControlCell class];
	}
	
	else {
		return [super tableView:tableView cellClassForObject:object];
	}
}		



@end
