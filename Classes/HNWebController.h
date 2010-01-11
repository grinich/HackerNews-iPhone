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


@interface HNWebController : TTWebController <MFMailComposeViewControllerDelegate> {

}


- (void)shareAction;


@end
