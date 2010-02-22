//
//  HNPostController.h
//  HackerNews
//
//  Created by Michael Grinich on 2/21/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNPostController : TTPostController <TTURLRequestDelegate> {

	NSString  * replyURL;
	NSString  *replyFNID;
	
	TTURLRequest *submitReplyRequest;
	TTURLRequest *setupReplyRequest;



}

@property(nonatomic,retain)		NSString *replyFNID;
@property(nonatomic,retain)		NSString  * replyURL;

@property(nonatomic,retain) TTURLRequest *submitReplyRequest;
@property(nonatomic,retain) TTURLRequest *setupReplyRequest;

- (void)post;

- (void)sendReply;

@end
