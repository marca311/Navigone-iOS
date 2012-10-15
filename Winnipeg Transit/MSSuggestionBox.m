//
//  MSSuggestionBox.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSSuggestionBox.h"
#import <QuartzCore/QuartzCore.h>
#import "navigoInterpreter.h"

@implementation MSSuggestionBox

@synthesize tableArray;

-(id)initWithFrameFromField:(UITextField *)textField
{
    CGRect theFrame;
    theFrame.origin.x = textField.frame.origin.x;
    theFrame.origin.y = (textField.frame.origin.y + textField.frame.size.height);
    
    theFrame.size.width = textField.frame.size.width;
    theFrame.size.height = 100;
    
    self.tableView = [self.tableView initWithFrame:theFrame];
    
    //Border
    CALayer *layer = self.tableView.layer;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;    
    
    self.tableView.dataSource = self;
    return self;
}

- (void)getSuggestions:(NSString *)query
{
    if ([MSUtilities isQueryBlank:query]) {
        [self.tableView reloadData];
    } else {
        NSArray *locationArray = [navigoInterpreter getQuerySuggestions:query];
        tableArray = locationArray;
        [self.tableView reloadData];
    }
}//sendQuery


-(void)changeSizeFromEntries:(NSArray *)array
{
    int sizeOfCell = 40;
    int numberOfEntries = [array count];
    CGRect theFrame = self.tableView.frame;
    theFrame.size.height = (numberOfEntries * sizeOfCell) + sizeOfCell;
    self.tableView.frame = theFrame;
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [tableArray count]; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *contentForThisRow = [[self currentArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    cell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uniqueIdentifier];
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
