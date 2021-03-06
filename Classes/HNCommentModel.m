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
#import "ElementParser.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"
#import "HNAuth.h"
#import "NSDictionary+UrlEncoding.h"
#import "HNStory.h"

@implementation HNCommentModel


@synthesize comments, story_id, headerStory;


- (void)dealloc {
	TT_RELEASE_SAFELY(comments);
	TT_RELEASE_SAFELY(story_id);
	TT_RELEASE_SAFELY(headerStory);
	[super dealloc];
}

#pragma mark TTTableViewDataSource

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	// Main load for all of the comments
	
	NSString* story_url = [NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", self.story_id];
	TTURLRequest* allCommentsRequest = [TTURLRequest requestWithURL:story_url delegate:self];
	
	//	request.cachePolicy = cachePolicy;
	allCommentsRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
	
	allCommentsRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	allCommentsRequest.httpMethod = @"GET";
	
	BOOL cacheHit = [allCommentsRequest send];  
	DLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), story_url);
}



#pragma mark TTURLRequestDelegate
/*
- (void)requestDidStartLoad:(TTURLRequest*)request {
	_isLoading = YES;
	_isLoaded = NO;    
	[self didStartLoad];
}
*/

- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	self.comments = [NSMutableArray new];
	
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	Element *document = [Element parseHTML: responseBody];
	NSNumberFormatter* nFormatter = [NSNumberFormatter new];

			
	//////////////////////////////////////////////////////////
	//			HTML Processing for title box				//
	//////////////////////////////////////////////////////////
	
	//NSArray *titles = [document selectElements:@"tr > td > table > tr"];
	Element* title = [document selectElement:@"td.title"];
	
	HNStory* story = [[HNStory alloc] init];
	
	story.title = [[title selectElement:@"a"] contentsText];
	story.url = [NSURL URLWithString:[[title selectElement:@"a"] attribute:@"href"]];
			
	
	// POINTS
	// Either "points" or "point"
	NSString* pointsTempString = [[[[title parent] parent] selectElement:@"td.subtext > span"] contentsSource];
			
	if ([pointsTempString hasSuffix:@"points"]) {
		story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
		
	} else if ([pointsTempString hasSuffix:@"point"]) {
		story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
		
	} else {
		// No points. 
		story.points = [NSNumber numberWithInt:0];
		// DLog(@"Error parsing points for story.");
	}
			
	DLog(@"Comments: %@", [[[[[title parent] parent] selectElements:@"td.subtext > a"] objectAtIndex:1] contentsSource]);

	story.replyFNID = [[[document selectElements:@"form > input"]objectAtIndex:0] attribute:@"value"];
	
	// Subtext			[[[[title parent] parent] selectElement:@"td.subtext"] contentsText]
	
	story.voteup_url = [[[[title parent] firstChild] selectElement:@"center > a"] attribute:@"href"];
	if (!story.voteup_url) {
		story.voted = YES;
	}
	
	story.fulltext = [[[[[[[title parent] parent] selectElement:@"td.subtext"] parent] nextSybling] nextSybling] contentsText];
	story.user = [[[[[title parent] parent] selectElements:@"td.subtext > a"] objectAtIndex:0] contentsSource];
	story.time_ago = @"";
	story.comments_count = nil;
	story.story_id = nil;

	self.headerStory = story;
	
	
	//////////////////////////////////////////////////////////
	//			HTML Processing for comments				//
	//////////////////////////////////////////////////////////
	
	
	NSArray *commentsElements = [document selectElements:@"tr > td.default"];
	
	NSEnumerator* commentsEnumerator = [commentsElements objectEnumerator];
	

	
	Element *element;
	
	while(element = [commentsEnumerator nextObject] ) {
		
		HNComment* comment = [[HNComment alloc] init];
		
		// Upvote & downvotes for comments.
		//NSArray *voteElements = [[[[element parent] firstChild] nextSybling] selectElements:@"a"];
		
		Element	*commentTop = [element parent];
		
					
		Element* up = [commentTop selectElement:@"td > center > a"];
					
		
		if (up) {
			comment.upvotelink = [up attribute:@"href"];
			if ([[HNAuth sharedHNAuth] loggedin]) {
				comment.downvotelink = [[[[commentTop selectElement:@"td > center > a"] nextSybling] nextSybling] attribute:@"href"];
				comment.isDownvote = YES;
				if (comment.downvotelink == nil) {
					comment.isDownvote = NO;
				}

			}
			comment.voted = NO;
		} else {
			comment.voted = YES;
		}
		
		
		Element *secondTier = [element selectElement:@"div span.comhead"];
		
		comment.text = [[element selectElement:@"span.comment"] contentsText];
		
		
		NSString *preCut = [[element selectElement:@"span.comment"] contentsSource];
					
		comment.contentsSource =  [[[[[[[[[[[[[[[preCut
											  
											  // Extra <p> tags without closes. Just make double newline.
											  stringByReplacingOccurrencesOfString:@"<p>" withString:@"<br/><br/>"]
											 
											 stringByReplacingOccurrencesOfString:@"</font>" withString:@""]
											
											// Regular color.
											stringByReplacingOccurrencesOfString:@"<font color=#000000>" withString:@""]
										   
										   // Replace <pre><code> with span tag for fixed-width style

											 stringByReplacingOccurrencesOfString:@"<pre><code>  " withString:@"<span class=\"codeText\">"]
											stringByReplacingOccurrencesOfString:@"</code></pre>" withString:@"</span>"]
										   stringByReplacingOccurrencesOfString:@"\n  " withString:@"<br/>"]
										  stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]
										  
										  
										  
										  
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
		
		
		// Time since posting
		// TODO : This crashes unexpectedly
		/*
		NSInteger location = [[[secondTier firstChild] contentsText] length] + 5 + [[[[secondTier firstChild] nextElement] contentsText] length];
		NSInteger length = [[secondTier contentsText] length] - location - 7;
		
		// TODO this breaks everything
		comment.time_ago =  [[secondTier contentsText] substringWithRange:NSMakeRange(location, length) ];		
		*/
		
		comment.time_ago = @"";

		
		
		
		NSString *pointsTempString = [[secondTier firstChild] contentsText];	
		
		
		// POINTS
		if ([pointsTempString hasSuffix:@"points"]) {
			comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
		} else if ([pointsTempString hasSuffix:@"point"]) {
			comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
			
		} else {
			// No points. WTF?
			comment.points = [NSNumber numberWithInt:0];
			DLog(@"Error parsing points for story.");
		}
		
		[self.comments addObject:comment];
	}
	
	
	[super requestDidFinishLoad:request];

}
	



@end
