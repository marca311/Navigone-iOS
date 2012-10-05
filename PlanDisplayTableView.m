//
//  PlanDisplayTableView.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-10-04.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlanDisplayTableView.h"

@implementation PlanDisplayTableView

@synthesize currentArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataSource = self.dataSource;
    self.delegate = self.delegate;
    NSArray *contentForThisRow = [[self currentArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSTableViewCell *cell = nil;
    cell = (MSTableViewCell *) [self dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    cell.textView.text = [contentForThisRow objectAtIndex:1];
    cell.time.text = [navigoViewLibrary sendTime:contentForThisRow];
    
    return cell;
}


@end
