//
//  HNStoryTableViewController.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewController.h"
#import "HNParser.h"
#import "HNStoryTableViewCell.h"
#import "HNCommentsTableViewController.h"

#import "Three20/Three20.h"

@implementation HNStoryTableViewController

@synthesize storyArray;
@synthesize searchButton;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self performSelectorInBackground:@selector(loadStories) withObject:nil];
	
	searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
																 target:self 
																 action:@selector(activateSearchBar)];
	
	[self.navigationItem setRightBarButtonItem:searchButton];
	
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead" ofType:@"png"];
	//	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"HN-masthead-light" ofType:@"png"];
	
	UIImage* titleImage = [[UIImage alloc] initWithContentsOfFile:imgPath];
	[self.navigationItem setTitleView:[[[UIImageView alloc] initWithImage:titleImage] autorelease]];
	[titleImage release];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) activateSearchBar {
	NSLog(@"Search bar touched!");
	// Do some searching!
}


- (void) loadStories {

	HNParser* sharedParser =  [HNParser sharedHNParser];
	storyArray = [sharedParser getHomeStories];
		
	[self.tableView reloadData];
}




- (void)viewWillAppear:(BOOL)animated {
	
	// Unselect the selected row if any
	NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
	if (selection){
		[self.tableView deselectRowAtIndexPath:selection animated:YES];
	}
		
	
    [super viewWillAppear:animated];
	
	UIColor *HNOrangeColor = [[UIColor alloc] initWithRed:1.0 green:0.3945 blue:0.0 alpha:1];
	[self.navigationController.navigationBar setTintColor:HNOrangeColor];
	[HNOrangeColor release];
	
	
	// TODO : Set with user preference if they're logged in.
	// TODO : Also, choose whether we use the light or dark masthead
	
	//	[navigationController.navigationBar setTintColor:[UIColor blackColor]];
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

#pragma mark -
#pragma mark Table view setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return storyArray.count;
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
	
	
	HNStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		//  cell = [[[HNStoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[HNStoryTableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault
										   reuseIdentifier:(NSString *)CellIdentifier
												 withStory:[storyArray objectAtIndex:indexPath.row]
											 withIndex:indexPath.row];
	} else {
		cell.cellStory = [storyArray objectAtIndex:indexPath.row];
		cell.cellIndex = indexPath.row;
		[cell setupData];
	}
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [HNStoryTableViewCell heightForCellWithStory:(HNStory *)[storyArray objectAtIndex:indexPath.row]];
} 


#pragma mark -
#pragma mark TableView interaction methods

// Go to story URL in browser
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	TTWebController* webController =  [[TTWebController alloc] initWithURL:[(HNStory *)[storyArray objectAtIndex:indexPath.row] url]];
	
	// TODO  - set to be global
	webController.navigationBarTintColor = [[UIColor alloc] initWithRed:1.0 green:0.3945 blue:0.0 alpha:1];

	
	
	//	webController.navigationBarTintColor = [[[UIColor alloc] initWithRed:1.0 green:0.3945 blue:0.0 alpha:1] autorelease];
	
	//webController.navigationBarStyle = UIBarStyleBlackTranslucent;
	
	[self.navigationController pushViewController:webController animated:YES];
	[webController release];
	
}


// Go to comments
- (void)commentsButtonTapped:(id)sender {
	HNCommentsTableViewController *commentViewController = [HNCommentsTableViewController new];
	
	commentViewController.story = [storyArray objectAtIndex:[sender tag]];
	[self.navigationController pushViewController:commentViewController animated:YES];
	[commentViewController release];
		
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


- (void)dealloc {
    [super dealloc];
}


@end

