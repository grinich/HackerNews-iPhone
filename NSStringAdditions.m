//
//  NSStringAdditions.m
//  HackerNews
//
//  Created by Michael Grinich on 1/9/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "NSStringAdditions.h"


@implementation NSString (NSStringAdditions)

- (NSString *) stringByEncodingIllegalURLCharacters {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)self, NULL, CFSTR( ",;:/?@&$=|^~`\{}[]" ), kCFStringEncodingUTF8 ) autorelease];
}

- (NSString *) stringByDecodingIllegalURLCharacters {
	return [(NSString *)CFURLCreateStringByReplacingPercentEscapes( NULL, (CFStringRef)self, CFSTR( "" ) ) autorelease];
}

@end
