//
//  LoginViewController.m
//  Quizlet
//
//  Created by Michael Grinich on 6/30/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "LoginViewController.h"

#import "HNAuth.h"
#import "HNStyle.h"
#import "MBProgressHUD.h"


#define kTextFieldWidth		260.0
#define kLeftMargin			20.0
#define kTextFieldHeight	30.0

static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kViewKey = @"viewKey";

@implementation LoginViewController
@synthesize usernameTextField, passwordTextField, dataSourceArray;



- (id)initWithStyle:(UITableViewStyle)style {	
	[super initWithStyle:UITableViewStyleGrouped];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(successfulLogin:) 
												 name:@"successfulLoginNotification" 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(failedLogin:) 
												 name:@"failedLoginNotification" 
											   object:nil];
	
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.scrollEnabled = NO;
	
	self.dataSourceArray = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Username", kSectionTitleKey,
							 self.usernameTextField, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Password", kSectionTitleKey,
							 self.passwordTextField, kViewKey,
							 nil],
							nil];
	
	self.title = @"Login";
	[self.navigationController.navigationBar setTintColor:TTSTYLEVAR(navigationBarTintColor)];
	
	
	// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	self.editing = NO;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];	
	[usernameTextField becomeFirstResponder];

}

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
	[usernameTextField release];
	usernameTextField = nil;		
	[passwordTextField release];
	passwordTextField = nil;	
	
	self.dataSourceArray = nil;

}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.dataSourceArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.dataSourceArray objectAtIndex: section] valueForKey:kSectionTitleKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	UITextField *textField = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kViewKey];
	[cell.contentView addSubview:textField];
	
    return cell;
}



#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == usernameTextField) {
		[usernameTextField resignFirstResponder];
		[passwordTextField becomeFirstResponder];
		return NO;
	} else if (textField == passwordTextField) {
		// [textField resignFirstResponder];
		
		// LOGIN!!!!
		
		
		NSURL *hnURL = [NSURL URLWithString:@"http://news.ycombinator.com"];
		
		NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hnURL];
		
		if ([cookies count] > 0 ) {
			
			DLog(@"Logging Cookies\nName: %@", [[cookies objectAtIndex:0] name]);
			DLog(@"Name: %@", [[cookies objectAtIndex:0] value]);
			
		} else {
					
			self.navigationItem.hidesBackButton = YES;
			
			self.usernameTextField.userInteractionEnabled = NO;
			self.passwordTextField.userInteractionEnabled = NO;
			
			// Show login HUD
			
			UIWindow *window = [UIApplication sharedApplication].keyWindow;
			HUD = [[MBProgressHUD alloc] initWithWindow:window];
			
			// Add HUD to screen
			[window addSubview:HUD];
			
			// Register for HUD callbacks so we can remove it from the window at the right time
			HUD.delegate = self;
			
			[HUD show:YES];
			
			[[HNAuth sharedHNAuth]	loginWithUsername:usernameTextField.text 
											password:passwordTextField.text];
			
			// Show the HUD while the provided method executes in a new thread
			//[HUD showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
			
			
		}
		
		//[self.navigationController popViewControllerAnimated:YES];
		
		return YES;
	} else {
		// TODO: Handle the error
		return YES;
	}
}



-(void)successfulLogin:(NSNotification *)notification {
	[self.passwordTextField resignFirstResponder];

	
	//get the window again
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	//hide the HUD from window
	[MBProgressHUD hideFromWindow:window animated:YES];
		
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)failedLogin:(NSNotification*)notification {	
	[self.passwordTextField resignFirstResponder];

	
	//get the window again
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	//hide the HUD from window
	[MBProgressHUD hideFromWindow:window animated:YES];
	
	
	
	[self.navigationController popViewControllerAnimated:YES];

	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" 
														  message:@"Couldn't log in with the given username and password." 
														 delegate:self 
												cancelButtonTitle:@"Close" 
												otherButtonTitles:nil];
	
	[myAlertView show];
	[myAlertView release];
	
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    //[HUD release];
}


#pragma mark -
#pragma mark Text Fields

- (UITextField *)usernameTextField
{
	if (usernameTextField == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
		usernameTextField = [[UITextField alloc] initWithFrame:frame];
		
		usernameTextField.borderStyle = UITextBorderStyleNone;
		usernameTextField.textColor = [UIColor blackColor];
		usernameTextField.font = [UIFont systemFontOfSize:17.0];
//		usernameTextField.placeholder = @"<enter text>";
		usernameTextField.backgroundColor = [UIColor whiteColor];
		usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		usernameTextField.autocapitalizationType =  UITextAutocapitalizationTypeNone;
		usernameTextField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		usernameTextField.returnKeyType = UIReturnKeyNext;
		
		usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
		usernameTextField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	}	
	return usernameTextField;
}


- (UITextField *)passwordTextField
{
	if (passwordTextField == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
		passwordTextField = [[UITextField alloc] initWithFrame:frame];
		passwordTextField.borderStyle = UITextBorderStyleNone;
		passwordTextField.textColor = [UIColor blackColor];
		passwordTextField.font = [UIFont systemFontOfSize:17.0];
//		passwordTextField.placeholder = @"<enter password>";
		passwordTextField.backgroundColor = [UIColor whiteColor];
		
		passwordTextField.keyboardType = UIKeyboardTypeDefault;
		passwordTextField.returnKeyType = UIReturnKeyGo;	
		passwordTextField.secureTextEntry = YES;	// make the text entry secure (bullets)
		passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
		passwordTextField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	}
	return passwordTextField;
}




@end

