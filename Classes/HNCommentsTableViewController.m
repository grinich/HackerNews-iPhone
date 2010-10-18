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

#import "HNCommentHeaderItemCell.h"
#import "HNCommentHeaderItem.h"
#import "HNStory.h"

#import "HNPostController.h"
#import "GTMNSString+HTML.h"

@class HNStory, HNCommentTableItem, HNCommentTableItemCell;

@implementation HNCommentsTableViewController

@synthesize storyID;


// TODO: update this to new three20 tableview controller

- (id)initWithStory:(NSString *)storyIN {
	if (self = [self init]) {
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
		
	}
	return self;
}


- (id)init {
	return [super initWithNibName:nil bundle:nil];
}

- (void)loadView {
	[super loadView];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
	self.navigationItem.title = @"Comments";
}

#pragma mark -
#pragma mark Data

- (id<UITableViewDelegate>)createDelegate {
	
	// For Drag-to-refresh 
	//return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
	
	return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];

}


- (void)createModel {
	self.dataSource = [[[HNCommentsDataSource alloc] initWithStoryID:self.storyID] autorelease];
}

#pragma mark after view loading

/*
-(void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[[TTURLRequestQueue mainQueue] cancelAllRequests];
	[super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark Memory

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	TT_RELEASE_SAFELY(storyID);
	[super dealloc];
}



#pragma mark -
#pragma mark Voting 


// TODO: Move both of these methods to HNCommentModel
-(void)voteUp:(NSNotification *)notification {
		
	// Header reply. Requires different reply comment.
	if ( [notification.object isKindOfClass:[HNCommentHeaderItemCell class]] ){
		HNCommentHeaderItemCell *headerCell = (HNCommentHeaderItemCell*)notification.object;			
		headerCell.cellStory.voted = YES;
		
		// TODO :Deal with this later
		
		int i = [headerCell.cellStory.points intValue];
		headerCell.cellStory.points = [NSNumber numberWithInt:i + 1];
		
		
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

		 
		 
-(void)voteDown:(NSNotification *)notification {
	HNCommentTableItemCell *commentCell = (HNCommentTableItemCell*)notification.object;
	
	commentCell.cellComment.voted = YES;
	
	int i = [commentCell.cellComment.points intValue];
	commentCell.cellComment.points = [NSNumber numberWithInt:i - 1];
	[self.tableView reloadData];
	
	[commentCell.cellComment voteUpWithDelegate:self];
}


#pragma mark -
#pragma mark Commenting 



- (void)replyToComment:(NSNotification *)notification {
	
	HNPostController* postController = [HNPostController new];
	
	// Header reply
	if ( [notification.object isKindOfClass:[HNCommentHeaderItemCell class]] ){
		HNCommentHeaderItem *headerCell = ((HNCommentHeaderItemCell*)notification.object).object;
		postController.replyFNID = headerCell.story.replyFNID;
	} 
	
	// Regular Reply
	else if ([notification.object isKindOfClass:[HNCommentTableItemCell class]]) {
		// We don't have the FNID, but we have the comment object

	}
	
	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:[[notification object] object]];
	
	// TODO : Check what type it is, and set a flag.
	postController.replyCellObject = [listItems objectAtIndex:index];
	
	
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol
	self.popupViewController = postController;
	postController.superController = self; // assuming self to be the current UIViewController
	[postController showInView:self.view animated:YES];
	[postController release];
}
		


#pragma mark -
#pragma mark TTPostControllerDelegate methods


// Returns with posted text

- (void)postController:(HNPostController*)postController
		   didPostText:(NSString *)text
			withResult:(id)result {
	
	HNCommentTableItem* replyToComment = postController.replyCellObject;

	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:replyToComment];
	
	
	// New comment to put in the view.
	
	HNComment* c = [[HNComment alloc] init];
	c.contentsSource = [text gtm_stringByEscapingForHTML];
	c.text = text;
	c.voted = YES;
	
	c.deletable = YES;
	//	c.deleteURL		// TODO
	
	c.replyEnabled = NO;
	c.user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	c.points = [NSNumber numberWithInt:1];
	c.time_ago = @"0 minutes ago";
	
	if ([replyToComment isKindOfClass:[HNCommentHeaderItem class]]) {
		// replyToComment is a HNCommentHeaderItem
		c.indentationLevel = [NSNumber numberWithInt:0];
	} else {
		// replyToComment is a HNCommentTableItem
		c.indentationLevel = [NSNumber numberWithInt:
							  [replyToComment.comment.indentationLevel intValue] + 1 ];
	}
	

	HNCommentTableItem *replyItem = [HNCommentTableItem itemWithComment:c];

	if (index + 1 == [listItems count]) {
		[listItems addObject:replyItem];
	} else {
		[listItems insertObject:replyItem atIndex:index +1];
	}
	
	
	UITableView * tv = self.tableView;

	[tv beginUpdates];
	[tv insertRowsAtIndexPaths:[NSArray arrayWithObject:
								[NSIndexPath indexPathForRow:(index +1) inSection:0]]
			  withRowAnimation:UITableViewRowAnimationFade];
	
	[tv endUpdates];
	
	
}



@end



