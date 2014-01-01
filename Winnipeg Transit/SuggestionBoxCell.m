//
//  SuggestionBoxCell.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-10-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "SuggestionBoxCell.h"

@implementation SuggestionBoxCell

@synthesize textBox;

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
