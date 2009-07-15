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

@synthesize storyTitleLabel, subtextLabel, hostURLLabel, cellStory, accessoryButton;
@synthesize speechBubbleView;



+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
	HNCommentHeaderItem* tableItem = item;
	if ([item isKindOfClass:[HNCommentHeaderItem class]]) {
		
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
		
		return kVPadding*2 + kInnterSpacer + titleSize.height + hostURLSize.height + subtextSize.height + 10;
		
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
		
		self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.accessoryButton setImage:accessoryImage forState:UIControlStateNormal];
		
		[self.accessoryButton addTarget:self
								 action:@selector(upVoteButtonTapped)
					   forControlEvents:UIControlEventTouchUpInside];
		

		[self.contentView addSubview:self.accessoryButton];
		
		
	}
	return self;
}

-(void)upVoteButtonTapped {
	
	TTOpenURL([NSString stringWithFormat:@"tt://home/comments/%@", self.cellStory.story_id]);
}



- (void)dealloc {
	TT_RELEASE_MEMBER(self.subtextLabel);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// If you change these values, make sure to also change above the below method rowHeightForItem:
	CGFloat accessoryViewWidth = self.accessoryButton.frame.size.height; 
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
	
	
	self.accessoryButton.frame = CGRectMake(	self.contentView.frame.size.width - kHPadding - self.accessoryButton.frame.size.width ,
											( self.contentView.frame.size.height - self.accessoryButton.frame.size.height ) / 2,
											36.0, 
											40.0);
	
	
	self.speechBubbleView.frame = CGRectMake(5, 
											 5,
											 self.contentView.width - 10, 
											 self.contentView.height - 10);
	
	
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
		self.accessoryType = UITableViewCellAccessoryNone;
		
	}  
}

@end





