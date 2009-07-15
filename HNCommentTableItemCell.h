//
//  HNCommentTableItemCell.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentTableItemCell : TTTableLinkedItemCell {
	
	HNComment	*cellComment;

	TTStyledTextLabel* _label;	
	
}

@property (nonatomic, retain) HNComment *cellComment;


@end