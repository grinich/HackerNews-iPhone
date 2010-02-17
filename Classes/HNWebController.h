//
//  HNWebController.h
//  HackerNews
//
//  Created by Michael Grinich on 1/4/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import <MessageUI/MessageUI.h>

@class HNStory;

@interface HNWebController : TTWebController <MFMailComposeViewControllerDelegate> {

	HNStory *linkedStory;
}


@property(nonatomic,retain) HNStory *linkedStory;

- (void)shareAction;
- (void) sendToInstapaper;


@end
