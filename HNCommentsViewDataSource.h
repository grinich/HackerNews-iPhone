//
//  CommentsViewDataSource.h
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface HNCommentsViewDataSource : TTListDataSource {

}

+ (HNCommentsViewDataSource*)commentsViewDataSource:(NSInteger)story_id;


@end
