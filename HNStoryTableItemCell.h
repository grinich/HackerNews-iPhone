//
//  HNStoryTableItemCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Three20/Three20.h>

@class HNStory;

@interface HNStoryTableItemCell : TTTableLinkedItemCell {
	
	//   TTTableLinkedItem* _item;	//already done
	HNStory		*cellStory;
	UILabel		*storyTitleLabel;
	UILabel		*subtextLabel;
	UILabel		*hostURLLabel;
	UILabel		*commentsLabel;
	UIButton	*accessoryButton;
}

@property (nonatomic, retain) 	UILabel		*storyTitleLabel;
@property (nonatomic, retain) 	UILabel		*subtextLabel;
@property (nonatomic, retain) 	UILabel		*hostURLLabel;
@property (nonatomic, retain)	HNStory		*cellStory;
@property (nonatomic, retain)	UILabel		*commentsLabel;
@property (nonatomic, retain)	UIButton	*accessoryButton;



@end


