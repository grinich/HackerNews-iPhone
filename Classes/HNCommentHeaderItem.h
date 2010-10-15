//
//  HNCommentHeaderItem.h
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HNStory;

@interface HNCommentHeaderItem : TTTableLinkedItem {
	HNStory *story;
	NSString* _text;
}

@property (nonatomic,copy)		NSString* text;
@property (nonatomic,retain)	HNStory *story;

+ (HNCommentHeaderItem *)itemWithStory:(HNStory *)aStory;


@end
