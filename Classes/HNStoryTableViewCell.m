//
//  HNStoryTableViewCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/8/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewCell.h"


@implementation HNStoryTableViewCell

// we need to synthesize the two labels
@synthesize titleLabel, hostLabel, postedByLabel, commentsLabel, accessoryButton;

@synthesize cellIndex;
@synthesize cellStory;


- (id)initWithStyle:(UITableViewCellStyle)tableViewCellStyle 
	reuseIdentifier:(NSString *)reuseIdentifier 
		  withStory:(HNStory*)story 
	  withIndex:(NSInteger*)index

{
	if (self = [super initWithStyle:tableViewCellStyle reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		cellStory = story;
		cellIndex = (NSInteger* )index;
		
		// we need a view to place our labels on.
		UIView *myContentView = self.contentView;
				
		
		// init the label
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		self.titleLabel.font = [[UIFont fontWithName:@"Helvetica-Bold" size:14.0] autorelease];
		self.titleLabel.textAlignment = UITextAlignmentLeft; 
		self.titleLabel.backgroundColor = [UIColor whiteColor];
		self.titleLabel.numberOfLines = 0;
		self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;		
		self.titleLabel.opaque = YES;
		
		[myContentView addSubview:self.titleLabel];
		[self.titleLabel release];
		
		self.hostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.hostLabel.font = [[UIFont fontWithName:@"Helvetica" size:10.0] autorelease];
		self.hostLabel.textAlignment = UITextAlignmentLeft; 
		self.hostLabel.backgroundColor = [UIColor whiteColor];
		self.hostLabel.textColor = [UIColor darkGrayColor];
		self.hostLabel.numberOfLines = 0;
		self.hostLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.hostLabel.opaque = YES;
		
		[myContentView addSubview:self.hostLabel];
		[self.hostLabel release];
		
		self.postedByLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.postedByLabel.font = [[UIFont fontWithName:@"Helvetica-Bold" size:10.0] autorelease];
		self.postedByLabel.textAlignment = UITextAlignmentLeft; 
		self.postedByLabel.backgroundColor = [UIColor whiteColor];
		self.postedByLabel.textColor = [UIColor darkGrayColor];
		self.postedByLabel.numberOfLines = 0;
		self.postedByLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.postedByLabel.opaque = YES;
		
		[myContentView addSubview:self.postedByLabel];
		[self.postedByLabel release];
		
		// For now. Replace with comments accessory disclosure indicator
		
			
		
		// self.tableCell.accessoryAction = @selector( myAction: );
		// self.tableCell.target = self;
		
		NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"comment-button" ofType:@"png"];
		 
		UIImage* accessoryImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
		accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[accessoryButton setImage:accessoryImage forState:UIControlStateNormal];
		
		[accessoryButton addTarget:self.superview  
							action:@selector(commentsButtonTapped:)
				  forControlEvents:UIControlEventTouchUpInside];
		
		[accessoryButton setTag:(int)cellIndex];
		
		
		commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, -1.0, 26.0, 33.0)];
		commentsLabel.font = [[UIFont fontWithName:@"Marker Felt" size:14.0] autorelease];
		//commentsLabel.font = [[UIFont fontWithName:@"Helvetica-Bold" size:14.0] autorelease];

		commentsLabel.textColor = [UIColor whiteColor];
		commentsLabel.textAlignment = UITextAlignmentCenter;
		commentsLabel.backgroundColor = [UIColor clearColor];
		
		[accessoryButton addSubview:commentsLabel];

		
		if (![story nocomments]) {
			[self addSubview:accessoryButton];
		}
				
		
		[self setupData];
	
	}
	return self;
}

-(void) setupData {
	// Set cell data
	
	self.titleLabel.text = [cellStory title];
	self.hostLabel.text = [[cellStory url] host];
	self.postedByLabel.text = [NSString stringWithFormat:@"%@ points | posted by %@ %@", [[cellStory points] stringValue], [cellStory user], [cellStory time_ago]];
	self.commentsLabel.text = [[cellStory comments_count] stringValue];

}


- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		
		CGFloat left = boundsX + 10.0;
		CGFloat topBuff = 5;
		

		self.titleLabel.frame = CGRectMake(left, 
										   topBuff, 
										   250, 
										   [HNStoryTableViewCell getTitleHeightForStory:cellStory]);
		
		self.hostLabel.frame = CGRectMake(
										  left, 
										  self.titleLabel.frame.size.height + 
											topBuff, 
										  260.0, 
										  [HNStoryTableViewCell getURLHeightForStory:cellStory]);
		
		self.postedByLabel.frame = CGRectMake(
											  left,
											  self.titleLabel.frame.size.height +
												self.hostLabel.frame.size.height + 
												topBuff, 
											  250, 
											  [HNStoryTableViewCell getPostedByHeightForStory:cellStory]);
		
		self.accessoryButton.frame = CGRectMake(
												self.contentView.frame.size.width - left - self.accessoryButton.frame.size.width ,
												(self.titleLabel.frame.size.height +
												 self.hostLabel.frame.size.height + 
												 self.postedByLabel.frame.size.height +
												 self.accessoryButton.frame.size.height ) / 2 - (self.accessoryButton.frame.size.height - topBuff) ,
												36.0, 
												40.0);

		
	}
	
	
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	if (selected) {
		self.titleLabel.textColor = [UIColor darkGrayColor];
	}
	

	// Configure the view for the selected state


	
}


- (void)dealloc {
    [super dealloc];
}




#pragma mark -
#pragma mark Heights for the cell elements

+ (CGFloat) heightForCellWithStory:(HNStory *)story  {
	
	CGFloat cellHeight =	
	[self getTitleHeightForStory:story] + 
	[self getURLHeightForStory:story] +
	[self getPostedByHeightForStory:story] ;	
	
	if  ( cellHeight + 10 > 43) {
		return cellHeight + 10.0;
	} else {
		return 44.0;
	}
	
}


+ (CGFloat) getTitleHeightForStory:(HNStory *)story {
	CGSize aSize; 
	NSString *string = [story title];
	aSize = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
					constrainedToSize:CGSizeMake(280.0, 1000.0)  
						lineBreakMode:UILineBreakModeWordWrap];  
	
	return aSize.height;

}

+ (CGFloat) getURLHeightForStory:(HNStory *)story {
	CGSize aSize; 
	NSString *string = [[story url] host];
	aSize = [string sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0] 
					constrainedToSize:CGSizeMake(2800.0, 1000.0)  
						lineBreakMode:UILineBreakModeWordWrap];  
	
	return aSize.height;
}

+ (CGFloat) getPostedByHeightForStory:(HNStory *)story  {
	CGSize aSize; 
	NSString *string = [NSString stringWithFormat:@"%@ points | posted by %@ %@", [[story points] stringValue], [story user], [story time_ago]];
	aSize = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]
					constrainedToSize:CGSizeMake(280.0, 1000.0)  
						lineBreakMode:UILineBreakModeWordWrap];  
	
	return aSize.height;
}

@end
