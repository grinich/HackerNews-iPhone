//
//  HNCommentHeaderItemCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@class HNStory;


@interface HNCommentHeaderItemCell : TTTableLinkedItemCell {

	//   TTTableLinkedItem* _item;	//already done
	HNStory		*cellStory;
	UILabel		*storyTitleLabel;
	UILabel		*subtextLabel;
	UILabel		*hostURLLabel;
	UIButton	*accessoryButton;
	
	TTView* speechBubbleView ;
}

@property (nonatomic, retain) 	UILabel		*storyTitleLabel;
@property (nonatomic, retain) 	UILabel		*subtextLabel;
@property (nonatomic, retain) 	UILabel		*hostURLLabel;
@property (nonatomic, retain)	HNStory		*cellStory;
@property (nonatomic, retain)	UIButton	*accessoryButton;
@property (nonatomic, retain) TTView* speechBubbleView;


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item;


@end
