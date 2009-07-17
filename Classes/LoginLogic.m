//
//  LoginLogic.m
//  HackerNews
//
//  Created by Michael Grinich on 7/17/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "LoginLogic.h"
#import "SynthesizeSingleton.h"
#import "ElementParser.h"


@implementation LoginLogic
SYNTHESIZE_SINGLETON_FOR_CLASS(LoginLogic);


@synthesize loginURL, loginFNID;


-(void) getLoginFNID {
	
	NSString *yc_url = [NSString stringWithFormat:@"http://news.ycombinator.com%@", loginURL];
	TTURLRequest *request = [TTURLRequest requestWithURL:yc_url delegate:self];
	
	//	request.cachePolicy = cachePolicy;
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), yc_url);
	
}

- (void)requestDidFinishLoad:(TTURLRequest*)request { 
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	
	Element *document = [Element parseHTML: responseBody];
	self.loginFNID = [[[document selectElements:@"form > input"] objectAtIndex:0] attribute:@"value"];
	
	[self loginWithUsername:@"grinich" password:@"carman"];

}







-(void)loginWithUsername:(NSString*)username password:(NSString*)password {
	
	
	NSString *URLstring = [NSString stringWithFormat:@"http://news.ycombinator.com/y?fnid=%@&u=%@&p=%@", self.loginFNID, username, password];
	
	NSLog(@"%@", URLstring);
	
	NSURL *URL = [NSURL URLWithString:URLstring];
	
	NSMutableURLRequest* URLRequest = [NSMutableURLRequest requestWithURL:URL
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														  timeoutInterval:300.0];
	
	
	// TODO : cycle this
	NSString* safariUserAgent = @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_2 like Mac OS X;\
	en-us) AppleWebKit/525.181 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20";
		
	[URLRequest setValue:safariUserAgent forHTTPHeaderField:@"User-Agent"];
		
	[URLRequest setHTTPShouldHandleCookies:YES];
	
	
	NSError * error;
	NSHTTPURLResponse *response;
	NSData * data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];	
	
	//NSLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease]);
	
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://temp/gomh/authenticate.py"]];
	
	NSLog(@"%d", all.count);
	
	for (NSHTTPCookie *cookie in all) 
	{
		NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value); 
	}
	
	
	
//	[URLRequest setHTTPMethod:<#(NSString *)method#>
	
	 /*
	  - (NSData*)generatePostBody {
	  NSMutableData *body = [NSMutableData data];
	  NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
	  
	  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
	  dataUsingEncoding:NSUTF8StringEncoding]];
	  
	  for (id key in [_parameters keyEnumerator]) {
	  NSString* value = [_parameters valueForKey:key];
	  if (![value isKindOfClass:[UIImage class]]) {
      [body appendData:[[NSString
	  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
	  dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];        
	  }
	  }
	  
	  
	  
	  
	  
	[URLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"]
	 
	 } else if ([_httpMethod isEqualToString:@"POST"]) {
		 return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
	 
	 
	 NSData* body = request.httpBody;
	 if (body) {
		 [URLRequest setHTTPBody:body];
		 
		 
		if (request) {
			;
			
			NSString* method = request.httpMethod;
			if (method) {
				[URLRequest setHTTPMethod:method];
			}
			
			NSString* contentType = request.contentType;
			if (contentType) {
				;
			}
			

			}
		}

								
								
	
	TTURLRequest *request = [TTURLRequest requestWithURL:story_url delegate:self];
	
	//	request.cachePolicy = cachePolicy;
	request.cachePolicy = TTURLRequestCachePolicyMemory;
	
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), story_url);
	*/
	
	
}



@end
