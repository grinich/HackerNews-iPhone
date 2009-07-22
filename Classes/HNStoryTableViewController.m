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


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController



- (void)loadView {
	[super loadView];
	
	/*
	
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
																				  target:self 
																				  action:@selector(activateSearchBar)];
	
	[self.navigationItem setRightBarButtonItem:searchButton];	
	*/
	
	
	loginButton = [[UIBarButtonItem alloc] initWithTitle:@"sometitle" 
													style:UIBarButtonItemStylePlain 
												   target:self
												   action:@selector(buttonTapped)];
	
	[self.navigationItem setLeftBarButtonItem:loginButton];	
	
	
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];
	
	
}

-(void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
	if ([[HNAuth sharedHNAuth] loggedin]) {
		loginButton.title = @"Logout";
	} else {
		loginButton.title = @"Login";
	}
}


-(void) buttonTapped {
	if ([[HNAuth sharedHNAuth] loggedin]) {
		[[HNAuth sharedHNAuth] logout];
		loginButton.title = @"Login";
	} else {
		TTOpenURL(@"tt://login");
	}
	
}


- (void)createModel {
	self.dataSource =  [[[HNStoryDataSource alloc] init] autorelease];	
}

		

@end

