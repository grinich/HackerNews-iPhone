//
//  HNInstapaper.h
//  HackerNews
//
//  Created by Michael Grinich on 4/29/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNInstapaper : NSObject {

}

- (void) sendToInstapaper:(NSURL*)url;
- (void) sendToInstapaper:(NSURL*)inputURL withTitle:(NSString*)title;


@end
