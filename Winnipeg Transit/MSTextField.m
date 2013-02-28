//
//  MSTextField.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-21.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSTextField.h"

@implementation MSTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
