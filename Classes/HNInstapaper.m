//
//  HNInstapaper.m
//  HackerNews
//
//  Created by Michael Grinich on 4/29/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "HNInstapaper.h"


@implementation HNInstapaper


- (void) sendToInstapaper:(NSURL*)url {
	[self sendToInstapaper:url withTitle:nil];
}


- (void) sendToInstapaper:(NSURL*)inputURL withTitle:(NSString*)title {

	NSString *url = [inputURL absoluteString];
	
	if (!url.length)
		return;
	
	BOOL success = YES;
	BOOL showHelp = NO;
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.delegate = self;
	
	alert.cancelButtonIndex = [alert addButtonWithTitle:NSLocalizedString(@"Dismiss", @"Dismiss alert button title")];
	
	//NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"CQInstapaperUsername"];
	
	
	// TODO : change this to some value coming from NSUserDefaults
	NSString *username = @"grinich";
	
	
	if (!username.length) {
		alert.title = NSLocalizedString(@"No Instapaper Username", "No Instapaper username alert title");
		alert.message = NSLocalizedString(@"You need to enter an Instapaper username in Colloquy's Settings.", "No Instapaper username alert message");
		success = NO;
		showHelp = YES;
	}
	
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"CQInstapaperPassword"];
	
	if (success) {
		url = [url stringByEncodingIllegalURLCharacters];
		username = [username stringByEncodingIllegalURLCharacters];
		password = [password stringByEncodingIllegalURLCharacters];
		
		NSString *instapaperURL = [NSString stringWithFormat:@"https://www.instapaper.com/api/add?username=%@&password=%@&url=%@&auto-title=1", username, password, url];
		
		success = NO;
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		NSError *error = nil;
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:instapaperURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.];
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
		
		[request release];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if (!error) {
			NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			
			if ([response isEqualToString:@"201"]) {
				success = YES;
			} else if ([response isEqualToString:@"403"]) {
				alert.title = NSLocalizedString(@"Couldn't Authenticate with Instapaper", "Could not authenticate title");
				alert.message = NSLocalizedString(@"Make sure your Instapaper username and password are correct.", "Make sure your Instapaper username and password are correct alert message");
				showHelp = YES;
			} else if ([response isEqualToString:@"500"]) {
				alert.title = NSLocalizedString(@"Instapaper Unavailable", "Twitter Temporarily Unavailable title");
				alert.message = NSLocalizedString(@"Unable to send the URL because Instapaper is temporarily unavailable.", "Unable to send URL because Instapaper is temporarily unavailable alert message");
			}
			
			[response release];
		} else {
			alert.title = NSLocalizedString(@"Unable To Send URL", "Unable to send URL alert title");
			alert.message = NSLocalizedString(@"Unable to send the URL to Instapaper.", "Unable to send the URL to Instapaper alert message");
		}
	}
	
	if (showHelp) {
		//alert.tag = InstapaperHelpAlertTag;
		[alert addButtonWithTitle:NSLocalizedString(@"Help", @"Help button title")];
	}
	
	if (!success)
		[alert show];
	
	[alert release];
	
}
@end
