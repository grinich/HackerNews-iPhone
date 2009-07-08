//
//  HNStoryTableViewCell.m
//  HackerNews
//
//  Created by Michael Grinich on 7/8/09.
//  Copyright 2009 Michael Grinich. All rights reserved.
//

#import "HNStoryTableViewCell.h"


@implementation HNStoryTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
