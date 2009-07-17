//
//  HNPing.m
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNPing.h"

#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>



@implementation HNPing

-(BOOL) pingHostNamed:(NSString *)host {
	
	//// From http://stackoverflow.com/questions/798454/how-to-write-a-simple-ping-method-in-cocoa-objective-c
	
		
	Boolean success;
	const char *host_name = [host cStringUsingEncoding:NSASCIIStringEncoding];
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
																				host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && 
	!(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable) {
        NSLog(@"Host is reachable: %d", flags);
	}else{
        NSLog(@"Host is unreachable");
	}
	return success;
}



@end
