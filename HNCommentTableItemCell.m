//
//  HNCommentTableItemCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////

#import "HNCommentTableItemCell.h"
#import "HNCommentTableItem.h"

#import "HNComment.h"
#import "HNStyle.h"

#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>




static CGFloat kIndentationPadding = 10;

static CGFloat kBylineHeight = 40;
static CGFloat kBottomButtonsBuffer = 10;

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 10;
static CGFloat kMargin = 10;
static CGFloat kSpacing = 8;
static CGFloat kControlPadding = 8;
static CGFloat kGroupMargin = 10;
static CGFloat kDefaultTextViewLines = 5;
static CGFloat kKeySpacing = 12;
static CGFloat kKeyWidth = 75;
static CGFloat kMaxLabelHeight = 2000;
static CGFloat kDisclosureIndicatorWidth = 23;
static CGFloat kDefaultIconSize = 50;

///////////////////////////////////////////////////////////////////////////////////////////////////


@implementation HNCommentTableItemCell

@synthesize cellComment, commentTextLabel, byLineLabel, ind_level;
@synthesize upVoteButton, downVoteButton, replyButton;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
		
	
	// TODO : take into account the spacing for commentTextLabel. Shift the other view down one.
	
	HNCommentTableItem *cItem = item;
	CGFloat indent_by = kIndentationPadding * [[cItem.comment indentationLevel] floatValue];
	
	
	TTTableStyledTextItem* textItem = item;
	textItem.text.font = TTSTYLEVAR(font);
	
	CGFloat padding = tableView.style == UITableViewStyleGrouped ? kGroupMargin*2 : 0;
	padding += textItem.padding.left + textItem.padding.right;
	
	
	textItem.text.width = tableView.width - padding - indent_by - kHPadding*2;
	
	return textItem.text.height + textItem.padding.top + textItem.padding.bottom + kVPadding + kBylineHeight + kBottomButtonsBuffer;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		[TTStyleSheet setGlobalStyleSheet:[[HNStyle alloc] init]];

		[self setSelectionStyle:UITableViewCellSelectionStyleNone];


		self.byLineLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		self.byLineLabel.contentMode = UIViewContentModeLeft;
		
		self.byLineLabel.font = TTSTYLEVAR(commentBylineFont);

		[self.contentView addSubview:byLineLabel];
		
		self.commentTextLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		self.commentTextLabel.contentMode = UIViewContentModeLeft;
		self.commentTextLabel.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:self.commentTextLabel];
		
		
		
		
		UIImage* accessoryImage = [[UIImage alloc] initWithContentsOfFile:
								   [[NSBundle mainBundle] pathForResource:@"upvote" ofType:@"png"]];
		
		self.upVoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.upVoteButton setImage:accessoryImage forState:UIControlStateNormal];
		
		[self.upVoteButton addTarget:self
							  action:@selector(vote:)
					   forControlEvents:UIControlEventTouchUpInside];
		self.upVoteButton.tag = 1;
		[self.contentView addSubview:self.upVoteButton];
		
		
		UIImage* downVoteImage = [[UIImage alloc] initWithContentsOfFile:
								   [[NSBundle mainBundle] pathForResource:@"downvote" ofType:@"png"]];
		
		self.downVoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.downVoteButton setImage:downVoteImage forState:UIControlStateNormal];
		
		[self.downVoteButton addTarget:self
								action:@selector(vote:)
					forControlEvents:UIControlEventTouchUpInside];
		self.downVoteButton.tag = 2;
		[self.contentView addSubview:self.downVoteButton];
		

		
		UIImage* replyImage = [[UIImage alloc] initWithContentsOfFile:
								  [[NSBundle mainBundle] pathForResource:@"reply" ofType:@"png"]];
		
		self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.replyButton setImage:replyImage forState:UIControlStateNormal];
		
		[self.replyButton addTarget:self
								action:@selector(replyButtonTapped)
					  forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:self.replyButton];
				
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_MEMBER(commentTextLabel);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	
	CGFloat maxWidth = self.contentView.width - kHPadding*2 ;
	CGFloat maxHeight = self.contentView.height - kVPadding*2;
	
	
	
