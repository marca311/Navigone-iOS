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
#import "VariationSelectorTableVew.h"

NSDictionary *resultDictionary;

@implementation navigoResultViewController

@synthesize currentFile;
@synthesize resultsTable;
@synthesize planButton;

-(id)initWithMSRoute:(MSRoute *)route {
    routeData = route;
    self = [super initWithNibName:@"NavigoResults_iPhone" bundle:[NSBundle mainBundle]];
    return self;
}

-(void)setRoute:(MSRoute *)theRoute {
    routeData = theRoute;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentVariation = 0;
    variationData = [routeData getVariationFromIndex:currentVariation];
    //planList = [navigoInterpreter planListMaker:resultDictionary];
    self.buses.text = [variationData getBuses];
    self.startTime.text = [variationData getStartTime];
    self.endTime.text = [variationData getEndTime];
    
    //Add plan table to view
    variationTable = [[VariationDisplayTableViewController alloc]initWithCorrectFrame:variationData];
    [variationTable showTable:self.view];
}

-(IBAction)planButtonPress
{
    if ([planSelectorTable.tableView isUserInteractionEnabled] == NO) {
        planSelectorTable.primaryResults = planList;
        planSelectorTable = [[VariationSelectorTableVew alloc]initWithFrameFromButton:planButton];
        planSelectorTable.tableView.delegate = self;
        [planSelectorTable showAndAnimate:self.view Route:routeData];
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
