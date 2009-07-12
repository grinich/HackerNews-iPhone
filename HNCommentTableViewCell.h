//
//  HNCommentTableViewCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentTableViewCell : UITableViewCell {

	// From comment object
	
	HNComment			*cellComment;
	TTStyledTextLabel	*bodyLabel;
	NSInteger			*cellIndex;

	// points by **** | **** days ago
	UILabel		*titleLabel;
	UILabel		*hostLabel;
	UILabel		*commentsLabel;
	UILabel		*postedByLabel;
	UIButton		*accessoryButton;

}

@property (nonatomic, retain)	HNComment			*cellComment;
@property (nonatomic, retain)	TTStyledTextLabel	*bodyLabel;
@property (nonatomic)			NSInteger			*cellIndex;


+ (CGFloat) heightForCellWithComment:(HNComment *)comment;
/*
+ (CGFloat) getTitleHeightForStory:(HNStory *)story;
+ (CGFloat) getURLHeightForStory:(HNStory *)story;
+ (CGFloat) getPostedByHeightForStory:(HNStory *)story;
*/

-(void) setupData;


- (id)initWithStyle:(UITableViewCellStyle)tableViewCellStyle 
	reuseIdentifier:(NSString *)reuseIdentifier 
		withComment:(HNComment *)comment 
		  withIndex:(NSInteger*)index;


+ (CGFloat) heightForCellWithComment:(HNComment *)comment;

+ (CGFloat) getBodyHeightForComment:(HNComment *)comment;


@end
