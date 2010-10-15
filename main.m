//
//  main.m
//  HackerNews
//
//  Created by Michael Grinich on 7/8/09.
//  Copyright Michael Grinich 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal;
	
	// If iPad
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {		
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Pad");
	} else {
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Pad");
	}               
	
    [pool release];
    return retVal;
}
