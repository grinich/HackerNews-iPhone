//
//  HNCommentHeaderItemCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentHeaderItemCell.h"		

#import "HNStyle.h"
#import "HNStory.h"
#import "HNCommentHeaderItem.h"
#import "HNCommentHeaderItemCell.h"
#import "HNAuth.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat kInnterSpacer = 2;

static CGFloat kHPadding = 15;
static CGFloat kVPadding = 15;

//static CGFloat kMargin = 10;
//static CGFloat kSpacing = 8;
//static CGFloat kControlPadding = 8;
//static CGFloat kGroupMargin = 10;
//static CGFloat kDefaultTextViewLines = 5;
//static CGFloat kKeySpacing = 12;
//static CGFloat kKeyWidth = 75;
//static CGFloat kMaxLabelHeight = 2000;
//static CGFloat kDisclosureIndicatorWidth = 23;
//
//static CGFloat kDefaultIconSize = 50;

///////////////////////////////////////////////////////////////////////////////////////////////////


@implementation HNCommentHeaderItemCell

@synthesize storyTitleLabel, subtextLabel, hostURLLabel, cellStory, upvoteButton,
speechBubbleView, fulltextLabel, replyButton;

- (void)dealloc {
	TT_RELEASE_SAFELY(storyTitleLabel);
	TT_RELEASE_SAFELY(subtextLabel);
	TT_RELEASE_SAFELY(hostURLLabel);
	TT_RELEASE_SAFELY(cellStory);
	TT_RELEASE_SAFELY(upvoteButton);
	TT_RELEASE_SAFELY(speechBubbleView);
	TT_RELEASE_SAFELY(fulltextLabel);
	TT_RELEASE_SAFELY(replyButton);

	[super dealloc];
}



+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {

	if ([object isKindOfClass:[HNCommentHeaderItem class]]) {
		HNCommentHeaderItem* tableItem = object;

		HNStory *story = [tableItem story];
		
		
		// If you change these values, make sure to also change in the below method initWithStyle:
		CGFloat accessoryViewWidth = kHPadding + 36.0; 
		CGFloat maxWidth = tableView.width - kHPadding*2 - accessoryViewWidth;
		
		CGSize titleSize = [[story title] sizeWithFont:TTSTYLEVAR(storyTitleFont)
									 constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) 
										 lineBreakMode:UILineBreakModeWordWrap];
		
		CGSize hostURLSize = [[[story url] host] sizeWithFont:TTSTYLEVAR(storyURLFont)
											constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
												lineBreakMode:UILineBreakModeWordWrap];
		
		CGSize subtextSize = [[story subtext] sizeWithFont:TTSTYLEVAR(storySubtextFont)
										 constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
											 lineBreakMode:UILineBreakModeWordWrap];
		

		CGSize fulltextSize = [[story fulltext] sizeWithFont:TTSTYLEVAR(storyFulltextFont)
											   constrainedToSize:CGSizeMake(tableView.width - kHPadding*2, CGFLOAT_MAX)  
												   lineBreakMode:UILineBreakModeWordWrap];

		
		if (fulltextSize.height > 0) {
			return kVPadding*2 + kInnterSpacer + titleSize.height + hostURLSize.height + subtextSize.height + fulltextSize.height + kVPadding*3;
		} else {
			return kVPadding*2 + kInnterSpacer + titleSize.height + hostURLSize.height + subtextSize.height + fulltextSize.height + kVPadding;

		}
		
	} else {
		return 44; // Default. Shouldn't get here.
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_item = nil;
		[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];
		
		
		self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];

		
		
		 // SpeechBubble
		 
		 UIColor* black = RGBCOLOR(158, 163, 172);

		 
		 TTStyle* style = [TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:10 pointLocation:300
																				 pointAngle:270
																				  pointSize:CGSizeMake(20,10)] next:		// pointSize:CGSizeMake(20,10)] next:
						   [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
							[TTSolidBorderStyle styleWithColor:black width:1 next:nil]]];
		 
		 
				
		speechBubbleView = [[TTView alloc] initWithFrame:CGRectZero];
		speechBubbleView.backgroundColor = [UIColor groupTableViewBackgroundColor];
		speechBubbleView.style = style;
		[self.contentView addSubview:speechBubbleView];
		
		
		
		
		// STORY TITLE
		self.storyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.storyTitleLabel.font = TTSTYLEVAR(storyTitleFont);
		self.storyTitleLabel.textAlignment = UITextAlignmentLeft; 
		self.storyTitleLabel.backgroundColor = [UIColor whiteColor];
		self.storyTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.storyTitleLabel.opaque = YES;
		self.storyTitleLabel.numberOfLines = 0;
		[self.contentView addSubview:self.storyTitleLabel];
		
		// HOST URL
		self.hostURLLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.hostURLLabel.font = TTSTYLEVAR(storyURLFont);
		self.hostURLLabel.textAlignment = UITextAlignmentLeft; 
		self.hostURLLabel.textColor = [UIColor darkGrayColor];
		self.hostURLLabel.backgroundColor = [UIColor whiteColor];
		self.hostURLLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.hostURLLabel.opaque = YES;
		self.hostURLLabel.numberOfLines = 0;
		[self.contentView addSubview:self.hostURLLabel];
		
		// XXX points | posted by XXX 
		self.subtextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.subtextLabel.font = TTSTYLEVAR(storySubtextFont);
		self.subtextLabel.textAlignment = UITextAlignmentLeft; 
		self.subtextLabel.backgroundColor = [UIColor whiteColor];
		self.subtextLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.subtextLabel.opaque = YES;
		self.subtextLabel.numberOfLines = 0;
		[self.contentView addSubview:self.subtextLabel];
		
		
		
		// COMMENTS BUTTON
		
		UIImage* accessoryImage = [[UIImage alloc] initWithContentsOfFile:
								   [[NSBundle mainBundle] pathForResource:@"upvote-big" ofType:@"png"]];
		
		self.upvoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.upvoteButton setImage:accessoryImage forState:UIControlStateNormal];
		
		[self.upvoteButton addTarget:self
								 action:@selector(upVoteButtonTapped)
					   forControlEvents:UIControlEventTouchUpInside];
		[accessoryImage release];

		[self.contentView addSubview:self.upvoteButton];
		
		
		// Bottom fulltext
		self.fulltextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.fulltextLabel.font = TTSTYLEVAR(storyFulltextFont);
		self.fulltextLabel.textAlignment = UITextAlignmentLeft; 
		self.fulltextLabel.backgroundColor = [UIColor whiteColor];
		self.fulltextLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.fulltextLabel.opaque = YES;
		self.fulltextLabel.numberOfLines = 0;
		[self.contentView addSubview:self.fulltextLabel];
		
		
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

