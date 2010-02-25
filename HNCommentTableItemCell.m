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
#import "HNAuth.h"
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>



static CGFloat kIndentationPadding = 10.0;

static CGFloat kBylineHeight = 40;
static CGFloat kBottomButtonsBuffer = 10;

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 10;
//static CGFloat kMargin = 10;
//static CGFloat kSpacing = 8;
//static CGFloat kControlPadding = 8;
static CGFloat kGroupMargin = 10;
//static CGFloat kDefaultTextViewLines = 5;
//static CGFloat kKeySpacing = 12;
//static CGFloat kKeyWidth = 75;
//static CGFloat kMaxLabelHeight = 2000;
//static CGFloat kDisclosureIndicatorWidth = 23;
//static CGFloat kDefaultIconSize = 50;

///////////////////////////////////////////////////////////////////////////////////////////////////


@implementation HNCommentTableItemCell

@synthesize cellComment, commentTextLabel, byLineLabel, ind_level,  
upVoteButton, downVoteButton, replyButton;


- (void)dealloc {
	TT_RELEASE_SAFELY(cellComment);
	TT_RELEASE_SAFELY(commentTextLabel);
	TT_RELEASE_SAFELY(byLineLabel);
	TT_RELEASE_SAFELY(ind_level);
	TT_RELEASE_SAFELY(upVoteButton);
	TT_RELEASE_SAFELY(downVoteButton);
	TT_RELEASE_SAFELY(replyButton);
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// class public
		
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {

	
	// TODO : take into account the spacing for commentTextLabel. Shift the other view down one.
	
	HNCommentTableItem *cItem = object;
	CGFloat indent_by = kIndentationPadding * [[cItem.comment indentationLevel] floatValue];
	
	
	TTTableStyledTextItem* textItem = object;
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
		[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];

		[self setSelectionStyle:UITableViewCellSelectionStyleNone];

		
		// Byline

		self.byLineLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		self.byLineLabel.contentMode = UIViewContentModeLeft;
		self.byLineLabel.backgroundColor = TTSTYLEVAR(standardCommentBackgroundColor);
		self.byLineLabel.font = TTSTYLEVAR(commentBylineFont);
		self.byLineLabel.opaque = YES;
		[self.contentView addSubview:byLineLabel];

		
		
		// Main text
		
		self.commentTextLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		self.commentTextLabel.contentMode = UIViewContentModeLeft;
		self.commentTextLabel.backgroundColor = TTSTYLEVAR(standardCommentBackgroundColor);;
		self.commentTextLabel.opaque = YES;
		[self.contentView addSubview:self.commentTextLabel];
		
		

		/*
		 // TODO : Delete functionality
		if (YES) {
			UIImage* downVoteImage = [[UIImage alloc] initWithContentsOfFile:
									  [[NSBundle mainBundle] pathForResource:@"trash" ofType:@"png"]];
			
			self.downVoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[self.downVoteButton setImage:downVoteImage forState:UIControlStateNormal];
			
			[self.downVoteButton addTarget:self
									action:@selector(deleteComment:)
						  forControlEvents:UIControlEventTouchUpInside];
			self.downVoteButton.tag = 2;
			[self.contentView addSubview:self.downVoteButton];
		
		
		
		} else { */
		
		
		
		
		// Downvotes
		
		UIImage* downVoteImage = [[UIImage alloc] initWithContentsOfFile:
								  [[NSBundle mainBundle] pathForResource:@"downvote" ofType:@"png"]];
		
		self.downVoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.downVoteButton setImage:downVoteImage forState:UIControlStateNormal];
		[downVoteImage release];
		
		[self.downVoteButton addTarget:self
								action:@selector(vote:)
					  forControlEvents:UIControlEventTouchUpInside];
		self.downVoteButton.tag = 2;
		[self.contentView addSubview:self.downVoteButton];
		
		
		
		
		// Upvote
		
		UIImage* upVoteImage = [[UIImage alloc] initWithContentsOfFile:
								   [[NSBundle mainBundle] pathForResource:@"upvote" ofType:@"png"]];
		
		self.upVoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.upVoteButton setImage:upVoteImage forState:UIControlStateNormal];
		[upVoteImage release];
		
		[self.upVoteButton addTarget:self
							  action:@selector(vote:)
					forControlEvents:UIControlEventTouchUpInside];
		self.upVoteButton.tag = 1;
		[self.contentView addSubview:self.upVoteButton];
		
		
		
		
		// Reply
		
		UIImage* replyImage = [[UIImage alloc] initWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"reply" ofType:@"png"]];
		
		self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.replyButton setImage:replyImage forState:UIControlStateNormal];
		[replyImage release];
		
		
		
		[self.replyButton addTarget:self
							 action:@selector(replyButtonTapped) 
				   forControlEvents:UIControlEventTouchUpInside];
		
		
		[self.contentView addSubview:self.replyButton];
			
	}
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat maxWidth = self.contentView.width - kHPadding*2 ;
	//	CGFloat maxHeight = self.contentView.height - kVPadding*2;
	
