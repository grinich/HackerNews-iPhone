//
//  HNCommentsTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/10/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNCommentsTableViewController.h"
#import "HNParser.h"
#import "HNCommentTableViewCell.h"


@implementation HNCommentsTableViewController

@synthesize story, commentsArray;
	

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self performSelectorInBackground:@selector(loadComments:) withObject:nil];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) loadComments:(id)sender {
	HNParser* sharedParser =  [HNParser sharedHNParser];
	
	self.commentsArray = [sharedParser parseCommentsForStoryID:[story story_id]];
	
	NSLog(@"Done parsing. Comment Objects: %@", commentsArray);
	
	//[self.tableView reloadData];
}




- (void)viewWillAppear:(BOOL)animated {

	
	
    [super viewWillAppear:animated];
	
	UIColor *HNOrangeColor = [[UIColor alloc] initWithRed:1.0 green:0.3945 blue:0.0 alpha:1];
	[self.navigationController.navigationBar setTintColor:HNOrangeColor];
	[HNOrangeColor release];
	
	
	
	// Add the "Comment" button
	UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle:@"Comment" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																	 action:@selector(addComment)];
	
	[self.navigationItem setRightBarButtonItem:commentButton];
	[commentButton release];
}

-(void) addComment {
	// push to add comment view
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	 */
    
	HNCommentTableViewCell *cell = (HNCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		//  cell = [[[HNStoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[HNCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault
											 reuseIdentifier:(NSString *)CellIdentifier
												 withComment:[commentsArray objectAtIndex:indexPath.row]
												   withIndex:indexPath.row];
	} else {
		cell.cellComment = [commentsArray objectAtIndex:indexPath.row];
		cell.cellIndex = indexPath.row;
		[cell setupData];
		
	}
	
	[cell setNeedsLayout];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [HNCommentTableViewCell heightForCellWithComment:[commentsArray objectAtIndex:indexPath.row]];
;
} 

#pragma mark -
#pragma mark TableView interaction methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




@end



