//
//  HNCommentModel.h
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface HNCommentModel : TTModel <TTURLRequestDelegate>  {

	NSMutableArray* comments;
	NSString* story_id;

	
@private
	
	BOOL _isLoading;
	BOOL _isLoaded;
}

@property(nonatomic,retain) NSMutableArray* comments;
@property(nonatomic,retain) NSString *story_id;


@end