-(void)upVoteButtonTapped {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"voteUpNotification" object:self ] ;
}

-(void) replyButtonTapped {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"replyButtonNotification" object:self ] ;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// If you change these values, make sure to also change above the below method rowHeightForItem:
	CGFloat accessoryViewWidth = self.upvoteButton.frame.size.height; 
	CGFloat maxWidth = self.contentView.width - kHPadding*2 - accessoryViewWidth;

	
	
	CGSize titleSize = [[cellStory title] sizeWithFont:TTSTYLEVAR(storyTitleFont)
									 constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) 
										 lineBreakMode:UILineBreakModeWordWrap];
	
	
	self.storyTitleLabel.frame = CGRectMake(kHPadding, 
											kVPadding,
											titleSize.width, 
											titleSize.height);
	
	
	CGSize hostURLSize = [[[cellStory url] host] sizeWithFont:TTSTYLEVAR(storyURLFont)
											constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
												lineBreakMode:UILineBreakModeWordWrap];
	
	self.hostURLLabel.frame = CGRectMake(kHPadding,
										 self.storyTitleLabel.frame.origin.y + self.storyTitleLabel.frame.size.height + kInnterSpacer,
										 hostURLSize.width, 
										 hostURLSize.height);
	
	
	CGSize subtextSize = [[cellStory subtext] sizeWithFont:TTSTYLEVAR(storySubtextFont)
										 constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
											 lineBreakMode:UILineBreakModeWordWrap];
	
	self.subtextLabel.frame = CGRectMake(	kHPadding, 
										 self.hostURLLabel.frame.origin.y + self.hostURLLabel.frame.size.height,
										 subtextSize.width, 
										 subtextSize.height);
	
	
	CGSize fulltextSize = [[cellStory fulltext] sizeWithFont:TTSTYLEVAR(storyFulltextFont)
										 constrainedToSize:CGSizeMake(self.contentView.width - kHPadding*2, CGFLOAT_MAX)  
											 lineBreakMode:UILineBreakModeWordWrap];
	
	self.fulltextLabel.frame = CGRectMake(	kHPadding, 
										  self.subtextLabel.frame.origin.y + self.subtextLabel.frame.size.height + kVPadding,
										  fulltextSize.width, 
										  fulltextSize.height);
	
	
	self.upvoteButton.frame = CGRectMake(	self.contentView.frame.size.width - kHPadding - self.upvoteButton.frame.size.width ,
											( self.subtextLabel.frame.origin.y + self.subtextLabel.frame.size.height - self.upvoteButton.frame.size.height ) / 2,
											36.0, 
											40.0);
	
	
	self.replyButton.frame = CGRectMake( self.contentView.frame.size.width - kHPadding*2 - 24, 
										self.contentView.height - kHPadding - 44,
										30, 
										50);
	
	
	self.speechBubbleView.frame = CGRectMake(5, 
											 5,
											 self.contentView.width - kVPadding, 
											 self.contentView.height - kHPadding);
	
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (id)object {
	return _item;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		
		self.cellStory = [object story];
		self.storyTitleLabel.text = [self.cellStory title];
		self.hostURLLabel.text =[[self.cellStory url] host];
		self.subtextLabel.text = [self.cellStory subtext];
		self.fulltextLabel.text = [self.cellStory fulltext];
		self.accessoryType = UITableViewCellAccessoryNone;
		
		if ([[HNAuth sharedHNAuth] loggedin]) {
			if (self.cellStory.voted) {
				self.upvoteButton.enabled = NO;
				self.upvoteButton.hidden = YES;
			} else {
				self.upvoteButton.enabled = YES;
				self.upvoteButton.hidden = NO;
			}

			self.replyButton.enabled = YES;
			self.replyButton.hidden = NO;
		
		} else {
			self.replyButton.enabled = NO;
			self.replyButton.hidden = YES;
			self.upvoteButton.enabled = NO;
			self.upvoteButton.hidden = YES;
		}

		
	}  
}

@end





