//
//  PlanSelectorTableVew.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlanSelectorTableVew.h"
#import "PlanTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlanSelectorTableVew

- (id)initWithFrameFromButton:(UIButton *)button
{
    CGRect tableRect = CGRectMake(0, 0, 0, 0);
    tableRect.origin.x = button.frame.origin.x;
    tableRect.origin.y = (button.frame.origin.y + button.frame.size.height);
    tableRect.size.width = button.frame.size.width;
    tableRect.size.height = 44;
    self = [self initWithFrame:tableRect];
    
    //Creates border
    CALayer *layer = self.layer;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;

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

- (void)setDataSourceArray:(NSArray *)array
{
    
}//setDataSourceArray

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *contentForThisRow = [[self resultsArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    PlanTableViewCell *cell = nil;
    cell = (PlanTableViewCell *) [self dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PlanTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    //cell.textView.text = [contentForThisRow objectAtIndex:1];
    //cell.time.text = [navigoViewLibrary sendTime:contentForThisRow];
    
    return cell;

}


@end
