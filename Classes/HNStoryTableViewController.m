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
#import "HNStoryModel.h"
#import "HNStoryTableItem.h"
#import "HNStoryTableItemCell.h"



@class HNStory, HNStoryTableItemCell;

@implementation HNStoryTableViewController

@synthesize loginButton;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		self.tableViewStyle = UITableViewStylePlain;
		self.variableHeightRows = YES;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(loginButton);
	[super dealloc];
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController



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

	
	if (!self.dataSource) {
		HNStoryDataSource* ds= [[[HNStoryDataSource alloc] init] autorelease];
		if (!_model) {
			ds.model = [[HNStoryModel alloc] init];
		}
		self.dataSource =  ds;	
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
		TTOpenURL(@"tt://login");
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[HNAuth sharedHNAuth] logout];
		loginButton.title = @"Login";
	}
}


- (void)createModel {
	HNStoryDataSource* ds= [[HNStoryDataSource new] autorelease];
	ds.model = [HNStoryModel new];
	self.dataSource =  ds;	
}



// Todo: reload code
/* 

- (BOOL)shouldReload {
	if (( [((HNStoryDataSource*)self.dataSource).items count] < 1 )  && (!_flags.isModelFirstTimeInvalid)) {
		return YES;
	} else {
		return [super shouldReload];
	}
}

*/ 



//- (BOOL)shouldLoadMore;

		

@end

