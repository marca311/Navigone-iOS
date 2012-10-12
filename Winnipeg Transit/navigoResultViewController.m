//
//  navigoResultViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-30.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoResultViewController.h"
#import "MSUtilities.h"
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"
#import "PlanSelectorTableVew.h"
#import "navigoInterpreter.h"


NSDictionary *resultDictionary;

@implementation navigoResultViewController

@synthesize resultsTable;
@synthesize planButton;
@synthesize resultsArray, planArray;
@synthesize planSelectorTable,planTable;

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
    resultDictionary = [MSUtilities loadDictionaryWithName:currentFile];
    planArray = [navigoInterpreter makeHumanReadableResults:resultDictionary];;
    resultsArray = [planArray objectAtIndex:0];
    
    //Add plan table to view
    planTable = [[PlanDisplayTableViewController alloc]initWithCorrectFrame:resultsArray];
    [planTable showTable:self.view];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //textField = planField;
    if (![planField.text isEqual:@""]) {
        resultsArray = [planArray objectAtIndex:([planField.text intValue] - 1)];
        [resultsTable reloadData];
    }
}

-(IBAction)reloadTable
{
    [self resignFirstResponder];
    resultsArray = [planArray objectAtIndex:[planField.text intValue]];
    [resultsTable reloadData];
}

-(IBAction)planButtonPress
{
    if ([planSelectorTable.tableView isUserInteractionEnabled] == NO) {
        [planSelectorTable setDataSourceArray:resultDictionary];
        planSelectorTable = [[PlanSelectorTableVew alloc]initWithFrameFromButton:planButton];
        planSelectorTable.tableView.delegate = self;
        [planSelectorTable showAndAnimate:self.view:resultDictionary];
    }
}

-(IBAction)closePlans
{
    if (planSelectorTable != nil) {
        [planSelectorTable.tableView removeFromSuperview];
        planSelectorTable = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You clicked a button!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
