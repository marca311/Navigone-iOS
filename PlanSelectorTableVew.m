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
#import "navigoInterpreter.h"

@implementation PlanSelectorTableVew

@synthesize tableRect, primaryResults, resultsArray;

- (id)initWithFrameFromButton:(UIButton *)button
{
    tableRect = CGRectMake(0, 0, 0, 0);
    tableRect.origin.x = button.frame.origin.x;
    tableRect.origin.y = (button.frame.origin.y + button.frame.size.height);
    tableRect.size.width = button.frame.size.width;
    tableRect.size.height = 1;
    self = [self initWithFrame:tableRect];
    
    //Creates border
    CALayer *layer = self.layer;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;

    self.delegate = self;
    self.dataSource = self;
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

- (void)showAndAnimate:(UIView *)theView
{
    [theView addSubview:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    tableRect.size.height = 44;
    self.frame = tableRect;
    [UIView commitAnimations];
}

- (void)setDataSourceArray:(NSDictionary *)dictionary
{
    primaryResults = [navigoInterpreter planListMaker:dictionary];
    NSLog(@"nomz");
}//setDataSourceArray

- (void)getFrameSizeFromArray:(NSArray *)array
{
    //Adjusts frame size based on how many entries are in the table to a max of 3
    int frameHeight;
    int numberOfPlans = [[primaryResults objectAtIndex:0]intValue];
    if (numberOfPlans < 3) {
        numberOfPlans = numberOfPlans * 44;
    } else {
        
    }
    CGRect theFrame = self.frame;
    //theFrame.size.height =
}//getFrameSizeFromArray

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 5; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *contentForThisRow = [[self resultsArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"PlanCellIdentifier";
    PlanTableViewCell *cell = nil;
    cell = (PlanTableViewCell *) [self dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PlanTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PlanTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    //cell.buses.text = [primaryResults objectAtIndex:[indexPath]];
    
    
    return cell;

}


@end
