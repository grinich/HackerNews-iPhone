//
//  HNCommentsTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"


@class HNComment, LoadingView;

@interface HNCommentsTableViewController :  TTTableViewController <TTTextEditorDelegate> {
	
	NSString		*storyID;
	BOOL	composing;
	LoadingView *replyLoadingView;
}

@property (nonatomic, retain)	NSString	*storyID;
@property (nonatomic) BOOL	composing;

- (id)initWithStory:(NSString *)storyIN;


@end
