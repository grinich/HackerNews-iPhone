
#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentReplyItem : TTTextEditor <TTURLRequestDelegate> {

	NSNumber  * indentationLevel; 
	
	NSString  * replyURL;
	NSString  *replyFNID;

}

@property(nonatomic,retain)   NSNumber  * indentationLevel; 
@property(nonatomic,retain) NSString *replyFNID;
@property(nonatomic,retain)   NSString  * replyURL;

@end