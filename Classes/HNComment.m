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


@synthesize delegate;

-(BOOL) voteUpWithDelegate:(id)commentDelegate {
	delegate = commentDelegate;
	
	
	
	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.upvotelink];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:URLstring delegate:self];
	
	request.cachePolicy = TTURLRequestCachePolicyNone;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), URLstring);
	
	
}


-(BOOL) voteDownWithDelegate:(id)commentDelegate {
	delegate = commentDelegate;
	NSString* URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/%@", self.downvotelink];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:URLstring delegate:self];
	
	request.cachePolicy = TTURLRequestCachePolicyNone;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), URLstring);
	
}

#pragma mark -
#pragma mark TTURLRequestDelegate


- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	
	NSLog(@"finished vote.");
	// TODO : check body for response!?  
	
	[delegate finishedVoteUp];
	
}

@end
