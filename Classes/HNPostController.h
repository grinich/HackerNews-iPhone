//
//  HNPostController.h
//  HackerNews
//
//  Created by Michael Grinich on 2/21/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNCommentTableItem.h"

@interface HNPostController : TTPostController <TTURLRequestDelegate> {

	NSString  * replyURL;
	NSString  *replyFNID;
	
	TTURLRequest *submitReplyRequest;
	TTURLRequest *setupReplyRequest;
	
	HNCommentTableItem* replyCellObject;

}

@property(nonatomic,retain)		NSString *replyFNID;
@property(readonly)		NSString  * replyURL;

@property(nonatomic,retain) TTURLRequest *submitReplyRequest;
@property(nonatomic,retain) TTURLRequest *setupReplyRequest;

// TODO : make this specific
@property(nonatomic,retain) 	HNCommentTableItem* replyCellObject;


- (void)post;

- (void)sendReply;

@end
