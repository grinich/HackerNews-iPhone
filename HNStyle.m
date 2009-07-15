//
//  HNStyle.m
//  HackerNews
//
//  Created by Michael Grinich on 7/11/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStyle.h"


@implementation HNStyle

// HN Orange

- (UIColor*)navigationBarTintColor {
	//	return RGBCOLOR(119, 140, 168);
	return TTSTYLEVAR(hackerNewsColor);
}

- (UIColor*)toolbarTintColor {
	//	return RGBCOLOR(109, 132, 162);
	return TTSTYLEVAR(hackerNewsColor);
}

- (UIColor*)searchBarTintColor {
	return TTSTYLEVAR(hackerNewsColor);
}

- (UIColor*)hackerNewsColor {
	return RGBCOLOR(225, 101, 0);
}



- (UIFont*) storyTitleFont {
	return [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
}

- (UIFont*) storyURLFont {
	return [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
}
- (UIFont*) storySubtextFont {
	return [UIFont fontWithName:@"Helvetica" size:11.0];
}
- (UIFont*) commentBlipFont {
	return [UIFont fontWithName:@"Marker Felt" size:14.0];
}

- (UIFont*) commentBylineFont {
	return [UIFont fontWithName:@"Helvetica" size:11.0];
}



- (TTStyle* ) HNOrangeText {
	return [TTTextStyle styleWithColor:TTSTYLEVAR(hackerNewsColor) next:nil];
}

@end