//	HNCommentTableItem* item = self.object;
	
	CGFloat indent_by = kIndentationPadding * [self.ind_level floatValue];
	

	self.commentTextLabel.frame = CGRectMake(kHPadding + indent_by, 
											 self.byLineLabel.frame.size.height - 3,
											 maxWidth - indent_by, 
											 self.contentView.height - kVPadding - self.byLineLabel.height);
	

	
	
	// UPVOTE //

	self.upVoteButton.frame = CGRectMake(indent_by + kHPadding + 7, 
										 2,
										 50, 
										 50);
	self.upVoteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 23);
	
	
	
	
	// DOWNVOTE //

	self.downVoteButton.frame = CGRectMake(self.contentView.frame.size.width - kHPadding*2 - 28, 
										   2,
										   50, 
										   50);
	self.downVoteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 23);

	
	

	// REPLY //
	
	
	
	self.replyButton.frame = CGRectMake( self.contentView.frame.size.width - kHPadding*2 - 24, 
										self.commentTextLabel.frame.size.height,
										30, 
										50);
	
	
	
	// BYLINE //

	
	
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
		
		if ([[HNAuth sharedHNAuth] loggedin]) {
			
			if (!self.cellComment.voted) {
				self.upVoteButton.hidden = NO;
				self.upVoteButton.enabled = YES;
				
				if (self.cellComment.isDownvote) {
					self.downVoteButton.hidden = NO;
					self.downVoteButton.enabled = YES;
				} else {
					self.downVoteButton.hidden = YES;
					self.downVoteButton.enabled = NO;
				}
			} else {
				self.upVoteButton.hidden = YES;
				self.upVoteButton.enabled = NO;

				
				self.downVoteButton.hidden = YES;
				self.downVoteButton.enabled = NO;
			}

			
			if (self.cellComment.replyEnabled) {
				self.replyButton.hidden = NO;
				self.replyButton.enabled = YES;
			} else {
				self.replyButton.hidden = YES;
				self.replyButton.enabled = NO;
			}

			
		} else {
			self.upVoteButton.hidden = YES;
			self.upVoteButton.enabled = NO;
			self.downVoteButton.hidden = YES;
			self.downVoteButton.enabled = NO;
			self.replyButton.hidden = YES;
			self.replyButton.enabled = NO;
		}

		
		// TODO : if we're the use, we should add the orange asterisk.
		
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] 
			 isEqualToString:self.cellComment.user]) {
			self.byLineLabel.backgroundColor = [UIColor whiteColor];
			self.commentTextLabel.backgroundColor = [UIColor whiteColor];

		} else {
			self.byLineLabel.backgroundColor = TTSTYLEVAR(standardCommentBackgroundColor);
			self.commentTextLabel.backgroundColor = TTSTYLEVAR(standardCommentBackgroundColor);

		}
		
		
		self.accessoryType = UITableViewCellAccessoryNone;
	}  
}


#pragma mark -
#pragma mark Buttons

-(void) vote:(UIButton*)sender {
	// TODO : check for login. If no login, push the login controller and make them authenticate first.
	
	if (sender.tag == 1) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"voteUpNotification" object:self ] ;

	} else {
		assert(sender.tag == 2);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"voteDownNotification" object:self ] ;
	}
}

-(void)deleteComment:(UIButton*)sender {
	DLog(@"Delete comment!");
}


#pragma mark Reply Button

-(void) replyButtonTapped {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"replyButtonNotification" object:self ] ;
}

@end