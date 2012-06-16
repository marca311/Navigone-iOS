//
//  PlanSelectorTableVew.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlanSelectorTableVew.h"

@implementation PlanSelectorTableVew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void)setFrameFromButton:(UIButton *)button
{
    CGRect tableRect;
    tableRect.origin.x = button.frame.origin.x;
    tableRect.origin.y = (button.frame.origin.y + button.frame.size.height);
    tableRect.size.width = (button.frame.origin.x + button.frame.size.width);
    tableRect.size.height = 200;
    self.frame = tableRect;
}//setFromFromButton

- (void)setDataSourceArray:(NSArray *)array
{
    
}//setDataSourceArray

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
