//
//  LoginLogic.h
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface LoginLogic : NSObject <TTURLRequestDelegate> {

	// Relative to news.ycombinator.com
	NSString* loginURL;
	
	NSString* loginFNID;
	
}


+ (LoginLogic *)sharedLoginLogic;

@property (nonatomic,retain) NSString* loginURL;
@property (nonatomic,retain) NSString* loginFNID;

@end
