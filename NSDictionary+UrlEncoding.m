//
//  NSDictionary+UrlEncoding.m
//  HackerNews
//
//  Created by Michael Grinich on 7/21/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"


// private helper function to convert any object to its string representation
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

// private helper function to convert string to UTF-8 and URL encode it
static NSString *urlEncode(id object) {
	NSString *string = toString(object);
	return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


@implementation NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", 
						  urlEncode(key), urlEncode(value)];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

@end
