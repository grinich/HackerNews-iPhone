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

@class HNCommentTableItem;

@implementation HNCommentTableItemCell

@synthesize cellComment;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
	
	TTTableStyledTextItem* textItem = item;
	textItem.text.font = TTSTYLEVAR(font);
	
	CGFloat padding = tableView.style == UITableViewStyleGrouped ? kGroupMargin*2 : 0;
	padding += textItem.padding.left + textItem.padding.right;
	
	if (textItem.URL) {
		padding += kDisclosureIndicatorWidth;
	}
	
	textItem.text.width = tableView.width - padding;
	
	return textItem.text.height + textItem.padding.top + textItem.padding.bottom;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_label.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_label];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_MEMBER(_label);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	TTTableStyledTextItem* item = self.object;
	
	CGFloat indent_by = kHPadding * [[self.cellComment indentationLevel] floatValue];
			
	
	CGRect indented = CGRectMake(indent_by, 
								 0.0, 
								 self.contentView.bounds.size.width - indent_by,
								 self.contentView.bounds.size.height);
	
	
	_label.frame = CGRectOffset(self.contentView.bounds, item.margin.left, item.margin.top);
//	_label.frame = CGRectOffset(indented, item.margin.left, item.margin.top);
	
	
	_label.backgroundColor = self.superview.backgroundColor;	// This makes it transparent.
	
	
	
	[_label setNeedsLayout];
}

-(void)didMoveToSuperview {
	[super didMoveToSuperview];
	if (self.superview && [(UITableView*)self.superview style] == UITableViewStylePlain) {
		_label.backgroundColor = self.superview.backgroundColor;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
				
		HNCommentTableItem *item = object;
		self.cellComment = item.comment;
		_label.text = item.text;
		_label.contentInset = item.padding;
		
		
		

		/*
		self.backgroundColor = [UIColor clearColor];
		self.contentView.backgroundColor = [UIColor clearColor];
		self.backgroundView.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;		
		self.backgroundView.opaque = NO;
		self.contentView.opaque = NO;
		
		NSLog(@"%@", [super description]);
		
		super.backgroundColor = [UIColor clearColor];
		super.contentView.backgroundColor = [UIColor clearColor];
		super.backgroundView.backgroundColor = [UIColor clearColor];
		super.backgroundView.opaque = NO;
		super.contentView.opaque = NO;
		 */
		
		self.accessoryType = UITableViewCellAccessoryNone;
	}  
}




@end