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


////////////////////////////////////////// Start Loading View

#import "LoadingView.h"

@interface UIApplication (KeyboardView)

- (UIView *)keyboardView;

@end

@implementation UIApplication (KeyboardView)

- (UIView *)keyboardView
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
			if (!strcmp(object_getClassName(view), "UIKeyboard"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end

////////////////////////////////////////// End Loading View





#define kTextFieldWidth		260.0
#define kLeftMargin			20.0
#define kTextFieldHeight	30.0

static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kViewKey = @"viewKey";

@implementation LoginViewController
@synthesize usernameTextField, passwordTextField, dataSourceArray, loginLoadingView;



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
			
			NSLog(@"Name: %@", [[cookies objectAtIndex:0] name]);
			NSLog(@"Name: %@", [[cookies objectAtIndex:0] value]);
			
		} else {
					
			self.navigationItem.hidesBackButton = YES;
			
			self.usernameTextField.userInteractionEnabled = NO;
			self.passwordTextField.userInteractionEnabled = NO;
			
			//UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
			//LoadingView *loginLoadingView = [LoadingView loadingViewInView:keyboardView];
			loginLoadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];

			
			[[HNAuth sharedHNAuth]	loginWithUsername:usernameTextField.text 
							password:passwordTextField.text];
		}
		
		//[self.navigationController popViewControllerAnimated:YES];
		
		return YES;
	} else {
		// Handle the error
		return YES;
	}
}

-(void)successfulLogin:(NSNotification *)notification {
	[self.passwordTextField resignFirstResponder];
	[loginLoadingView removeView];
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)failedLogin:(NSNotification*)notification {	
	[self.passwordTextField resignFirstResponder];
	[loginLoadingView removeView];
	[self.navigationController popViewControllerAnimated:YES];

	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" 
														  message:@"Couldn't log in with the given username and password." 
														 delegate:self 
												cancelButtonTitle:@"Close" 
												otherButtonTitles:nil];
	
	[myAlertView show];
	[myAlertView release];
	
}





// Fullscreen commit thingy
- (IBAction)showCommit:(id)sender
{
	LoadingView *loadingView =
	[LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
	
	[loadingView
	 performSelector:@selector(removeView)
	 withObject:nil
	 afterDelay:5.0];
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

