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
#import "URLParser.h"
#import "HNStory.h"
#import "HNComment.h"
#import "CSSSelector.h"



@implementation HNParser
SYNTHESIZE_SINGLETON_FOR_CLASS(HNParser);



- (NSString *) getDataFromURL:(NSURL *)url {

	NSHTTPURLResponse * response;
	NSError * error;
	NSMutableURLRequest *request;
	
	request = [[[NSMutableURLRequest alloc] initWithURL:url
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	
	NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
	NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
		
	/*
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:url];
	
	NSLog(@"Number of Cookies: %d", all.count);
	
	for (NSHTTPCookie *cookie in all) 
	{
		NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value); 
	}
	*/
	
	return dataString;
}



- (NSArray *) getHomeStories {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	// Should be GLOBAL
	NSURL *yc_url = [NSURL URLWithString:@"http://news.ycombinator.com/"];
	
	
	// debug url
	// NSURL = *yc_url = [NSURL URLWithString:@"file:///Users/Michael/Desktop/HackerNews/HN-home-src.html"];

	
	
	NSString *data = [self getDataFromURL:yc_url];
	
	Element *document = [Element parseHTML: data];
	
	
	NSArray *titles = [document elementsWithCSSSelector:[[CSSSelector alloc] 
														 initWithString:@"tr > td > table > tr"]];
	
	NSNumberFormatter* nFormatter = [NSNumberFormatter new];
	
	NSMutableArray *stories = [NSMutableArray new];
	
	NSEnumerator* titlesEnumerator = [titles objectEnumerator];
	
	[titlesEnumerator nextObject];	// We skip the first object
	
	Element *subtextElement;
	
	// Saves from having to create/destory every time
	NSString *pointsTempString;
	NSString *commentsTempString;
	Element* titleElement;
	while(titleElement = [titlesEnumerator nextObject] )
	{
		// At the end
		if ([titleElement hasAttribute:@"style"]) {
			break;
		}
		
		HNStory* story  = [HNStory new];
		
		
		// First Section
		
		// Get the voting objects and URLS from this object
		// [[titleElement firstChild] nextSybling]
		
		// Second Section
		Element* secondElement = [[[titleElement firstChild] nextSybling] nextSybling];
		Element *title = [secondElement firstChild];
		
		// TITLE
		story.title =	[title contentsText];
		
		
		
		
		NSString *tempURLString = [title attribute:@"href"];
		if ( [tempURLString hasPrefix:@"http://"] || 
			[tempURLString hasPrefix:@"https://"]) 
		{
			// Valid
			story.url = [NSURL URLWithString:tempURLString];
		} else {
			// URL is not full length, which means that it's an internal url
			story.internal_story = YES;
			story.url = [[NSURL URLWithString:tempURLString relativeToURL:yc_url] absoluteURL];

		}


		
		// Third Section
		titleElement = [titlesEnumerator nextObject];
		subtextElement = [[titleElement firstChild] nextSybling];
		
		story.user = [[subtextElement selectElement:@"a"] contentsText];
		
		// USER
		pointsTempString = [[subtextElement selectElement:@"span"] contentsText];
		commentsTempString = [[[subtextElement selectElement:@"a"] nextElement] contentsText];

		// TIME SINCE POSTING
		NSInteger location = [pointsTempString length] + 4 + [story.user length] + 1;
		NSInteger length = [[subtextElement contentsText] length] - location - [commentsTempString length] - 3;
		story.time_ago = [[subtextElement contentsText] substringWithRange:NSMakeRange(location, length) ];
		
		// POINTS
		// Either "points" or "point"
		if ([pointsTempString hasSuffix:@"points"]) {
			story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
		
		} else if ([pointsTempString hasSuffix:@"point"]) {
			story.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
		
		} else {
			// No points. WTF?
			story.points = [NSNumber numberWithInt:0];
			NSLog(@"Error parsing points for story.");
		}
		
		// Either "xx Comments" or "1 comment" or "discuss"		
		if ([commentsTempString hasSuffix:@"comments"]){
			// get rid of "comments"
			story.comments_count = [nFormatter numberFromString:[commentsTempString substringToIndex:[commentsTempString length] - 9]];
			
		} else if ([commentsTempString hasSuffix:@"comment"]) {
			story.comments_count = [nFormatter numberFromString:[commentsTempString substringToIndex:[commentsTempString length] - 8]];
			
		} else if ([commentsTempString hasSuffix:@"discuss"]) {
			story.comments_count = [NSNumber numberWithInt:0];
			
		} else {
			// The likely case here is that comments have been disabled for the post.
			// It's probably a job posting or something.
			story.nocomments = TRUE;
			story.comments_count = [NSNumber numberWithInt:0];
			NSLog(@"Error parsing comment for story.");
		}
		
		NSString *idString = [[[subtextElement selectElement:@"span"] attribute:@"id"] substringFromIndex:6];
		
		story.story_id = [nFormatter numberFromString:idString];
		
		[stories addObject:story];
		[story release];
		
		[titlesEnumerator nextObject];
		
		
		/*
		////////////////////////////////////////////////////////
		// For debugging
		NSLog(@"story_id : %@    title : %@   points : %@ 	  user : %@  url : %@  time_ago : %@  comments_count : %@" , story.story_id, story.title, story.points, story.user, story.url, story.time_ago, story.comments_count);

		
		if (story.nocomments) {
			NSLog(@"BOOL		nocomments : YES");
		} else {
			NSLog(@"BOOL		nocomments : NO");

		}
		if (story.internal_story) {
			NSLog(@"BOOL		internal_story : YES");
		} else {
			NSLog(@"BOOL		internal_story : NO");

		}
		////////////////////////////////////////////////////////
		 */
		
		
	}
	return stories;
	[pool release];
}


-(NSArray *) parseCommentsForStoryID:(NSNumber *)storyID  {
	
	// Memory
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	
	NSNumberFormatter* nFormatter = [NSNumberFormatter new];
	
	

	NSURL *url = [NSURL URLWithString:
				  [NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", [storyID stringValue]]];

	NSLog(@"URL to parse: %@", url);
	
	NSString *source = [self getDataFromURL:url];
	
	ElementParser* parser = [ElementParser new];
	//	parser.delegate = self;
	// Should give each comment
	
	//	[parser performSelector:@selector(processCommentItem:) forElementsMatching:@"td.default"];

	
	Element *document = [parser parseHTML:source];;
	
	NSArray *comments = [document selectElements:@"td.default"];

	
	NSEnumerator* commentsEnumerator = [comments objectEnumerator];
	// We skip the first object
	
	
	NSMutableArray *commentsArray = [NSMutableArray new];

	
	Element *element;
	while(element = [commentsEnumerator nextObject] ) {
		HNComment* comment = [HNComment new];
		Element *secondTier = [element selectElement:@"div span.comhead"];
		
		// TODO : allocating this every time is really slow		
		
		comment.text = [[element selectElement:@"span.comment"] contentsText];
		
		comment.contentsSource =  [[[element selectElement:@"span.comment"] selectElement:@"font"] contentsSource];
		
		comment.user = [[[secondTier firstChild] nextElement] contentsText];	// Works
		comment.reply_url =  [[NSURL URLWithString:[[[[secondTier firstChild] nextElement] nextElement] attribute:@"href"] 
									 relativeToURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]]
							  absoluteURL];
		
		// Indenation --> WORKS
		NSNumber *fromSrc = [nFormatter numberFromString:[[[[element parent] firstChild] selectElement:@"img"] attribute:@"width"] ];
		comment.indentationLevel = [NSNumber numberWithInt:([fromSrc intValue] / 40)];
		
		
		NSString *pointsTempString = [[secondTier firstChild] contentsText];	
		
		
		// TODO : do this
		//NSInteger location = [pointsTempString length] + 4 + [comment.user length] + 1;
		//NSInteger length = [[subtextElement contentsText] length] - location - [commentsTempString length] - 3;
		//comment.time_ago = [[subtextElement contentsText] substringWithRange:NSMakeRange(location, length) ];
		
		//comment.url =					//  persistent URL here
		
		//comment.time_ago;
		
		
		
		// POINTS						--- > Works
		// Either "points" or "point"
		if ([pointsTempString hasSuffix:@"points"]) {
			comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 7]];
		} else if ([pointsTempString hasSuffix:@"point"]) {
			comment.points = [nFormatter numberFromString:[pointsTempString substringToIndex:[pointsTempString length] - 6]];
			
		} else {
			// No points. WTF?
			comment.points = [NSNumber numberWithInt:0];
			NSLog(@"Error parsing points for story.");
		}
		[commentsArray addObject:comment];
		
	}
	return commentsArray;
	[pool release];
}
	

@end
