//
//  HNStoryTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "Three20/Three20.h"


@interface HNStoryTableViewController : TTTableViewController {

	UIBarButtonItem *loginButton;
	
}

@property(nonatomic,retain) UIBarButtonItem *loginButton;

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

@end
