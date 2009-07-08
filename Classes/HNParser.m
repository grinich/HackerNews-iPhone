//
//  HNParser.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNParser.h"
#import "SynthesizeSingleton.h"

#import "ElementParser.h"
#import "HNStory.h"
#import "CSSSelector.h"



@implementation HNParser
SYNTHESIZE_SINGLETON_FOR_CLASS(HNParser);


- (NSString *) parseWithURLString:(NSString *)urlString {
	NSURL *url = [NSURL URLWithString:urlString];

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
	
	NSLog(@"Number of Cookies: %d", all.count);
	
	for (NSHTTPCookie *cookie in all) 
	{
		NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value); 
	}
	
	return dataString;
}



-(NSArray *) getHomeStories {
	
	NSString *data = [self parseWithURLString:@"http://news.ycombinator.com/"];
	
	Element *document = [Element parseHTML: data];
		
	NSArray *titles =  [document elementsWithCSSSelector:[[CSSSelector alloc] 
														  initWithString:@"tr > td.title > a"]];
	
	NSArray *subtexts = [document elementsWithCSSSelector:[[CSSSelector alloc]
														  initWithString:@"tr > td.subtext"]];
	
	NSMutableArray *stories = [NSMutableArray new];
	
	NSEnumerator* titlesEnumerator = [titles objectEnumerator];
	NSEnumerator* subtextsEnumerator = [subtexts objectEnumerator];
	
	Element* titleElement;
	Element *subtextElement;
	
	// Saves from having to create/destory every time
	NSNumberFormatter* nFormatter = [NSNumberFormatter new];
	NSString *tempString;

	while(	(titleElement = [titlesEnumerator nextObject]) && 
			(subtextElement = [subtextsEnumerator nextObject]))
	{
		HNStory* story  = [HNStory new];
		
		story.title = [titleElement contentsText];
		story.url = [NSURL URLWithString:[[titleElement selectElement:@"a"] attribute:@"href"]];
		story.user = [[subtextElement selectElement:@"a"] contentsText] ;
			
		
		// Either "points" or "point"
		tempString = [[subtextElement selectElement:@"span"] contentsText];
		if ([tempString hasSuffix:@"points"]) {
			story.points = [nFormatter numberFromString:[tempString substringToIndex:[tempString length] - 7]];
		
		} else if ([tempString hasSuffix:@"point"]) {
			story.points = [nFormatter numberFromString:[tempString substringToIndex:[tempString length] - 6]];
		
		} else {
			// No points. WTF?
			story.points = [NSNumber numberWithInt:0];
			NSLog(@"Error parsing points for story.");
		}
		
		
		// Either "xx Comments" or "1 comment" or "discuss"		
		tempString = [[[subtextElement selectElement:@"a"] nextElement] contentsText];
		if ([tempString hasSuffix:@"comments"]){
			// get rid of "comments"
			story.comments_count = [nFormatter numberFromString:[tempString substringToIndex:[tempString length] - 9]];
			
		} else if ([tempString hasSuffix:@"comment"]) {
			story.comments_count = [nFormatter numberFromString:[tempString substringToIndex:[tempString length] - 8]];
			
		} else if ([tempString hasSuffix:@"discuss"]) {
			story.comments_count = [NSNumber numberWithInt:0];
			
		} else {
			// The likely case here is that comments have been disabled for the post.
			// It's probably a job posting or something.
			story.nocomments = TRUE;
			NSLog(@"Error parsing comment for story.");
		}
		


		
//		story.time_ago = 
		
		NSString *idString = [[[subtextElement selectElement:@"span"] attribute:@"id"] substringFromIndex:6];
		
		story.story_id = [nFormatter numberFromString:idString];
		
		
		[stories addObject:story];
		[story release]; 
	}
	[nFormatter release];
	
	return stories;
}



	

@end
