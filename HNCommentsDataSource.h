//
//  HNCommentsDataSource.h
//  HackerNews
//
//  Created by Michael Grinich on 7/13/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface HNCommentsDataSource : TTListDataSource  {


}

- (id)initWithID:(NSString*)storyID;


@end
