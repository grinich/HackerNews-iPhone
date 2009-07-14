//
//  HNStoryTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewController.h"
#import "HNStoryDataSource.h"

@class HNStory, HNStoryTableItemCell;

@implementation HNStoryTableViewController



///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		self.tableViewStyle = UITableViewStylePlain;
		self.variableHeightRows = YES;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController



- (void)loadView {
	[super loadView];
	
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
																				  target:self 
																				  action:@selector(activateSearchBar)];
	
	[self.navigationItem setRightBarButtonItem:searchButton];	
	
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	
	
}
 
- (void) activateSearchBar {
	// Do something!
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTViewController

- (id<TTTableViewDataSource>)createDataSource {
	
	HNStoryDataSource *dataSource = [[[HNStoryDataSource alloc] init] autorelease];
	[dataSource.delegates addObject:self];
	
	[dataSource load:TTURLRequestCachePolicyNoCache nextPage:NO];
	
	//	return [HNStoryDataSource hnStoryDataSource];
	return dataSource;
}		

		
		

@end

