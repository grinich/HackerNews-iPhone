//
//  HNCommentsDataSource.m
//  HackerNews
//
//  Created by Michael Grinich on 7/13/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsDataSource.h"

#import "HNComment.h"
#import "HNCommentTableItem.h"
#import "HNCommentTableItemCell.h"
#import "HNCommentHeaderItem.h"
#import "HNCommentHeaderItemCell.h"

#import "ElementParser.h"

#import "TempItems.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"

@implementation HNCommentsDataSource

@synthesize story_id;

- (id)init {
	if (self = [super init]) {
		_isLoading = YES;
		_isLoaded = NO;
	}  
	return self;
}

#pragma mark TTTableViewDataSource

- (void)load:(TTURLRequestCachePolicy)cachePolicy nextPage:(BOOL)nextPage {    
	
	NSString* story_url = [NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", self.story_id];
		
	TTURLRequest *request = [TTURLRequest requestWithURL:story_url delegate:self];
	
//	request.cachePolicy = cachePolicy;
	request.cachePolicy = TTURLRequestCachePolicyMemory;

	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), story_url);
}


#pragma mark TTLoadable

- (BOOL)isLoading {
	return _isLoading;
}

- (BOOL)isLoaded {
	return _isLoaded;
}

#pragma mark TTURLRequestDelegate

- (void)requestDidStartLoad:(TTURLRequest*)request {
	_isLoading = YES;
	_isLoaded = NO;    
	//	[self dataSourceDidStartLoad];
	[self didStartLoad];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
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
	
	
	[self.items addObject:[HNCommentHeaderItem itemWithStory:[[TempItems sharedTempItems] tempHNStory]]];
	 	
	

	
	
	
	
	//////////////////////////////////////////////////////////
	//			HTML Processing for comments				//
	//////////////////////////////////////////////////////////
	
	
	
	NSArray *comments = [document selectElements:@"tr > td.default"];

	NSEnumerator* commentsEnumerator = [comments objectEnumerator];
	
	
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
		
		
		comment.contentsSource =  [[[[[[[preCut
									  stringByReplacingOccurrencesOfString:@"</font>" withString:@""]
									 
									 // Regular
									 stringByReplacingOccurrencesOfString:@"<font color=#000000>" withString:@""]
									
									// Downvote. TODO: check for this and set text color accordingly?
									stringByReplacingOccurrencesOfString:@"<font color=#dddddd>" withString:@""]
									
									// Another downvote color
									stringByReplacingOccurrencesOfString:@"<font color=#737373>" withString:@""]
								   
								   stringByReplacingOccurrencesOfString:@"<font color=#bebebe>" withString:@""]
									
									stringByReplacingOccurrencesOfString:@"<font color=#aeaeae>" withString:@""]
								   
								   // Extra <p> tags without closes. Just make double newline.
								   stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
		
		
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
		
		[self.items addObject:[HNCommentTableItem itemWithComment:comment]];
				
	}
	
	
	_isLoading = NO;
	_isLoaded = YES;  
	//	[self dataSourceDidFinishLoad];
	[self didFinishLoad];
	
}


- (NSString*)titleForLoading:(BOOL)refreshing {
	if (refreshing) {
		return TTLocalizedString(@"Updating Comments...", @"");
	} else {
		return TTLocalizedString(@"Loading Comments...", @"");
	}
}




///////////////////////////////////////////////////////////////////////////////////////////////////



- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	NSLog(@"didFailLoadWithError");
	_isLoading = NO;
	_isLoaded = YES;  
	//[self dataSourceDidFailLoadWithError:error];
	[self didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
	NSLog(@"requestDidCancelLoad");
	_isLoading = NO;
	_isLoaded = YES; 
	// [self dataSourceDidCancelLoad];	
	[self didCancelLoad];
}
///////////////////////////////////////////////////////////////////////////////////////////////////


- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {	
	if ([object isKindOfClass:[HNCommentTableItem class]]) {
		return [HNCommentTableItemCell class];
	} else if ([object isKindOfClass:[HNCommentHeaderItem class]]) {
		return [HNCommentHeaderItemCell class];
	}
	
	else {
		return [super tableView:tableView cellClassForObject:object];
	}
}		



@end
