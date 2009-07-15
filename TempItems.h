//
//  TempItems.h
//  HackerNews
//
//  Created by Michael Grinich on 7/15/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNStory;

@interface TempItems : NSObject {
	
	HNStory *tempHNStory;
	

}

+ (TempItems *)sharedTempItems;


@property (nonatomic, retain) HNStory	* tempHNStory;

@end

