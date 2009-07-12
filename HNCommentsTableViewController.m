//
//  HNCommentsTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsTableViewController.h"

#import "HNCommentTableViewCell.h"
#import "HNCommentsViewDataSource.h"

@implementation HNCommentsTableViewController


@synthesize story, commentsArray;
	
/*
///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
	[super loadView];
	
	self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
												   style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	self.variableHeightRows = YES;  

	[self.view addSubview:self.tableView];
}

*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)loadView {
	[super loadView];
	self.tableView.allowsSelection = NO;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController
/*
- (id<TTTableViewDataSource>)createDataSource {
	return [HNCommentsViewDataSource commentsViewDataSource:[story story_id]];
}
*/


- (id<TTTableViewDataSource>)createDataSource {
	NSArray* strings = [NSArray arrayWithObjects:
						[TTStyledText textFromXHTML:@"This is a whole bunch of text made from \
						 characters and followed by this URL http://bit.ly/1234"],
						[TTStyledText textFromXHTML:@"Here we have a URL http://www.h0tlinkz.com \
						 followed by another http://www.internets.com"],
						[TTStyledText textFromXHTML:@"http://www.cnn.com is a URL and the words you \
						 are now reading are the text that follows"],
						[TTStyledText textFromXHTML:@"Here is text that has absolutely no styles. \
						 Move along now. Nothing to see here. Goodbye now."],
						//    @"Let's test out some line breaks.\n\nOh yeah.",
						//    @"This is a message with a long URL in it http://www.foo.com/abra/cadabra/abrabra/dabarababa",
						nil];
	NSString* URL = @"tt://styledTextTableTest";
	
	TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
	for (int i = 0; i < 50; ++i) {
		TTStyledText* text = [strings objectAtIndex:i % strings.count];
		
		[dataSource.items addObject:[TTTableStyledTextItem itemWithText:text URL:URL]];
	}
	return dataSource;
}
 
 

- (void)viewDidLoad {
    [super viewDidLoad];
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	UIColor *HNOrangeColor = [[UIColor alloc] initWithRed:1.0 green:0.3945 blue:0.0 alpha:1];
	[self.navigationController.navigationBar setTintColor:HNOrangeColor];
	[HNOrangeColor release];
	
	// Add the "Comment" button
	UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle:@"Comment" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																	 action:@selector(addComment)];
	
	[self.navigationItem setRightBarButtonItem:commentButton];
	[commentButton release];
}

-(void) addComment {
	// push to add comment view
}






- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}






@end



