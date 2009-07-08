//
//  HNParser.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HackerNewsAppDelegate, HNStory;

@interface HNParser : NSObject  {

	NSMutableString *currentElementValue;
	
	HackerNewsAppDelegate *appDelegate;
	HNStory *aStory;
	
}

- (HNParser *) initHNParser;


@end
