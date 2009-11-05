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
#import "LoadingView.h"
#import "HNCommentHeaderItemCell.h"
#import "HNCommentHeaderItem.h"
#import "HNStory.h"


@class HNStory, HNCommentTableItem, HNCommentTableItemCell;

@implementation HNCommentsTableViewController

@synthesize storyID;
@synthesize composing;

	
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

- (void)dealloc {
	TT_RELEASE_SAFELY(storyID);
	[super dealloc];
}


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
		
		// Header reply. Requires different reply comment.
		if ( [notification.object isKindOfClass:[HNCommentHeaderItemCell class]] ){
			HNCommentHeaderItemCell *headerCell = (HNCommentHeaderItemCell*)notification.object;			
			headerCell.cellStory.voted = YES;
			
			// TODO :Deal with this later
			/*
			int i = [commentCell.cellComment.points intValue];
			commentCell.cellComment.points = [NSNumber numberWithInt:i + 1];
			*/
			[self.tableView reloadData];
			[headerCell.cellStory voteUpWithDelegate:self];
			
		}
		
		// Regular Reply
		else if ([notification.object isKindOfClass:[HNCommentTableItemCell class]]) {
		
			HNCommentTableItemCell *commentCell = (HNCommentTableItemCell*)notification.object;			
			commentCell.cellComment.voted = YES;
			int i = [commentCell.cellComment.points intValue];
			commentCell.cellComment.points = [NSNumber numberWithInt:i + 1];
			[self.tableView reloadData];
			
			[commentCell.cellComment voteUpWithDelegate:self];
		}	
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
	/*
	
	if (!self.composing) {
		self.composing = YES;
		NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
				
		
		NSUInteger index = [listItems indexOfObject:[[notification object] object]];
		
		// Header reply. Requires different reply comment.
		if ( [notification.object isKindOfClass:[HNCommentHeaderItemCell class]] ){
			
			HNCommentHeaderItem *headerCell = ((HNCommentHeaderItemCell*)notification.object).object;
			
			replyCommentItem = [[HNCommentReplyItem alloc] init];
			replyCommentItem.textView.font = TTSTYLEVAR(font);
			replyCommentItem.backgroundColor = TTSTYLEVAR(backgroundColor);
			replyCommentItem.autoresizesToText = YES;
			replyCommentItem.minNumberOfLines = 3;
			replyCommentItem.showsExtraLine = YES;
			replyCommentItem.textDelegate = self;
			replyCommentItem.indentationLevel = 0;
			replyCommentItem.replyFNID = headerCell.story.replyFNID;
						
			[listItems insertObject:replyCommentItem atIndex:1]; 
			
			
		
		} 
		
		// Regular Reply
		else if ([notification.object isKindOfClass:[HNCommentTableItemCell class]]) {
			HNCommentTableItem *replyCell = ((HNCommentTableItemCell*)notification.object).object;
						
			replyCommentItem = [[HNCommentReplyItem alloc] init];
			replyCommentItem.textView.font = TTSTYLEVAR(font);
			replyCommentItem.backgroundColor = TTSTYLEVAR(backgroundColor);
			replyCommentItem.autoresizesToText = YES;
			replyCommentItem.minNumberOfLines = 3;
			replyCommentItem.showsExtraLine = YES;
			replyCommentItem.textDelegate = self;
			replyCommentItem.indentationLevel = [NSNumber numberWithInt:
												 [replyCell.comment.indentationLevel intValue] + 1 ];
						
			if (index + 1 == [listItems count]) {
				[listItems addObject:replyCommentItem];
			} else {
				[listItems insertObject:replyCommentItem atIndex:index +1];
			}
		}
		

		
		UITableView * tv = self.tableView;
		
		// TODO : Doesn't work! --yet
		UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" 
																		 style:UIBarButtonItemStyleBordered 
																			target:self 
																		action:@selector(submitComment:)];
		
		[self.navigationItem setRightBarButtonItem:submitButton];
		[submitButton release];
		// Hide the back button
		self.navigationController.navigationBar.backItem.hidesBackButton = YES;
		
		UIBarButtonItem *cancelButon = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																		style:UIBarButtonItemStyleBordered 
																	   target:self 
																	   action:@selector(cancelComment:)];
		[self.navigationItem setLeftBarButtonItem:cancelButon];
		[cancelButon release];
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
	 
	*/
	
	DLog(@"Reply notification.");
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
	
	DLog(@"Submit comment");
	
	
	/* 
	 
	[replyCommentItem.textView resignFirstResponder];
	
	[(HNCommentModel*)self.model replyWithItem:replyCommentItem];
	
	// add loading view
	replyLoadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
	
	// We're going to remove the replyCommentItem. Find the index.
	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:replyCommentItem];
	
	// New comment to replace it.
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
	c.indentationLevel = replyCommentItem.indentationLevel;
	
	// Swap
	[listItems removeObjectAtIndex:index];
	[listItems insertObject:[HNCommentTableItem itemWithComment:c] atIndex:index];
	[c release];
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
	 
	*/
	
}


-(void)cancelComment:(UIButton*)sender {
	/*
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
	 */
}

 
- (void)createModel {
	HNCommentsDataSource* ds=  [[HNCommentsDataSource new] autorelease];
	ds.model = [HNCommentModel new];
	((HNCommentModel*)ds.model).story_id = self.storyID;
	
	self.dataSource =  ds;	
}

-(void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
	
	if (!self.dataSource) {
		HNCommentsDataSource* ds=  [[[HNCommentsDataSource alloc] init] autorelease];
		if (!_model) {
			ds.model = [HNCommentModel new];
			((HNCommentModel*)ds.model).story_id = self.storyID;		
		}
		self.dataSource =  ds;	
	}
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



