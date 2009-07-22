//
//  HNCommentModel.m
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentModel.h"

#import "HNComment.h"
#import "HNCommentTableItem.h"
#import "HNCommentTableItemCell.h"
#import "HNCommentReplyItem.h"
#import "ElementParser.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"
#import "HNAuth.h"
#import "NSDictionary+UrlEncoding.h"

@implementation HNCommentModel


@synthesize comments, story_id, replyFNID, setupReplyRequest, allCommentsRequest, submitReplyRequest, 
activeReplyItem;


- (void)dealloc {
	//	TT_RELEASE_TIMER(_fakeLoadTimer);
	//	TT_RELEASE_SAFELY(_delegates);
	//	TT_RELEASE_SAFELY(_allNames);
	//	TT_RELEASE_SAFELY(_names);
	[super dealloc];
}

- (NSMutableArray*)delegates {
	if (!_delegates) {
		_delegates = TTCreateNonRetainingArray();
	}
	return _delegates;
}

- (BOOL)isLoadingMore {
	return NO;
}

- (BOOL)isOutdated {
	return NO;
}

- (BOOL)isLoaded {
	return !!_isLoaded;
}

- (BOOL)isLoading {
	return !!_isLoading;
}

- (BOOL)isEmpty {
	return !self.comments.count;
}

/*
 - (void)invalidate:(BOOL)erase {
 }
 */


- (void)cancel {
	_isLoading = NO;
	_isLoaded = NO;
	[_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
}

-(void)replyWithItem:(HNCommentReplyItem*)replyItem {
	// This downloads the correct URL for posting a comment.
	self.activeReplyItem = replyItem;
	
	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", replyItem.aboveComment.reply_url];
	setupReplyRequest = [TTURLRequest requestWithURL:URLstring delegate:self];
	setupReplyRequest.cachePolicy = TTURLRequestCachePolicyNone;
	setupReplyRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	setupReplyRequest.httpMethod = @"GET";
	[setupReplyRequest send]; 	
}




-(void)sendReply {
	
	// Via http://stackoverflow.com/questions/573010/convert-characters-to-html-entities-in-cocoa
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue: self.replyFNID forKey: @"fnid"];
	[parameters setValue: self.activeReplyItem.text forKey: @"text"];	
	
	NSString* replyURL = @"http://news.ycombinator.com/r?";
	NSString *submitURL = [replyURL stringByAppendingString: [parameters urlEncodedString]];
	
	NSLog(@"Submitted url %@", submitURL);
	
	submitReplyRequest = [TTURLRequest requestWithURL:submitURL delegate:self];
	
	submitReplyRequest.cachePolicy = TTURLRequestCachePolicyNone;
	submitReplyRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	submitReplyRequest.httpMethod = @"GET";
	
	[submitReplyRequest send];  
}



#pragma mark TTTableViewDataSource

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	// Main load for all of the comments
	
	NSString* story_url = [NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", self.story_id];
	allCommentsRequest = [TTURLRequest requestWithURL:story_url delegate:self];
	
	//	request.cachePolicy = cachePolicy;
	allCommentsRequest.cachePolicy = TTURLRequestCachePolicyMemory;
	
	allCommentsRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	allCommentsRequest.httpMethod = @"GET";
	
	BOOL cacheHit = [allCommentsRequest send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), story_url);
}



#pragma mark TTURLRequestDelegate

- (void)requestDidStartLoad:(TTURLRequest*)request {
	
	if (request == allCommentsRequest) {
		_isLoading = YES;
		_isLoaded = NO;    
		[self didStartLoad];
	}

}

