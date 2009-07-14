//
//  HNCommentsDataSource.h
//  HackerNews
//
//  Created by Michael Grinich on 7/13/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface HNCommentsDataSource : TTListDataSource <TTURLRequestDelegate> {

	NSString *story_id;

@private
	BOOL _isLoading;
	BOOL _isLoaded;
}

@property (nonatomic, retain) NSString *story_id;

@end
