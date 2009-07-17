//
//  LoginViewController.h
//  Quizlet
//
//  Created by Michael Grinich on 6/30/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"


@interface LoginViewController : UITableViewController <UITextFieldDelegate> {
	UITextField		*usernameTextField;
	UITextField		*passwordTextField;
	
	NSArray			*dataSourceArray;

}


@property (nonatomic, retain) 	UITextField		*usernameTextField;
@property (nonatomic, retain) 	UITextField		*passwordTextField;
@property (nonatomic, retain)	NSArray			*dataSourceArray;


@end
