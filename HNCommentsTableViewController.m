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
#import "HNComment.h"


static CGFloat kIndentationPadding = 10;
static CGFloat kHPadding = 10;




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
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(replyToComment:) 
													 name:@"replyButtonNotification" 
												   object:nil];
		 

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


-(void)replyToComment:(NSNotification *) notification {
	
	HNCommentTableItem *replyCell = ((HNCommentTableItemCell*)notification.object).object;
	
	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	
	NSUInteger index = [listItems indexOfObject:replyCell];


	/*
	CGFloat maxWidth = 300;
	CGFloat indent_by = kIndentationPadding * [[replyCell.comment indentationLevel] floatValue];

	
	CGRect frame =  CGRectMake( kHPadding + indent_by, 
							   0.0, 
							   maxWidth - indent_by,
							   84.0);
	*/
	 
	TTTextEditor* editor = [[[TTTextEditor alloc] init] autorelease];
	
	
	
    editor.textView.font = TTSTYLEVAR(font);
    editor.backgroundColor = TTSTYLEVAR(backgroundColor);
    editor.autoresizesToText = NO;
    editor.minNumberOfLines = 6;

	[listItems insertObject:editor atIndex:index +1];
		
	
	
	UITableView * tv = self.tableView;
	
	
	
	 // TODO : Doesn't work! --yet
	 UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(doneComment:)];
	 
	 [self.navigationItem setRightBarButtonItem:doneButton];
	
	// Hide the back button
	self.navigationController.navigationBar.backItem.hidesBackButton = YES;
	
	UIBarButtonItem *cancelButon = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																   action:@selector(doneComment:)];
	
	[self.navigationItem setLeftBarButtonItem:cancelButon];

	self.navigationItem.title = @"Reply";

	[tv beginUpdates];
	[tv insertRowsAtIndexPaths:[NSArray arrayWithObject:
								[NSIndexPath indexPathForRow:(index +1) inSection:0]]
			  withRowAnimation:UITableViewRowAnimationBottom];
	
	[tv endUpdates];
	[editor.textView becomeFirstResponder];
}
		
-(void)doneComment:(UIButton*)sender {

	self.navigationItem.title = @"Comments";
	
	// Todo: hide these instead of just init/release ?
	[self.navigationItem setRightBarButtonItem:nil];
	[self.navigationItem setLeftBarButtonItem:nil];
	self.navigationController.navigationBar.backItem.hidesBackButton = NO;

}

 
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



