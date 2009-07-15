//
//  HNCommentTableItem.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentTableItem : TTTableLinkedItem {
	
	HNComment *comment;
	
	TTStyledText* subtext;
	NSNumber	* indentationLevel; 
	
	TTStyledText* _text;
	UIEdgeInsets _margin;
	UIEdgeInsets _padding;
}


@property (nonatomic,retain)	HNComment *comment;


@property(nonatomic,retain) TTStyledText* text;
@property(nonatomic) UIEdgeInsets margin;
@property(nonatomic) UIEdgeInsets padding;

@property(nonatomic, retain) 	TTStyledText* subtext;
@property(nonatomic, retain) 	NSNumber	* indentationLevel; 


+ (HNCommentTableItem *)itemWithComment:(HNComment *)aComment;






@end