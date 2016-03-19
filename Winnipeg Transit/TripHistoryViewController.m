//
//  TripHistoryViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-21.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "TripHistoryViewController.h"

@implementation TripHistoryViewController

@synthesize theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning I still need to put in other delegate/datasource methods for the tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *uniqueIdentifier = @"PlanCellIdentifier";
    TripHistoryCell *cell = nil;
    cell = (TripHistoryCell *) [self.theTableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PlanTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (TripHistoryCell *)currentObject;
                break;
            }
        }
    }
    //put in assignments for cell objects
    return cell;

}

@end
