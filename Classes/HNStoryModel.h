//
//  HNStoryModel.h
//  HackerNews
//
//  Created by Michael Grinich on 7/16/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HNStoryModel : TTURLRequestModel {
	
	NSMutableArray* stories;

}

@property(nonatomic,retain) NSMutableArray* stories;


@end
