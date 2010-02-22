//
//  HNWebController.m
//  HackerNews
//
//  Created by Michael Grinich on 1/4/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "HNWebController.h"

#import "NSStringAdditions.h"

@implementation HNWebController

@synthesize linkedStory;

- (void)shareAction {
	UIActionSheet* sheet = [[[UIActionSheet alloc] initWithTitle:@"" 
														delegate:self
											   cancelButtonTitle:TTLocalizedString(@"Cancel", @"") 
										  destructiveButtonTitle:nil
											   otherButtonTitles:@"Open in Safari", @"Mail Link", @"Save with Instapaper",@"Readibility", nil] autorelease];
	[sheet showInView:self.view];	
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(buttonIndex)
	{
		case 0: // Open in Safari
			[[UIApplication sharedApplication] openURL:self.URL];
			break;
		case 1: {
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self; // <- very important step if you want feedbacks on what the user did with your email sheet
			
			[picker setSubject:[NSString stringWithFormat:@"[Hacker News] %@", self.title]];
								
			NSString *emailBody = [NSString stringWithFormat:@"<b><a href=\"%@\">%@</a></b><br/><br/>Sent with <a href=\"http://michaelgrinich.com/hackernews/\">Hacker News on iPhone</a>", [self.URL absoluteString], self.title]; 			
			
			[picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
			
			picker.navigationBar.barStyle = UIBarStyleDefault; 
			picker.navigationBar.tintColor = TTSTYLEVAR(hackerNewsColor);
			
			[self presentModalViewController:picker animated:YES];
			[picker release];
			break;
		}
		case 2:
			DLog(@"Save with instapaper!");
			[self sendToInstapaper];
		case 3:
			// Readability
			

			[_webView stringByEvaluatingJavaScriptFromString:@"javascript:(function(){readStyle='style-athelas';readSize='size-x-large';readMargin='margin-x-narrow';_readability_script=document.createElement('SCRIPT');_readability_script.type='text/javascript';_readability_script.src='http://lab.arc90.com/experiments/readability/js/readability.js?x='+(Math.random());document.getElementsByTagName('head')[0].appendChild(_readability_script);_readability_css=document.createElement('LINK');_readability_css.rel='stylesheet';_readability_css.href='http://lab.arc90.com/experiments/readability/css/readability.css';_readability_css.type='text/css';_readability_css.media='all';document.getElementsByTagName('head')[0].appendChild(_readability_css);_readability_print_css=document.createElement('LINK');_readability_print_css.rel='stylesheet';_readability_print_css.href='http://lab.arc90.com/experiments/readability/css/readability-print.css';_readability_print_css.media='print';_readability_print_css.type='text/css';document.getElementsByTagName('head')[0].appendChild(_readability_print_css);})();"];  
			
			
			
			break;

		default:
			break;
	}
	
		
}


- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
	if (result == MFMailComposeResultSent) {
		NSLog(@"It's away!");
	}
	[self dismissModalViewControllerAnimated:YES];
}



- (void) sendToInstapaper {
	NSString *url = [self.URL absoluteString];
	
	if (!url.length)
		return;
	
	BOOL success = YES;
	BOOL showHelp = NO;
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.delegate = self;
	
	alert.cancelButtonIndex = [alert addButtonWithTitle:NSLocalizedString(@"Dismiss", @"Dismiss alert button title")];
	
	//NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"CQInstapaperUsername"];
	
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
