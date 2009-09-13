//
//  HNStory.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStory.h"


@implementation HNStory

@synthesize title;
@synthesize points;
@synthesize user;
@synthesize url;
@synthesize time_ago;
@synthesize comments_count;
@synthesize nocomments;
@synthesize story_id;
@synthesize fulltext;
@synthesize voteup_url;
@synthesize reply_url;
@synthesize replyFNID;
@synthesize voted;

- (id)init
{
    self = [super init];
    if (self) {
        nocomments = NO; // default
		voted = NO;
    }
    return self;
}

- (void) dealloc {
	[super dealloc];
	[title	release];
	[points release];
	[user release];
	[url release];
	[time_ago release];
	[comments_count release];
}

-(NSString *)subtext {
	return [NSString stringWithFormat:@"%@ points | posted by %@ %@", 
								 [self.points stringValue], 
								 self.user, 
								 self.time_ago];
	
	
}

-(void) voteUpWithDelegate:(id)delegate {
	
	//	int i = [self.points intValue];
	//	self.points = [NSNumber numberWithInt:(i + 1)];
	//	NSLog(@"Points %@", self.points);
	
	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.voteup_url];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:URLstring delegate:self];
	
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), URLstring);
	
}


#pragma mark -
#pragma mark TTURLRequestDelegate


- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	//TTURLDataResponse *response = request.response;
	//NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	
	//	NSLog(@"finished vote.");
	// TODO : check body for response and make sure it went through.
	
	//	[delegate reloadData];
	
}
@end
