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

@class HNStory, HNCommentTableItem, HNCommentTableItemCell;

@implementation HNCommentsTableViewController

@synthesize storyID;
@synthesize replyCommentItem;


// TODO: update this to new three20 tableview controller

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
		
	}
	return self;
}



- (void)loadView {
	[super loadView];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
	self.navigationItem.title = @"Comments";
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

-(void)finishSubmittingComment:(NSNotification *)notification {
	
	DLog(@"Comment submitted successfully... I think.");
}




- (void)replyToComment:(NSNotification *)notification {

	
	HNPostController* postController = [HNPostController new];
	
	
	// Header reply
	if ( [notification.object isKindOfClass:[HNCommentHeaderItemCell class]] ){
		HNCommentHeaderItem *headerCell = ((HNCommentHeaderItemCell*)notification.object).object;
		postController.replyFNID = headerCell.story.replyFNID;
	} 
	
	// Regular Reply
	else if ([notification.object isKindOfClass:[HNCommentTableItemCell class]]) {
		// We don't have the FNID.
	}
	
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol
	self.popupViewController = postController;
	postController.superController = self; // assuming self to be the current UIViewController
	
	[postController showInView:self.view animated:YES];
		
	[postController release];
		
}
		


#pragma mark -
#pragma mark TTPostControllerDelegate methods


// Returns with posted text

- (void)postController:(TTPostController*)postController
		   didPostText:(NSString *)text
			withResult:(id)result {
	
	
	DLog(@"Text: %@", text);
		
	replyCommentItem.text = text;
	
	[(HNCommentModel*)self.model replyWithItem:replyCommentItem];
	
	// add loading view
	
	// We're going to remove the replyCommentItem. Find the index.
	NSMutableArray* listItems = ((HNCommentsDataSource*)self.dataSource).items;
	NSUInteger index = [listItems indexOfObject:replyCommentItem];
	
	/*
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
	
	*/
}

@end



