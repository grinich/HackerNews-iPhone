//
//  HNStoryTableItem.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "Three20/Three20.h"

@class HNStory;

@interface HNStoryTableItem : TTTableTextItem {
	HNStory *story;

}

@property (nonatomic,retain)	HNStory *story;

+ (HNStoryTableItem *)itemWithStory:(HNStory *)aStory;


@end


