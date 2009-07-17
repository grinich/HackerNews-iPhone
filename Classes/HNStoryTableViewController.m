//
//  HNStoryTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewController.h"
#import "HNStoryDataSource.h"


#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"

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
	
	
	UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" 
																	style:UIBarButtonItemStylePlain 
																   target:self
																   action:@selector(loginButtonTapped)];

	
	[self.navigationItem setLeftBarButtonItem:loginButton];
	
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	
	
}

-(void) loginButtonTapped {
	// Jump to login logic!
	TTOpenURL(@"tt://login");

	
}
 
- (void) activateSearchBar {
	// Do something!
	
	NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
								 [NSIndexPath indexPathForRow:2 inSection:0],
								 [NSIndexPath indexPathForRow:4 inSection:0],
								 nil];
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
								 [NSIndexPath indexPathForRow:0 inSection:0],
								 [NSIndexPath indexPathForRow:3 inSection:0],
								 nil];
    UITableView *tv = (UITableView *)self.tableView;
	
    [tv beginUpdates];
    [tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [tv deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tv endUpdates];
	
}


- (void)loadModel {
	self.dataSource =  [[[HNStoryDataSource alloc] init] autorelease];	
}


- (void)modelDidFinishLoad:(id<TTModel>)model {
	self.modelState = TTModelStateLoaded;
}




/*
 // TODO: Do stuff!?
- (void)modelDidChangeState {
	if (self.modelState == TTModelStateLoading) {
		self.title = @"StateLoading";
	} else if (self.modelState == TTModelStateEmpty) {
		self.title = @"StateEmpty";
	} else if (self.modelState == TTModelStateLoadedError) {
		self.title = @"StateLoadedError";
	} else if (self.modelState == TTModelStateLoaded) {
		self.title = @"StateLoaded";
	}
}
*/


		

@end

