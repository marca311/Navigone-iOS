//
//  QueryHistoryCell.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-07-06.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "TextBoxCell.h"

@implementation TextBoxCell

@synthesize text;

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
