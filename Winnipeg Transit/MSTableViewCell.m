//
//  MSTableViewCell.m
//  Winnipeg Transit
//
//  Created by Tristan Brenneman on 12-06-08.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSTableViewCell.h"

@implementation MSTableViewCell

@synthesize textView, image, viewForBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
