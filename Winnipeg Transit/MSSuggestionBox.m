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
#import "SuggestionBoxCell.h"

@implementation MSSuggestionBox

@synthesize tableArray;

-(id)initWithFrameFromField:(UITextField *)textField
{
    CGRect theFrame;
    theFrame.origin.x = textField.frame.origin.x;
    theFrame.origin.y = (textField.frame.origin.y + textField.frame.size.height);
    
    theFrame.size.width = textField.frame.size.width;
    theFrame.size.height = 100;
        
    self.tableView = [self.tableView init];
    self.tableView.frame = theFrame;
    
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
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *locationArray = [navigoInterpreter getQuerySuggestions:query];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            tableArray = locationArray;
            [self.tableView reloadData];
        });
    });
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [tableArray count]; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *contentForThisRow = [[self currentArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    SuggestionBoxCell *cell = nil;
    cell = (SuggestionBoxCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SuggestionBoxCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (SuggestionBoxCell *)currentObject;
                break;
            }
        }

    }
    
    cell.textBox.text = [[tableArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

@end
