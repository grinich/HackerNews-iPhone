//
//  HNComment.m
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNComment.h"
#import "Three20/Three20.h"


@implementation HNComment

@synthesize text;
@synthesize points;
@synthesize user;
@synthesize url;
@synthesize reply_url;
@synthesize time_ago;
@synthesize indentationLevel;
@synthesize contentsSource;
@synthesize upvotelink;
@synthesize downvotelink;
@synthesize voted;
@synthesize deletable;
@synthesize replyEnabled;
@synthesize isDownvote;
@synthesize delegate;



-(id)init{
	self = [super init];
	self.replyEnabled = YES;
	return self;
}


- (void)dealloc {
	TT_RELEASE_SAFELY(text);
	TT_RELEASE_SAFELY(points);
	TT_RELEASE_SAFELY(user);
	TT_RELEASE_SAFELY(url);
	TT_RELEASE_SAFELY(reply_url);
	TT_RELEASE_SAFELY(time_ago);
	TT_RELEASE_SAFELY(indentationLevel);
	TT_RELEASE_SAFELY(contentsSource);
	TT_RELEASE_SAFELY(upvotelink);
	TT_RELEASE_SAFELY(downvotelink);
	[super dealloc];
}


-(void) voteUpWithDelegate:(id)commentDelegate {
	delegate = commentDelegate;
	
//	int i = [self.points intValue];
//	self.points = [NSNumber numberWithInt:(i + 1)];
//	NSLog(@"Points %@", self.points);

	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.upvotelink];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:URLstring delegate:self];
	
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), URLstring);
	
}


-(void) voteDownWithDelegate:(id)commentDelegate {
	delegate = commentDelegate;
	
//	int i = [self.points intValue];
//	self.points = [NSNumber numberWithInt:(i + 1)];
//	NSLog(@"Points %@", self.points);
		
	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.downvotelink];
	
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
