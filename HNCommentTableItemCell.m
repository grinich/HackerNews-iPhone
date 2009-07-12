//
//  HNCommentTableItemCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentTableItemCell.h"


///////////////////////////////////////////////////////////////////////////////////////////////////

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

// @implementation TTStyledTextTableItemCell

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
	_label.frame = CGRectOffset(self.contentView.bounds, item.margin.left, item.margin.top);
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
		
		TTTableStyledTextItem* item = object;
		_label.text = item.text;
		_label.contentInset = item.padding;
	}  
}




@end
