//
//  CommentsViewDataSource.m
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsViewDataSource.h"
#import "HNParser.h"

@class HNComment;


@implementation HNCommentsViewDataSource


+ (HNCommentsViewDataSource*)commentsViewDataSource:(NSInteger)story_id {

	HNParser* sharedParser =  [HNParser sharedHNParser];
	NSArray *commentsArray = [sharedParser parseCommentsForStoryID:story_id];
	
	NSMutableArray *temp = [NSMutableArray new];
	
	NSEnumerator* commentsEnumerator = [commentsArray objectEnumerator];
	HNComment *comment;
	while(comment = [commentsEnumerator nextObject] ) {	
		
		TTStyledText* text = [TTStyledText textFromXHTML:[comment contentsSource]];
		[temp addObject:[TTTableStyledTextItem itemWithText:text]];
	}
	
	
	HNCommentsViewDataSource* dataSource =  [[[HNCommentsViewDataSource alloc] initWithItems:temp] autorelease];

	return dataSource;
}


@end
