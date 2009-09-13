//
//  HNCommentTextEditor.h
//  HackerNews
//
//  Created by Michael Grinich on 7/20/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class HNComment;

@interface HNCommentTextEditor : TTTextEditor {

}

@property(nonatomic,retain) HNComment *aboveComment;

@end
