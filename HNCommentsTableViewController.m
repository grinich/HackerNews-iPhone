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
#import "HNCommentReplyItem.h"
#import "LoadingView.h"



@class HNStory, HNCommentTableItem, HNCommentTableItemCell;

@implementation HNCommentsTableViewController

@synthesize storyID = _storyID;
@synthesize composing;
@synthesize replyCommentItem;

	
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
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(voteUp:) 
													 name:@"voteUpNotification" 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(voteDown:) 
													 name:@"voteDownNotification" 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(finishSubmittingComment:) 
													 name:@"commentSubmittedNotification" 
												   object:nil];
		
		self.composing = NO;	

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
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
	self.navigationItem.title = @"Comments";
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController



// TODO: Move both of these methods to HNCommentModel
-(void)voteUp:(NSNotification *)notification {
	if (!self.composing) {
		HNCommentTableItemCell *commentCell = (HNCommentTableItemCell*)notification.object;
		
		commentCell.cellComment.voted = YES;
		
		int i = [commentCell.cellComment.points intValue];
		commentCell.cellComment.points = [NSNumber numberWithInt:i + 1];
		[self.tableView reloadData];
		
		[commentCell.cellComment voteUpWithDelegate:self];
	}
}

		 
		 
-(void)voteDown:(NSNotification *)notification {
	if (!self.composing) {
		HNCommentTableItemCell *commentCell = (HNCommentTableItemCell*)notification.object;
		
		commentCell.cellComment.voted = YES;
		
		int i = [commentCell.cellComment.points intValue];
		commentCell.cellComment.points = [NSNumber numberWithInt:i - 1];
		[self.tableView reloadData];
		
		[commentCell.cellComment voteUpWithDelegate:self];
	}
}



- (void)replyToComment:(NSNotification *)notification {
	
	if (!self.composing) {
		self.composing = YES;
		
		HNCommentTableItem *replyCell = ((HNCommentTableItemCell*)notification.object).object;
		
		NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
		
		NSUInteger index = [listItems indexOfObject:replyCell];
		
		replyCommentItem = [[HNCommentReplyItem alloc] init];
		
		replyCommentItem.textView.font = TTSTYLEVAR(font);
		replyCommentItem.backgroundColor = TTSTYLEVAR(backgroundColor);
		replyCommentItem.autoresizesToText = YES;
		replyCommentItem.minNumberOfLines = 3;
		replyCommentItem.showsExtraLine = YES;
		replyCommentItem.textDelegate = self;
		replyCommentItem.aboveComment = replyCell.comment;
				
		
		
		if (index + 1 == [listItems count]) {
			[listItems addObject:replyCommentItem];
		} else {
			[listItems insertObject:replyCommentItem atIndex:index +1];
		}

		
		UITableView * tv = self.tableView;
		
		// TODO : Doesn't work! --yet
		UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" 
																		 style:UIBarButtonItemStyleBordered 
																		target:self 
																		action:@selector(submitComment:)];
		
		[self.navigationItem setRightBarButtonItem:submitButton];
		
		// Hide the back button
		self.navigationController.navigationBar.backItem.hidesBackButton = YES;
		
		UIBarButtonItem *cancelButon = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																		style:UIBarButtonItemStyleBordered 
																	   target:self 
																	   action:@selector(cancelComment:)];
		[self.navigationItem setLeftBarButtonItem:cancelButon];
		
		self.navigationItem.title = @"Reply";
		
		[tv beginUpdates];
		[tv insertRowsAtIndexPaths:[NSArray arrayWithObject:
									[NSIndexPath indexPathForRow:(index +1) inSection:0]]
				  withRowAnimation:UITableViewRowAnimationFade];
		
		[tv endUpdates];
				
		
		// TODO: This is a bug. If we becomeFirstResponder at the last row, it crashes.
		if (index + 2 < [listItems count]) {
			[replyCommentItem.textView becomeFirstResponder];
		} 
		 
		
	}
}
		

// Delegate method for resizing the reply comment box.
// We need to call reload data so when it expands, it doesn't
// write over the next cell.
- (BOOL)textEditor:(TTTextEditor*)textEditor shouldResizeBy:(CGFloat)height {
	textEditor.frame = TTRectContract(textEditor.frame, 0, -height);
	[self.tableView reloadData];
	return NO;
}



 

-(void)submitComment:(UIButton*)sender {
	[replyCommentItem.textView resignFirstResponder];
		
	[(HNCommentModel*)self.model replyWithItem:replyCommentItem];
	
	replyLoadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
	
	
	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:replyCommentItem];
		
	
	HNComment* c = [[HNComment alloc] init];
	c.contentsSource = replyCommentItem.text;
	c.text = replyCommentItem.text;
	c.voted = YES;
	c.deletable = YES;
	//	c.deleteURL		// TODO
	c.replyEnabled = NO;
	c.user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	c.points = [NSNumber numberWithInt:1];
	c.time_ago = @"0 minutes ago";
	c.indentationLevel = [NSNumber numberWithInt:
						  [replyCommentItem.aboveComment.indentationLevel intValue] + 1 ];
	
	
	[listItems removeObjectAtIndex:index];
	[listItems insertObject:[HNCommentTableItem itemWithComment:c] atIndex:index];
	replyCommentItem = nil;
	
}

- (void)finishSubmittingComment:(NSNotification *)notification {	
	[replyLoadingView removeView];
	
	self.navigationItem.title = @"Comments";
	[self.navigationItem setRightBarButtonItem:nil];
	[self.navigationItem setLeftBarButtonItem:nil];
	self.navigationController.navigationBar.backItem.hidesBackButton = NO;
	[self.tableView reloadData];
	self.composing = NO;
	
}

-(void)dismissKeyboard:(NSDictionary *)aDictionary
{
	[[aDictionary objectForKey:@"loadingView"] removeView];
	[[aDictionary objectForKey:@"textField"] resignFirstResponder];
}


-(void)cancelComment:(UIButton*)sender {
	
	[replyCommentItem.textView resignFirstResponder];

	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:replyCommentItem];
	
	
	[listItems removeObjectAtIndex:index];
	
	UITableView * tv = self.tableView;

	[tv beginUpdates];
	[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:
								[NSIndexPath indexPathForRow:index inSection:0]]
			  withRowAnimation:UITableViewRowAnimationFade];
	
	[tv endUpdates];	
	
	self.navigationItem.title = @"Comments";
	// Todo: hide these instead of just init/release ?
	[self.navigationItem setRightBarButtonItem:nil];
	[self.navigationItem setLeftBarButtonItem:nil];
	self.navigationController.navigationBar.backItem.hidesBackButton = NO;
	
	self.composing = NO;
}


 
- (void)createModel {
	self.dataSource =  [[HNCommentsDataSource alloc] initWithStory:self.storyID];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[TTURLRequestQueue mainQueue] cancelAllRequests];
	[super viewWillDisappear:animated];
}
	

- (void)viewDidLoad {
    [super viewDidLoad];
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//- (void)viewWillAppear:(BOOL)animated {
//	[self refresh];
//    [super viewWillAppear:animated];
//}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}






@end



