//
//  HackerNewsAppDelegate.m
//  HackerNews
//
//  Created by Michael Grinich on 7/7/09.
//  Copyright Michael Grinich 2009. All rights reserved.
//

#import "HackerNewsAppDelegate.h"
#import "HNStoryTableViewController.h"
#import "HNParser.h"

@implementation HackerNewsAppDelegate

@synthesize window;
@synthesize aHNStoryTableViewController; 
@synthesize navigationController;
@synthesize splashView;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	
	self.navigationController = [[UINavigationController alloc] 
													initWithRootViewController:aHNStoryTableViewController];

	
	[window addSubview:navigationController.view];
	
	
	[window makeKeyAndVisible];
	
	
	
	
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	splashView.frame = CGRectMake(-60, -60, 440, 600);
	[UIView commitAnimations];

}


- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
	[splashView release];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"HackerNews.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end

