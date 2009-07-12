//
//  HNCommentTableItem.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentTableItem : TTTableItem {

	TTTableViewItem* _item;

	HNComment *_comment;
	NSString *_subtext;
}

+ (HNCommentTableItem *)itemWithComment:(HNComment*)aComment;

@property(nonatomic,copy) HNComment *comment;
@property(nonatomic,copy) NSString *subtext;


@property(nonatomic,readonly) TTTableViewItem* item;

@end
