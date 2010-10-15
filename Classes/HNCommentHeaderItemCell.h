//
//  HNCommentHeaderItemCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNStory;


@interface HNCommentHeaderItemCell : TTTableLinkedItemCell {

	//   TTTableLinkedItem* _item;	//already done
	HNStory		*cellStory;
	UILabel		*storyTitleLabel;
	UILabel		*subtextLabel;
	UILabel		*hostURLLabel;
	UIButton	*upvoteButton;
	
	UILabel		*fulltextLabel;
	UIButton	*replyButton;

	TTView* speechBubbleView ;
}

@property (nonatomic, retain) 	UILabel		*storyTitleLabel;
@property (nonatomic, retain) 	UILabel		*subtextLabel;
@property (nonatomic, retain) 	UILabel		*hostURLLabel;
@property (nonatomic,retain)	UILabel		*fulltextLabel;
@property (nonatomic, retain)	HNStory		*cellStory;
@property (nonatomic, retain)	UIButton	*upvoteButton;
@property (nonatomic, retain) UIButton	*replyButton;

@property (nonatomic, retain) TTView* speechBubbleView;




@end
