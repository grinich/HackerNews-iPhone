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
#import "HNCommentModel.h"
#import "HNStyle.h"


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
		self.tableViewStyle = UITableViewStylePlain;
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;
		
		[TTStyleSheet setGlobalStyleSheet:[[[HNStyle alloc] init] autorelease]];

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
//	self.tableView.allowsSelection = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
	
	
	/*
	// TODO : Doesn't work! --yet
	UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle:@"Reorder?" 
																	 style:UIBarButtonItemStyleBordered 
																	target:self 
																	action:@selector(commentButtonTouched)];
	
	[self.navigationItem setRightBarButtonItem:commentButton];
	*/
	 
	/*
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	*/
	self.navigationItem.title = @"Comments";
	
}

-(void) commentButtonTouched {
	// Search at http://www.searchyc.com
	
	
	
	NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
								 [NSIndexPath indexPathForRow:0 inSection:0],
								 [NSIndexPath indexPathForRow:1 inSection:0],
								 nil];
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
								 [NSIndexPath indexPathForRow:2 inSection:0],
								 [NSIndexPath indexPathForRow:3 inSection:0],
								 nil];
    UITableView *tv = (UITableView *)self.tableView;
	
    [tv beginUpdates];
    [tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [tv deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tv endUpdates];
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

					 
 
- (void)loadModel {
	self.dataSource =  [[[HNCommentsDataSource alloc] initWithStory:self.storyID] autorelease];
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
	self.modelState = TTModelStateLoaded;
}


- (void)viewDidLoad {
    [super viewDidLoad];
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}






@end



