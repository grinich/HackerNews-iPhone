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

@implementation HNCommentModel


@synthesize comments, story_id;



- (void)dealloc {
	//	TT_RELEASE_TIMER(_fakeLoadTimer);
	//	TT_RELEASE_MEMBER(_delegates);
	//	TT_RELEASE_MEMBER(_allNames);
	//	TT_RELEASE_MEMBER(_names);
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




#pragma mark TTTableViewDataSource

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	NSString* story_url = [NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", self.story_id];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:story_url delegate:self];
	
	//	request.cachePolicy = cachePolicy;
	request.cachePolicy = TTURLRequestCachePolicyMemory;
	
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), story_url);
}



#pragma mark TTURLRequestDelegate

- (void)requestDidStartLoad:(TTURLRequest*)request {
	_isLoading = YES;
	_isLoaded = NO;    
	[_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	self.comments = [NSMutableArray new];
	
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	
	
	Element *document = [Element parseHTML: responseBody];
	
	
	// Add the story header
	// Gotta rebuild the story item from here using our magic parser! Fuck. 
	
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
		
		HNComment* comment = [HNComment new];
		Element *secondTier = [element selectElement:@"div span.comhead"];
		
		// TODO : allocating this every time is really slow		
		// 		comment.contentsSource =  [[element selectElement:@"span.comment"] contentsSource];
		
		comment.text = [[element selectElement:@"span.comment"] contentsText];
		
		//		comment.contentsSource =  [[[element selectElement:@"span.comment"] selectElement:@"font"] contentsSource];
		
		NSString *preCut = [[element selectElement:@"span.comment"] contentsSource];
		
		
		comment.contentsSource =  [[[[[[[[[[[preCut
											 
											 // Extra <p> tags without closes. Just make double newline.
											 stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"]
											
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
		
		
		//		comment.reply_url =  [[NSURL URLWithString:[[[[secondTier firstChild] nextElement] nextElement] attribute:@"href"] 
		//									 relativeToURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]]
		//							  absoluteURL];
		
		// Indenation --> WORKS
		NSNumber *fromSrc = [nFormatter numberFromString:[[[[element parent] firstChild] selectElement:@"img"] attribute:@"width"] ];
		comment.indentationLevel = [NSNumber numberWithInt:([fromSrc intValue] / 40)];
		
		
		NSString *pointsTempString = [[secondTier firstChild] contentsText];	
		
		
		// TODO : do this
		//NSInteger location = [pointsTempString length] + 4 + [comment.user length] + 1;
		//NSInteger length = [[subtextElement contentsText] length] - location - [commentsTempString length] - 3;
		//comment.time_ago = [[subtextElement contentsText] substringWithRange:NSMakeRange(location, length) ];
		
		//comment.url =					//  persistent URL here
		
		//comment.time_ago;
		
		
		
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





@end
