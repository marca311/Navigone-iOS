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

@synthesize currentFile;
@synthesize resultsTable;
@synthesize planButton;
@synthesize resultsArray, planArray;
@synthesize planSelectorTable,planTable;
@synthesize planList, currentPlan, planTitleArray;

-(void)setRoute:(NSString *)theRoute {
    currentFile = theRoute;
}

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
    planArray = [navigoInterpreter makeHumanReadableResults:resultDictionary];
    currentPlan = 0;
    resultsArray = [planArray objectAtIndex:currentPlan];
    planList = [navigoInterpreter planListMaker:resultDictionary];
    planTitleArray = [planList objectAtIndex:(currentPlan+1)];
    self.buses.text = [planTitleArray objectAtIndex:2];
    self.startTime.text = [planTitleArray objectAtIndex:0];
    self.endTime.text = [planTitleArray objectAtIndex:1];
    
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
        planSelectorTable.primaryResults = planList;
        planSelectorTable = [[PlanSelectorTableVew alloc]initWithFrameFromButton:planButton];
        planSelectorTable.tableView.delegate = self;
        [planSelectorTable showAndAnimate:self.view:resultDictionary];
    } else {
        [planSelectorTable closeAndAnimate];
        planSelectorTable = nil;
    }
}

-(IBAction)closePlans
{
    if (planSelectorTable != nil) {
        [planSelectorTable closeAndAnimate];
        planSelectorTable = nil;
    }
}

-(void)changePlanSelectorArray:(int)arrayNumber
{
    planTitleArray = [planList objectAtIndex:(currentPlan+1)];
    self.buses.text = [planTitleArray objectAtIndex:2];
    self.startTime.text = [planTitleArray objectAtIndex:0];
    self.endTime.text = [planTitleArray objectAtIndex:1];
    resultsArray = [planArray objectAtIndex:arrayNumber];
}//changePlanSelectorArray

- (void)viewDidUnload
{
    currentFile = NULL;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPlan = indexPath.row;
    [self changePlanSelectorArray:currentPlan];
    [planTable changeTablePlan:resultsArray];
    [planSelectorTable.tableView removeFromSuperview];
    planSelectorTable = nil;
    NSIndexPath *topIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [planTable.tableView scrollToRowAtIndexPath:topIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else return NO;
    //TODO: Add call to work with iOS6 and orientations
}

@end
