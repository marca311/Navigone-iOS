//
//  PlanDisplayTableViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-09-27.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "VariationDisplayTableViewController.h"
#import "MSStep.h"

@implementation VariationDisplayTableViewController

@synthesize currentArray;

-(id)initWithCorrectFrame:(MSVariation *)theVariation
{
    self = [[VariationDisplayTableViewController alloc]init];
    CGRect theFrame;
    theFrame.origin.x = 20;
    theFrame.origin.y = 104;
    theFrame.size.width = 280;
    theFrame.size.height = 336;
    self.tableView = [self.tableView init];
    self.tableView.frame = theFrame;
    self.tableView.rowHeight = 68;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;

    variationData = theVariation;
    stepArray = [variationData getHumanReadable];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    return self;
}//initAndShowWithCorrectFrame

-(void)showTable:(UIView *)theView
{
    [theView addSubview:self.tableView];
}//showTable

-(void)changeTableVariation:(MSVariation *)theVariation
{
    variationData = theVariation;
    stepArray = [variationData getHumanReadable];
    [self.tableView reloadData];
}//changeTablePlan

-(UIImage *)useCorrectImage:(MSStep *)step {
    NSString *segmentType = [step getType];
    if ([segmentType isEqualToString:@"ride"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"ride.png"];
        return result;
    } else if ([segmentType isEqualToString:@"monument"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"monument.gif"];
        return result;
    } else if ([segmentType isEqualToString:@"stop"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"stop.png"];
        return result;
    } else if ([segmentType isEqualToString:@"transfer"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"transfer.png"];
        return result;
    } else {
        return NULL;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [stepArray count]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSTableViewCell *cell = nil;
    cell = (MSTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    cell.textView.backgroundColor = [UIColor clearColor];
    cell.textView.opaque = NO;
    
    MSStep *currentStep = [stepArray objectAtIndex:[indexPath row]];
    cell.textView.text = [currentStep getHumanReadable];
    cell.time.text = [currentStep getTime];
    cell.image.image = [self useCorrectImage:currentStep];
    
    return cell;
}

@end
