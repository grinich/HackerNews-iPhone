//
//  HNStoryTableViewCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/8/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNStory;

@interface HNStoryTableViewCell : UITableViewCell {

	UILabel		*titleLabel;
	UILabel		*hostLabel;
	UILabel		*commentsLabel;
	UILabel		*postedByLabel;
	UIButton		*accessoryButton;
	NSInteger	*cellIndex;
	HNStory		*cellStory;
	
	
}

@property (nonatomic, retain)	UILabel		*titleLabel;
@property (nonatomic, retain)	UILabel		*hostLabel;
@property (nonatomic, retain)	UILabel		*postedByLabel;
@property (nonatomic, retain)	UILabel		*commentsLabel;
@property (nonatomic, retain)	UIButton	*accessoryButton;
@property (nonatomic)			NSInteger	*cellIndex;
@property (nonatomic, assign)	HNStory		*cellStory;

- (id)initWithStyle:(UITableViewCellStyle)tableViewCellStyle 
	reuseIdentifier:(NSString *)reuseIdentifier 
		  withStory:(HNStory*)story 
		  withIndex:(NSInteger*)index;


+ (CGFloat) heightForCellWithStory:(HNStory *)story;

+ (CGFloat) getTitleHeightForStory:(HNStory *)story;
+ (CGFloat) getURLHeightForStory:(HNStory *)story;
+ (CGFloat) getPostedByHeightForStory:(HNStory *)story;


-(void) setupData;

@end
