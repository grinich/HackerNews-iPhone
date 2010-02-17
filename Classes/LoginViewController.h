//
//  LoginViewController.h
//  
//
//  Created by Michael Grinich on 6/30/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface LoginViewController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate> {
	UITextField		*usernameTextField;
	UITextField		*passwordTextField;
	
	NSArray			*dataSourceArray;
	MBProgressHUD	*HUD;
}


@property (nonatomic, retain) 	UITextField		*usernameTextField;
@property (nonatomic, retain) 	UITextField		*passwordTextField;
@property (nonatomic, retain)	NSArray			*dataSourceArray;

@end
