//
//  HNStyle.h
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "Three20/Three20.h"

@interface HNStyle : TTDefaultStyleSheet 

@property(nonatomic,readonly) UIFont *storyTitleFont;
@property(nonatomic,readonly) UIFont *storyURLFont ;
@property(nonatomic,readonly) UIFont *storySubtextFont;
@property(nonatomic,readonly) UIFont *commentBlipFont;
@property(nonatomic,readonly) UIFont* commentBylineFont;
@property(nonatomic,readonly) TTStyle* HNOrangeText;

@property(nonatomic,readonly) UIColor *hackerNewsColor;
@end