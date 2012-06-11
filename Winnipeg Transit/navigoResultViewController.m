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

@interface navigoResultViewController ()

@end

@implementation navigoResultViewController

@synthesize resultsTable;
@synthesize planButton;
@synthesize resultsArray;

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
    resultsArray = [MSUtilities getHumanArray];
    resultsArray = [resultsArray objectAtIndex:0];
	//put in the table loading methods and data loading too.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *contentForThisRow = [[self resultsArray] objectAtIndex:[indexPath row]];
    /*
    static NSString *CellIdentifier = @"CellIdentifier";
	
    MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[MSTableViewCell class]]) {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
	
    cell.textView.text = contentForThisRow;
    
    return cell;
*/
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSTableViewCell *cell = nil;
    cell = (MSTableViewCell *) [self.resultsTable dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        //NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
        
    cell.textView.text = contentForThisRow;

    return cell;
 
}

- (void)tableView:(UITableView *)tableView:didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
