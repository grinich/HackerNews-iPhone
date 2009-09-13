//
//  HNAuth.m
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNAuth.h"
#import "SynthesizeSingleton.h"
#import "ElementParser.h"


@implementation HNAuth
SYNTHESIZE_SINGLETON_FOR_CLASS(HNAuth);


@synthesize loggedin, loginURL, loginFNID;
@synthesize loginRequest, fnidRequest, username, password;


- (void)requestDidFinishLoad:(TTURLRequest*)request { 
	
	NSLog(@"Request Finished Load!");

	
	if (request == fnidRequest) {
		
		TTURLDataResponse *response = request.response;
		NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
		
		// Check for bad login credentials. 
		// <body bgcolor=#ffffff alink=#0000be>Bad login.<br><br>
		
		Element *document = [Element parseHTML: responseBody];
		self.loginFNID = [[[document selectElements:@"form > input"] objectAtIndex:0] attribute:@"value"];
		
		[self finalLogin];
		
	} else if (request == loginRequest) {
		// Login request done.		
		TTURLDataResponse *response = request.response;
		NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
			
		if([responseBody rangeOfString:@"Bad login"].location!=NSNotFound) {
			NSLog(@"Failed Login.");
			self.loggedin = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"failedLoginNotification" object:self];
		} else {
			NSLog(@"Successful login");
			self.loggedin = YES;	
			[[NSNotificationCenter defaultCenter] postNotificationName:@"successfulLoginNotification" object:self ] ;
		}

		
		
	} else {
	}

}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
	self.loggedin = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"failedLoginNotification" object:self];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	self.loggedin = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"failedLoginNotification" object:self];
}


-(void) finalLogin {
					
	NSString *URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/y?fnid=%@&u=%@&p=%@",
						   self.loginFNID,
						   self.username,
						   self.password];

//	NSString *URLstring = @"http://news.ycombinator.com/y";
	
	loginRequest = [TTURLRequest requestWithURL:URLstring delegate:self];
	
//	loginRequest.parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:	
//											   self.loginFNID, @"fnid",
//											   self.username, @"u",
//											   self.password, @"p",
//											   nil];
	
	//	request.cachePolicy = cachePolicy;
	loginRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
	loginRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
//	loginRequest.httpMethod = @"POST";
	loginRequest.httpMethod = @"GET";

	BOOL cacheHit = [loginRequest send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), URLstring);
	
	NSLog(@"Started Request");
	
}


-(void)loginWithUsername:(NSString*)u password:(NSString*)p {
	self.username = u;
	self.password = p;
	
	[[NSUserDefaults standardUserDefaults] setObject:u forKey:@"username"];
	
	NSString *yc_url = [NSString stringWithFormat:@"http://news.ycombinator.com%@", loginURL];

	
	fnidRequest = [TTURLRequest requestWithURL:yc_url delegate:self];
	//	request.cachePolicy = cachePolicy;
	fnidRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
	fnidRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	fnidRequest.httpMethod = @"GET";
	fnidRequest.shouldHandleCookies = YES;
	[fnidRequest send];  
}


-(void)logout {
	NSURL *hnURL = [NSURL URLWithString:@"http://news.ycombinator.com"];
	NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hnURL];
	for (NSHTTPCookie* cookie in cookies) {
		NSLog(@"Deleting cookie %@", cookie);
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
	[[HNAuth sharedHNAuth] setLoggedin:NO];
}

@end
