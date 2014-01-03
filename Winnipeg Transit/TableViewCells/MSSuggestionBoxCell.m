//
//  MSSuggestionBoxCell.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 1/2/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSSuggestionBoxCell.h"

@implementation MSSuggestionBoxCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float height = self.frame.size.height;
        float width = self.frame.size.width;
        CGRect textViewFrame = CGRectMake(5, 0, width-5, height);
        textView = [[UITextView alloc]initWithFrame:textViewFrame];
        [textView setTextColor:[UIColor blackColor]];
        [textView setUserInteractionEnabled:NO];
        [self addSubview:textView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
