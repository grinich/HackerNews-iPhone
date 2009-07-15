//
//  HNCommentsTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsTableViewController.h"

#import "HNCommentTableItem.h"
#import "HNCommentTableItemCell.h"
#import "HNCommentsDataSource.h"

@class HNStory, HNCommentTableItem, HNCommentTableItemCell;

@implementation HNCommentsTableViewController

@synthesize storyID = _storyID;

	
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



///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject



- (id)initWithStory:(NSString *)storyIN {
	if (self = [super init]) {
		self.storyID = storyIN;
		self.tableViewStyle = UITableViewStyleGrouped;
//		self.tableViewStyle = UITableViewStylePlain;
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
	
	// TODO : Doesn't work!
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
																 target:self 
																 action:@selector(activateSearchBar)];
	
	[self.navigationItem setRightBarButtonItem:searchButton];
	
	/*
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	*/
	self.navigationItem.title = @"Comments";
	
}

-(void) activateSearchBar {
	// Search at http://www.searchyc.com
	
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController


- (id<TTTableViewDataSource>)createDataSource {
	HNCommentsDataSource *dataSource = [[[HNCommentsDataSource alloc] init] autorelease];
	dataSource.story_id = self.storyID;

	[dataSource.delegates addObject:self];	
//	[dataSource load:TTURLRequestCachePolicyNoCache nextPage:NO];
	
	return dataSource;
}
									 
									 
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[HNCommentTableItem class]]) {
		return [HNCommentTableItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
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



