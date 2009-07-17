//
//  HNStoryDataSource.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryDataSource.h"
#import "HNStory.h"
#import "HNStoryModel.h"

#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"


@implementation HNStoryDataSource


- (id)init {
	if (self = [super init]) {
		self.model = [[HNStoryModel alloc] init];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (void)willAppearInTableView:(UITableView*)tableView {
	for (HNStory* story in ((HNStoryModel *)self.model).stories) {
		[self.items addObject:[HNStoryTableItem itemWithStory:story]];
	}
}



- (NSString*)titleForLoading:(BOOL)reloading {
	if (reloading) {
		return TTLocalizedString(@"Updating stories...", @"");
	} else {
		return TTLocalizedString(@"Loading stories...", @"");
	}
}

- (NSString*)titleForError:(NSError*)error {
	return TTLocalizedString(@"Error", @"");
}

- (NSString*)subtitleForError:(NSError*)error {
	return TTLocalizedString(@"Sorry, an error has occurred.", @"");
}



- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[HNStoryTableItem class]]) {
		return [HNStoryTableItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}



@end