//	HNCommentTableItem* item = self.object;
	
	CGFloat indent_by = kIndentationPadding * [self.ind_level floatValue];
	

	self.commentTextLabel.frame = CGRectMake(kHPadding + indent_by, 
											 self.byLineLabel.frame.size.height - 3,
											 maxWidth - indent_by, 
											 self.contentView.height - kVPadding - self.byLineLabel.height);
	
	
	
	
	
	self.upVoteButton.frame = CGRectMake(indent_by + kHPadding + 7, 
										 2,
										 50, 
										 50);
	self.upVoteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 23);
	
	self.downVoteButton.frame = CGRectMake(self.contentView.frame.size.width - kHPadding*2 - 28, 
										   2,
										   50, 
										   50);
	self.downVoteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 23);

	
	self.replyButton.frame = CGRectMake( self.contentView.frame.size.width - kHPadding*2 - 24, 
										self.commentTextLabel.frame.size.height,
										30, 
										50);
	
	
	self.byLineLabel.frame  = CGRectMake(kHPadding + indent_by, 
									kVPadding,
									maxWidth - indent_by, 
									kBylineHeight);
	

	
	

	// REDRAW!! 
	
	[self.upVoteButton setNeedsLayout];
	[self.downVoteButton setNeedsLayout];
	[self.replyButton setNeedsLayout];
	
	[self.commentTextLabel setNeedsLayout];
	[self.byLineLabel setNeedsLayout];

	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
				
		HNCommentTableItem *item = object;
		self.ind_level = item.indentationLevel;
		commentTextLabel.text = item.text;
		self.cellComment = item.comment;
				
		if (([self.cellComment.points intValue] != 1) && ([self.cellComment.points intValue] != -1)) {
			self.byLineLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ points</b> by %@ %@", 
														[self.cellComment.points stringValue], 
														self.cellComment.user, 
														self.cellComment.time_ago]];
		} else {
			
			self.byLineLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ point</b> by %@ %@", 
														[self.cellComment.points stringValue], 
														self.cellComment.user, 
														self.cellComment.time_ago]];
			
		}
		
		
		
		
		self.commentTextLabel.contentInset = item.padding;
		self.byLineLabel.contentInset = UIEdgeInsetsMake(10, 40, 0, 10); 
		
		if (self.cellComment.voted) {
			self.upVoteButton.hidden = YES;
			self.upVoteButton.enabled = NO;
			self.downVoteButton.hidden = YES;
			self.downVoteButton.enabled = NO;

		} else {
			self.upVoteButton.hidden = NO;
			self.upVoteButton.enabled = YES;
			self.downVoteButton.hidden = NO;
			self.downVoteButton.enabled = YES;
		}
		
		
		self.accessoryType = UITableViewCellAccessoryNone;
	}  
}


#pragma mark -
#pragma mark Voting

-(void) vote:(UIButton*)sender {
	// TODO : check for login. If no login, push the login controller and make them authenticate first.
	
	if (sender.tag == 1) {
		
		self.cellComment.voted = YES;
		[self.cellComment voteUpWithDelegate:self];

		[(TTTableView*)self.superview reloadData];			

		
		
	} else if (sender.tag == 2) {
		self.cellComment.voted = YES;
		int i = [self.cellComment.points intValue];
		self.cellComment.points = [NSNumber numberWithInt:i - 1];
		
		[(TTTableView*)self.superview reloadData];	
		[self.cellComment voteDownWithDelegate:self];
		
	} else {
		//WFT?
	}
	
}

-(void)finishedVoteUp {
	// Called after the upvote is finished
	// TODD :  some animation to the label !?
}

-(void)finishedVoteDown {
	// Called after the upvote is finished
	// TODD :  some animation to the label !?
}



-(void) replyButtonTapped {
	// Open reply to comment view!
	NSLog(@"reply");

}

@end