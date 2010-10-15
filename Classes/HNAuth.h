//
//  HNAuth.h
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HNAuth : NSObject <TTURLRequestDelegate> {

	// Relative to news.ycombinator.com
	NSString* loginURL;
	
	NSString* loginFNID;
	
	BOOL loggedin;
	
	TTURLRequest *fnidRequest;
	TTURLRequest *loginRequest;
	
	NSString *username;
	NSString *password;
	
}


+ (HNAuth *)sharedHNAuth;

-(void)loginWithUsername:(NSString*)username password:(NSString*)password;
-(void)logout;
-(void) finalLogin;


@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;

@property (nonatomic,retain) NSString* loginURL;
@property (nonatomic,retain) NSString* loginFNID;


@property (nonatomic,retain) TTURLRequest *fnidRequest;
@property (nonatomic,retain) TTURLRequest *loginRequest;
@property(nonatomic) BOOL loggedin;

@end
