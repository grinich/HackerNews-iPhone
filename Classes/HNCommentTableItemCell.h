//
//  HNCommentTableItemCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//



@class HNComment;

@interface HNCommentTableItemCell : TTTableLinkedItemCell {
	
	HNComment	*cellComment;

	NSNumber	*ind_level;
	
	TTStyledTextLabel	* commentTextLabel;	
	
	TTStyledTextLabel		*byLineLabel;
	
	UIButton	*upVoteButton;
	UIButton	*downVoteButton;
	UIButton	*replyButton;

}

@property (nonatomic, retain) HNComment		*cellComment;

@property (nonatomic, retain) TTStyledTextLabel *commentTextLabel;
@property (nonatomic, retain) TTStyledTextLabel	*byLineLabel;
@property (nonatomic, retain) UIButton	*upVoteButton;
@property (nonatomic, retain) UIButton	*downVoteButton;
@property (nonatomic, retain) UIButton	*replyButton;
@property (nonatomic, retain) NSNumber	*ind_level;



@end