// Parse the data
- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	if (request == allCommentsRequest ) {
		self.comments = [NSMutableArray new];
		
		TTURLDataResponse *response = request.response;
		NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
		
		
		Element *document = [Element parseHTML: responseBody];
		
		
		// Add the story header
		
		//[self.items addObject:[HNCommentHeaderItem itemWithStory:self.story];
		
		//////////////////////////////////////////////////////////
		//			HTML Processing for title box				//
		//////////////////////////////////////////////////////////
		
		//	NSArray *titles = [document selectElements:@"tr > td > table > tr"];
		//
		//	Element *t;
		//	for (t in titles) {
		//		NSLog(@"TITLES: %@", t.contentsText);
		//		NSLog(@"//////////////////////////////////////////////////////////");	
		//
		//	}
		
		
		
		
		
		//////////////////////////////////////////////////////////
		//			HTML Processing for comments				//
		//////////////////////////////////////////////////////////
		
		
		
		NSArray *commentsElements = [document selectElements:@"tr > td.default"];
		
		NSEnumerator* commentsEnumerator = [commentsElements objectEnumerator];
		
		
		// We skip the first object
		// [commentsEnumerator nextObject];
		
		
		Element *element;
		NSNumberFormatter* nFormatter = [NSNumberFormatter new];
		
		while(element = [commentsEnumerator nextObject] ) {
			
			HNComment* comment = [[HNComment alloc] init];
			
			// Upvote & downvotes for comments.
			//NSArray *voteElements = [[[[element parent] firstChild] nextSybling] selectElements:@"a"];
			
			Element	*commentTop = [element parent];
			
			
			
			//Element* vote = [[element parent] selectElement:@"td[valign]"];
			
			
			//		[[titleElement firstChild] nextSybling]
			
			Element* up = [commentTop selectElement:@"td > center > a"];
			
			//		NSLog(@"Down: %@", [[[[commentTop selectElement:@"td > center > a"] nextSybling] nextSybling] attribute:@"href"]);
			
			
			if (up) {
				comment.upvotelink = [up attribute:@"href"];
				if ([[HNAuth sharedHNAuth] loggedin]) {
					comment.downvotelink = [[[[commentTop selectElement:@"td > center > a"] nextSybling] nextSybling] attribute:@"href"];
					
				}
				comment.voted = NO;
			} else {
				comment.voted = YES;
			}
			
			
			Element *secondTier = [element selectElement:@"div span.comhead"];
			
			
			comment.text = [[element selectElement:@"span.comment"] contentsText];
			
			
			NSString *preCut = [[element selectElement:@"span.comment"] contentsSource];
			comment.contentsSource =  [[[[[	[[[[[[preCut
												  
												  // Extra <p> tags without closes. Just make double newline.
												  stringByReplacingOccurrencesOfString:@"<p>" withString:@"<br/><br/>"]
												 
												 stringByReplacingOccurrencesOfString:@"</font>" withString:@""]
												
												// Regular color.
												stringByReplacingOccurrencesOfString:@"<font color=#000000>" withString:@""]
											   
											   /////////////////////////////////////////////
											   // DOWNVOTES. 
											   /////////////////////////////////////////////
											   
											   //TODO: check for this and set text color accordingly?
											   stringByReplacingOccurrencesOfString:@"<font color=#dddddd>" withString:@""]
											  
											  // Another downvote color
											  stringByReplacingOccurrencesOfString:@"<font color=#737373>" withString:@""]
											 
											 stringByReplacingOccurrencesOfString:@"<font color=#bebebe>" withString:@""]
										   
										   stringByReplacingOccurrencesOfString:@"<font color=#aeaeae>" withString:@""]
										  
										  // Down to zero points
										  stringByReplacingOccurrencesOfString:@"<font color=#5a5a5a>" withString:@""]
										 
										 // -1 points
										 stringByReplacingOccurrencesOfString:@"<font color=#737373>" withString:@""]
										
										// -2 points
										stringByReplacingOccurrencesOfString:@"<font color=#888888>" withString:@""]
									   
									   // -3 points
									   stringByReplacingOccurrencesOfString:@"<font color=#9c9c9c>" withString:@""];;
			
			
			
			
			
			
			comment.user = [[[secondTier firstChild] nextElement] contentsText];	// Works
			
			comment.reply_url = [[commentTop selectElement:@"u > a"] attribute:@"href"];
			
			// Indenation --> WORKS
			NSNumber *fromSrc = [nFormatter numberFromString:[[[[element parent] firstChild] selectElement:@"img"] attribute:@"width"] ];
			comment.indentationLevel = [NSNumber numberWithInt:([fromSrc intValue] / 40)];
			
			
			
			NSInteger location = [[[secondTier firstChild] contentsText] length] + 5 + [[[[secondTier firstChild] nextElement] contentsText] length];
			NSInteger length = [[secondTier contentsText] length] - location - 7;
			comment.time_ago =  [[secondTier contentsText] substringWithRange:NSMakeRange(location, length) ];		// TODO this breaks everything
			
			//comment.url =					//  persistent URL here
			
			
			NSString *pointsTempString = [[secondTier firstChild] contentsText];	
			
			
			// POINTS						--- > Works
			// Either "points" or "point"
			if ([pointsTempString hasSuffix:@"points"]) {
				comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
			} else if ([pointsTempString hasSuffix:@"point"]) {
				comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
				
			} else {
				// No points. WTF?
				comment.points = [NSNumber numberWithInt:0];
				NSLog(@"Error parsing points for story.");
			}
			
			[self.comments addObject:comment];
			
		}
		
		
		_isLoading = NO;
		_isLoaded = YES;  
		
		[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
		
	}
	
	else if (request == setupReplyRequest ) {
		TTURLDataResponse *response = request.response;
		NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
		
		Element *document = [Element parseHTML: responseBody];
		self.replyFNID = [[[document selectElements:@"form > input"] objectAtIndex:0] attribute:@"value"];
		
		[self sendReply];
	}
	
	else if (request == submitReplyRequest) {
		// Comment sent! Yay!
		[[NSNotificationCenter defaultCenter] postNotificationName:@"commentSubmittedNotification" object:self ] ;
		
	}
	
}





@end
