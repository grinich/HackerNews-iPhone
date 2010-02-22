//
//  HNPostController.m
//  HackerNews
//
//  Created by Michael Grinich on 2/21/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "HNPostController.h"
#import "ElementParser.h"


@implementation HNPostController

@synthesize replyFNID, replyURL, submitReplyRequest, setupReplyRequest;

// Just to set the "Done" button to say "Post"
- (id)init {
	self = [super init];
	self.navigationItem.rightBarButtonItem.title = @"Post";
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(replyURL);
	TT_RELEASE_SAFELY(replyFNID);
	[super dealloc];
}


- (void)post {	
	[self showActivity:@"Posting comment"];
	
	if (self.replyFNID) {
		// We already have the FNID which means it's from the main comments
		// page. i.e. A top-level reply.

		[self sendReply];
	}  else {
		
		if (!self.replyURL)
			DLog(@"Error: No reply URL");
		
		// This downloads the correct URL for posting a comment.
		NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.replyURL];
		setupReplyRequest = [TTURLRequest requestWithURL:URLstring delegate:self];
		setupReplyRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
		setupReplyRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
		setupReplyRequest.httpMethod = @"GET";
		[setupReplyRequest send]; 
	}
	
}

-(void)sendReply {
	// Via http://stackoverflow.com/questions/573010/convert-characters-to-html-entities-in-cocoa
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue: self.replyFNID forKey: @"fnid"];
	[parameters setValue: _textView.text forKey: @"text"];	
	
	NSString* baseURL = @"http://news.ycombinator.com/r?";
	NSString *submitURL = [baseURL stringByAppendingString: [parameters urlEncodedString]];
	
	DLog(@"Submitted reply url: %@", submitURL);
	
	submitReplyRequest = [TTURLRequest requestWithURL:submitURL delegate:self];
	
	submitReplyRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
	submitReplyRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	submitReplyRequest.httpMethod = @"GET";
	[submitReplyRequest send];  
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	if (request == setupReplyRequest ) {
		TTURLDataResponse *response = request.response;
		NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
		
		Element *document = [Element parseHTML: responseBody];
		self.replyFNID = [[[document selectElements:@"form > input"] objectAtIndex:0] attribute:@"value"];
		
		[self sendReply];
	}
	
	else if (request == submitReplyRequest) {
		// Comment sent! Yay!
		[[NSNotificationCenter defaultCenter] postNotificationName:@"commentSubmittedNotification" object:self ] ;
		
		[self dismissWithResult:nil animated:YES];
	}
}

// TODO: Provide support for failing a comment posting.
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	// code here
	//[self dismissWithResult:nil animated:YES];
}


@end
