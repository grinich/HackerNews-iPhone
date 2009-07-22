//
//  HNStoryModel.m
//  HackerNews
//
//  Created by Michael Grinich on 7/16/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryModel.h"
#import "HNAuth.h"
#import "HNStory.h"
#import "ElementParser.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"


static NSString *yc_url = @"http://news.ycombinator.com/";


@implementation HNStoryModel

@synthesize stories;


//- (id)init {
//	if (self = [super init]) {
//		_isLoading = YES;
//		_isLoaded = NO;
//	}  
//	return self;
//}

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
	return !self.stories.count;
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



- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	TTURLRequest *request = [TTURLRequest requestWithURL:yc_url delegate:self];
	
	request.cachePolicy = TTURLRequestCachePolicyMemory;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), yc_url);
	
}


#pragma mark TTURLRequestDelegate


- (void)requestDidStartLoad:(TTURLRequest*)request {
	_isLoading = YES;
	_isLoaded = NO;  
	[_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request { 
	
	self.stories = [NSMutableArray new];
	
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
    
	
	//////////////////////////////////////////////////////////
	//			HTML Processing for main stories			//
	//////////////////////////////////////////////////////////
	
	Element *document = [Element parseHTML: responseBody];
	
	
	// Main links
	//NSLog(@"URL %@", [[document selectElement:@"span.pagetop"] contentsSource]);
	
	[[HNAuth sharedHNAuth] setLoginURL:
	 [[[[document selectElements:@"span.pagetop"] objectAtIndex:1] selectElement:@"a"] attribute:@"href"]];
	
	NSArray *titles = [document selectElements:@"tr > td > table > tr"];
	
	
	NSNumberFormatter* nFormatter = [NSNumberFormatter new];
	
	NSEnumerator* titlesEnumerator = [titles objectEnumerator];
	
	[titlesEnumerator nextObject];	// We skip the first object
	
	Element *subtextElement;
	
	// Saves from having to create/destory every time
	NSString *pointsTempString;
	NSString *commentsTempString;
	Element* titleElement;
	while(titleElement = [titlesEnumerator nextObject] )
	{
		// At the end
		if ([titleElement hasAttribute:@"style"]) {
			break;
		}
		
		HNStory* story  = [HNStory new];
				
		// First Section
		
		// Get the voting objects and URLS from this object\
		// [[titleElement firstChild] nextSybling]
		
		// Second Section
		Element* secondElement = [[[titleElement firstChild] nextSybling] nextSybling];
		Element *title = [secondElement firstChild];
		
		// TITLE
		story.title =	[[title contentsText]
						 stringByReplacingOccurrencesOfString:@"â" withString:@"\""];
		
		
		NSString *tempURLString = [title attribute:@"href"];
		if ( [tempURLString hasPrefix:@"http://"] || 
			[tempURLString hasPrefix:@"https://"]) 
		{
			// Valid
			story.url = [NSURL URLWithString:tempURLString];
		} else {
			// URL is not full length, which means that it's an internal url
			// TODO : set our URL schema so that these will automatically just open in another table!
			story.url = [[NSURL URLWithString:tempURLString relativeToURL:[NSURL URLWithString:yc_url]] absoluteURL];
			
		}
		
		
		
		// Third Section
		titleElement = [titlesEnumerator nextObject];
		subtextElement = [[titleElement firstChild] nextSybling];
		
		story.user = [[subtextElement selectElement:@"a"] contentsText];
		
		// USER
		pointsTempString = [[subtextElement selectElement:@"span"] contentsText];
		commentsTempString = [[[subtextElement selectElement:@"a"] nextElement] contentsText];
		
		// TIME SINCE POSTING
		NSInteger location = [pointsTempString length] + 4 + [story.user length] + 1;
		NSInteger length = [[subtextElement contentsText] length] - location - [commentsTempString length] - 3;
		story.time_ago = [[subtextElement contentsText] substringWithRange:NSMakeRange(location, length) ];
		
		// POINTS
		// Either "points" or "point"
		if ([pointsTempString hasSuffix:@"points"]) {
			story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
			
		} else if ([pointsTempString hasSuffix:@"point"]) {
			story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
			
		} else {
			// No points. 
			story.points = [NSNumber numberWithInt:0];
			// NSLog(@"Error parsing points for story.");
		}
		
		// Either "xx Comments" or "1 comment" or "discuss"		
		if ([commentsTempString hasSuffix:@"comments"]){
			// get rid of "comments"
			story.comments_count = [nFormatter numberFromString:[commentsTempString substringToIndex:[commentsTempString length] - 9]];
			
		} else if ([commentsTempString hasSuffix:@"comment"]) {
			story.comments_count = [nFormatter numberFromString:[commentsTempString substringToIndex:[commentsTempString length] - 8]];
			
		} else if ([commentsTempString hasSuffix:@"discuss"]) {
			story.comments_count = [NSNumber numberWithInt:0];
			
		} else {
			// The likely case here is that comments have been disabled for the post.
			// It's probably a job posting or something.
			story.nocomments = TRUE;
			story.comments_count = [NSNumber numberWithInt:0];
			NSLog(@"Error parsing comment for story.");
		}
		
		NSString *idString = [[[subtextElement selectElement:@"span"] attribute:@"id"] substringFromIndex:6];
		
		story.story_id = [nFormatter numberFromString:idString];
		
		[self.stories addObject:story];
		[story release];
		
		// Skip one
		[titlesEnumerator nextObject];
		
	}	
	
	
	
	_isLoading = NO;
	_isLoaded = YES;  

	[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}




@end
