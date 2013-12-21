//
//  MSTopBar.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSTopBar.h"

@implementation MSTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Sets a black border (with rounded corners) around the view
        CALayer *layer = self.layer;
        layer.borderWidth = 2;
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.cornerRadius = 10;
        layer.masksToBounds = YES;
    }
    return self;
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
