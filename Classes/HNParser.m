//
//  HNParser.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNParser.h"

#import "ElementParser.h"

@implementation HNParser

- (HNParser *) initHNParser {
	[super init];
	appDelegate = (HackerNewsAppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}


- (void) parse {
	NSURL *url = [NSURL URLWithString:@"http://news.ycombinator.com/"];
	
	
	NSHTTPURLResponse * response;
	NSError * error;
	NSMutableURLRequest *request;
	
	request = [[[NSMutableURLRequest alloc] initWithURL:url
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	
	NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
	NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	
	//NSLog(@"%@", dataString);
	
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:url];
	
	NSLog(@"%d", all.count);
	
	for (NSHTTPCookie *cookie in all) 
	{
		NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value); 
	}
	
	Element *document = [Element parseHTML: dataString];
	
	//Element *next;
	//next = [document selectElement:@"td.title"];
		
	NSArray *titles =  [document elementsWithCSSSelector:[[CSSSelector alloc] initWithString:@"tr > td.title > a"]];
	
	// Enumerate through the title elements.
	NSEnumerator *e = [titles objectEnumerator];
	id titleElement;
	while ( (titleElement = [e nextObject]) ) {
		NSLog(@"%@", (Element *)[titleElement contentsText] );
	}
	
	
	/*
	int i;
	for (i=0; i<50; i++) {
		NSLog(@"%@", [next contentsText]);

//		NSLog(@"%@  ---  %@", [next tagName], [next attributes]);
		next = [next nextElement];
	}
	*/

	
//	ElementParser* parser = [[ElementParser alloc] initWithCallbacksDelegate: self];
//	
//	[parser performSelector:@selector(gotFeedElement:) forElementsMatching: @"feed"];
//	
//	documentRoot = [parser parseXML: source];
//	
//	document = [Element parseHTML: source];
}



	

@end
