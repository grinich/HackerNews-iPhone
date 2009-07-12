//
//  HNCommentTableViewCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentTableViewCell.h"

#import "CommentStyle.h"


@implementation HNCommentTableViewCell
 
@synthesize cellComment;
@synthesize bodyLabel;
@synthesize cellIndex;



// 	self.postedByLabel.text = [NSString stringWithFormat:@"%@ points | posted by %@ %@", [[cellStory points] stringValue], [cellStory user], [cellStory time_ago]];




- (id)initWithStyle:(UITableViewCellStyle)tableViewCellStyle 
	reuseIdentifier:(NSString *)reuseIdentifier 
		  withComment:(HNComment *)comment 
		  withIndex:(NSInteger*)index
{
	if (self = [super initWithStyle:tableViewCellStyle reuseIdentifier:reuseIdentifier]) {
		
		[TTStyleSheet setGlobalStyleSheet:[[[CommentStyle alloc] init] autorelease]];
		
		cellComment = comment;
		cellIndex = (NSInteger* )index;
		
		// we need a view to place our labels on.
		UIView *myContentView = self.contentView;
		
		self.bodyLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero] ;
		self.bodyLabel.textAlignment = UITextAlignmentLeft;
		self.bodyLabel.userInteractionEnabled = YES;
		self.bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
		self.bodyLabel.backgroundColor = [UIColor lightGrayColor];
		
		[self setupData];
		
		[myContentView addSubview:self.bodyLabel];
		[self.bodyLabel release];
	
	}
    return self;
}


-(void) setupData {
	self.bodyLabel.text = [TTStyledText textFromXHTML:[cellComment contentsSource] lineBreaks:YES URLs:YES];
	//[self.bodyLabel sizeToFit];

}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGFloat cellWidth = contentRect.size.width;
		
		CGFloat topBuff = 5;
		
//		self.bodyLabel.contentInset = UIEdgeInsetsMake(10, 10 , 10, 10);
		self.bodyLabel.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);

		
		CGFloat leftInset = boundsX + 10.0 + (double)[cellComment indentationLevel] * 10.0;

		self.bodyLabel.frame = CGRectMake(leftInset, 
										   0, 
										   cellWidth - 10 - leftInset, 
										   [HNCommentTableViewCell getBodyHeightForComment:cellComment]);
		
		
		/*
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
		 */
		
		
	}
	
	
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
	[TTStyleSheet setGlobalStyleSheet:nil];

}



#pragma mark -
#pragma mark Heights for the cell elements

+ (CGFloat) heightForCellWithComment:(HNComment *)comment {
		
	CGFloat buff = 10.0;
	
	CGFloat cellHeight =	
	[self getBodyHeightForComment:comment];	
	
	if  ( cellHeight + 10.0 > 43.0) {
		return cellHeight + 10.0;
	} else {
		return 44.0;
	}
	
}


+ (CGFloat) getBodyHeightForComment:(HNComment *)comment {
	CGSize aSize; 
	NSString *string = [comment text];
	aSize = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
			   constrainedToSize:CGSizeMake(280.0, 1000.0)  
				   lineBreakMode:UILineBreakModeWordWrap];  
	
	return aSize.height;
}



@end
