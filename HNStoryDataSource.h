//
//  HNStoryDataSource.h
//  HackerNews
//
//  Created by Michael Grinich on 7/12/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface HNStoryDataSource : TTListDataSource <TTURLRequestDelegate> {


	@private
		BOOL _isLoading;
		BOOL _isLoaded;
}




@end
