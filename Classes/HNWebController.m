//
//  HNWebController.m
//  HackerNews
//
//  Created by Michael Grinich on 1/4/10.
//  Copyright 2010 Michael Grinich. All rights reserved.
//

#import "HNWebController.h"
#import "HNStyle.h"
#import "NSStringAdditions.h"
#import "HNInstapaper.h"
#import "SHK.h"

@implementation HNWebController

@synthesize linkedStory;


// This lets us deserialize the story object which may be passed in.
// see http://groups.google.com/group/three20/browse_thread/thread/17531b9efbf243a3/4d95e930810e226e#4d95e930810e226e

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
	if (self = [super init]){ 
		
		// Check to see if we're passing off a story
		if(query && [query objectForKey:@"story"]){ 
			self.linkedStory = (HNStory*) [query objectForKey:@"story"]; 
			DLog(@"Passed off story: %@", [self.linkedStory title]);
		} 
		
		// Setup the webview request
		NSURLRequest* request = [query objectForKey:@"request"];
		if (request) {
			[self openRequest:request];
		} else {
			[self openURL:URL];
		}
	} 
	return self; 
} 


- (void)shareAction {
	// Old
	/*
	UIActionSheet* sheet = [[[UIActionSheet alloc] initWithTitle:@"" 
														delegate:self
											   cancelButtonTitle:TTLocalizedString(@"Cancel", @"") 
										  destructiveButtonTitle:nil
											   otherButtonTitles:@"Open in Safari", 
																 @"Mail Link", 
																 @"Save with Instapaper",
																 @"Readibility", 
																 nil] autorelease];

	[sheet showInView:self.view];	
	*/
	
	
	
	SHKItem *item = [SHKItem URL:self.URL title:self.title];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];
	
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// UIActionSheetDelegate

/*
 
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(buttonIndex)
	{
		// Open in Safari	
		case 0:  {
			[[UIApplication sharedApplication] openURL:self.URL];
			break;
		}
			
		// Send mail
		case 1: {
			
			// TODO use self.linkedStory to fill out metadata for email. 
			
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
		
			
		// Instapaper
		case 2: {
			DLog(@"Save with instapaper!");
			HNInstapaper* instapaper = [HNInstapaper new];
			[instapaper sendToInstapaper:self.URL];

		}
			
		// Readability
		case 3: { 
			[_webView stringByEvaluatingJavaScriptFromString:@"javascript:(function(){readStyle='style-athelas';readSize='size-x-large';readMargin='margin-x-narrow';_readability_script=document.createElement('SCRIPT');_readability_script.type='text/javascript';_readability_script.src='http://lab.arc90.com/experiments/readability/js/readability.js?x='+(Math.random());document.getElementsByTagName('head')[0].appendChild(_readability_script);_readability_css=document.createElement('LINK');_readability_css.rel='stylesheet';_readability_css.href='http://lab.arc90.com/experiments/readability/css/readability.css';_readability_css.type='text/css';_readability_css.media='all';document.getElementsByTagName('head')[0].appendChild(_readability_css);_readability_print_css=document.createElement('LINK');_readability_print_css.rel='stylesheet';_readability_print_css.href='http://lab.arc90.com/experiments/readability/css/readability-print.css';_readability_print_css.media='print';_readability_print_css.type='text/css';document.getElementsByTagName('head')[0].appendChild(_readability_print_css);})();"];  
			break;
		}


		default:
			break;
	}
	
		
}


- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
	if (result == MFMailComposeResultSent) {
		DLog(@"It's away!");
	}
	[self dismissModalViewControllerAnimated:YES];
}

 */


@end
