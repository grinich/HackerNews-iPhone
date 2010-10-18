//
//  HNStoryTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewController.h"
#import "HNStoryDataSource.h"
#import "HNAuth.h"
#import "HNStory.h"
#import "HNStoryModel.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"

#import "LoginViewController.h"

@class HNStory, HNStoryTableItemCell;

@implementation HNStoryTableViewController

@synthesize loginButton;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tableViewStyle = UITableViewStylePlain;
		self.variableHeightRows = YES;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(loginButton);
	[super dealloc];
}




///////////////////////////////////////////////////////////////////////////////////////////////////

- (id<UITableViewDelegate>)createDelegate {
	//return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
	// Drag to refresh instead
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}




- (void)loadView {
	[super loadView];
	
	/*
	 // TODO : Add search!
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
																				  target:self 
																				  action:@selector(activateSearchBar)];
	
	[self.navigationItem setRightBarButtonItem:searchButton];	
	*/
	
	
	// Login Button
	
	loginButton = [[UIBarButtonItem alloc] initWithTitle:@"" 
													style:UIBarButtonItemStylePlain 
												   target:self
												   action:@selector(buttonTapped)];
	
	[self.navigationItem setLeftBarButtonItem:loginButton];	
		
		
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	
	
	/*
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	*/
	
	self.navigationItem.title = @"Stories";
}



-(void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
	
	if ([[HNAuth sharedHNAuth] loggedin]) {
		loginButton.title = @"Logout";
	} else {
		loginButton.title = @"Login";
	}


}


// This lets us serialize the story object to pass it on
// see http://groups.google.com/group/three20/browse_thread/thread/17531b9efbf243a3/4d95e930810e226e#4d95e930810e226e

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
	
	if ([object respondsToSelector:@selector(URLValue)]) {
		HNStory *story = [(HNStoryTableItem*)object story];
		
		NSString* URL = [story.url absoluteString];
		if (URL) {
			NSDictionary* query = [[NSDictionary alloc] initWithObjectsAndKeys:story, @"story", nil ];

			TTURLAction *action = [[[TTURLAction actionWithURLPath:URL] applyQuery:query] applyAnimated:YES];
			
			[[TTNavigator navigator] openURLAction:action]; 	
			
		}
	}
}


-(void) buttonTapped {
	if ([[HNAuth sharedHNAuth] loggedin]) {
		UIAlertView* logoutAlert = [[[UIAlertView alloc] initWithTitle:@"Are you sure?"
																   message:@"Are you sure you wish to logout?"
																  delegate:self
														 cancelButtonTitle:@"Yes"
														 otherButtonTitles:@"No", nil] autorelease];
		[logoutAlert show];
	} else {
		
		
//		[self.navigationController presentModalViewController:[LoginViewController new] 
//													 animated:YES		 ];
		[self.navigationController pushViewController:[LoginViewController new]
											 animated:YES];
		
		
		 //TTOpenURL(@"tt://login");
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[HNAuth sharedHNAuth] logout];
		loginButton.title = @"Login";
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	self.dataSource = [[HNStoryDataSource new] autorelease];
}


		

@end

