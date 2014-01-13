//
//  QueryHistoryCell.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-07-06.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "TextBoxCell.h"

@implementation TextBoxCell

@synthesize textView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-5, self.frame.size.height)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setEditable:NO];
        [textView setScrollEnabled:NO];
        [self addSubview:textView];
    }
}

@end
