//
//  HNStoryTableViewController.h
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HNStoryTableViewController : UITableViewController {

	NSArray *storyArray;
	
	UIBarButtonItem *searchButton;

	
    // loadSwirlie will display a loading overlay while the data is downloaded from the RSS feed.
    UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic, retain)	NSArray* storyArray;
@property (nonatomic ,retain) 	UIBarButtonItem *searchButton;

- (void)commentsButtonTapped:(id)sender;


@end
