//
//  PlanSelectorTableVew.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "VariationSelectorTableVew.h"
#import "VariationTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VariationSelectorTableVew

@synthesize tableRect, resultsArray;

- (id)initWithFrameFromButton:(UIButton *)button
{
    tableRect = CGRectMake(0, 0, 0, 0);
    tableRect.origin.x = button.frame.origin.x;
    tableRect.origin.y = (button.frame.origin.y + button.frame.size.height);
    tableRect.size.width = button.frame.size.width;
    tableRect.size.height = 1;
    self.tableView = [self.tableView init];
    self.tableView.frame = tableRect;
    
    //Creates border
    CALayer *layer = self.tableView.layer;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;
    
    self.tableView.dataSource = self;
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

- (void)showAndAnimate:(UIView *)theView Route:(MSRoute *)route {
    routeData = route;
    variationsArray = [routeData getVariations];
    [theView addSubview:self.tableView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.tableView.frame = [self getFrameSize];
    [UIView commitAnimations];
}

- (void)closeAndAnimate {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect closeRect = self.tableView.frame;
    closeRect.size.height = 1;
    self.tableView.frame = closeRect;
    [UIView commitAnimations];
    [self.tableView removeFromSuperview];
}

- (CGRect)getFrameSize {
    //Adjusts frame size based on how many entries are in the table to a max of 3
    int frameHeight;
    int numberOfPlans = [routeData getNumberOfVariations];
    if (numberOfPlans <= 3) {
        frameHeight = numberOfPlans * 44;
        //frameHeight = frameHeight + 15;
        //The + 15 is to allow the user to see that there are more objects in the table, applies in the else statement too.
    } else {
        frameHeight = 132 + 15;
    }
    CGRect theFrame = self.tableView.frame;
    theFrame.size.height = frameHeight;
    return theFrame;
}//getFrameSizeFromArray

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [routeData getNumberOfVariations]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *uniqueIdentifier = @"PlanCellIdentifier";
    VariationTableViewCell *cell = nil;
    cell = (VariationTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PlanTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (VariationTableViewCell *)currentObject;
                break;
            }
        }
    }
    MSVariation *currentVariation = [variationsArray objectAtIndex:[indexPath row]];
    cell.buses.text = [currentVariation getBuses];
    cell.startTime.text = [currentVariation getStartTime];
    cell.endTime.text = [currentVariation getEndTime];
    
    return cell;

}

@end
