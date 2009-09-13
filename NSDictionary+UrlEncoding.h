//
//  NSDictionary+UrlEncoding.h
//  HackerNews
//
//  Created by Michael Grinich on 7/21/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString;

@end