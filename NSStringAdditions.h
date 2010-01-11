//
//  NSStringAdditions.h
//  HackerNews
//
//  Created by Michael Grinich on 1/9/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSStringAdditions)

- (NSString *) stringByEncodingIllegalURLCharacters;
- (NSString *) stringByDecodingIllegalURLCharacters;

@end
