//
//  HNCommentModel.h
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class HNComment, HNCommentReplyItem, HNStory;

@interface HNCommentModel : TTModel <TTURLRequestDelegate>  {

	HNStory* headerStory;
	
	NSMutableArray* comments;
	NSString* story_id;
	
	HNCommentReplyItem* activeReplyItem;
	
	TTURLRequest *setupReplyRequest;
	TTURLRequest *allCommentsRequest;
	TTURLRequest *submitReplyRequest;
	
	
@private
	
	BOOL _isLoading;
	BOOL _isLoaded;
}

-(void)replyWithItem:(HNCommentReplyItem*)replyItem;

@property(nonatomic,retain) HNStory* headerStory;
@property(nonatomic,retain) NSMutableArray* comments;
@property(nonatomic,retain) NSString *story_id;
@property(nonatomic,retain) TTURLRequest *setupReplyRequest;
@property(nonatomic,retain) TTURLRequest *allCommentsRequest;
@property(nonatomic,retain) TTURLRequest *submitReplyRequest;
@property(nonatomic,retain) HNCommentReplyItem* activeReplyItem;


@end
