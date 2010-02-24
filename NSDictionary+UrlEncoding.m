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
	NSString *unencodedString = toString(object);
	//return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	// This works better. From here: http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
	
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)unencodedString,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
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
