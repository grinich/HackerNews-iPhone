#import "HNCommentReplyItem.h"
#import "HNStyle.h"
#import "HNComment.h"
#import "ElementParser.h"

@implementation HNCommentReplyItem

@synthesize replyFNID, indentationLevel, replyURL;

- (void)dealloc {

	TT_RELEASE_SAFELY(indentationLevel);
	TT_RELEASE_SAFELY(replyFNID);
	[super dealloc];
}


@end