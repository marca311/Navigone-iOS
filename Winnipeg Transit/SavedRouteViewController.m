//
//  SavedRouteViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-28.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "SavedRouteViewController.h"
#import "MSUtilities.h"
#import "MSRoute.h"

@interface SavedRouteViewController ()

@end

@implementation SavedRouteViewController

@synthesize theTableView, savedRoutes, previousRoutes, fileExists;

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

-(id)initSavedRouteViewController
{
    self = [super initWithNibName:@"SavedRouteView" bundle:[NSBundle mainBundle]];
    if (self) {
        fileExists = [MSUtilities fileExists:@"RouteHistory.plist"];
        if (fileExists) {
            NSArray *theFile = [MSUtilities loadArrayWithName:@"RouteHistory"];
            savedRoutes = [theFile objectAtIndex:0];
            previousRoutes = [theFile objectAtIndex:0];
        }
    }
    return self;
}

+(void)addRoute:(NSString *)theURL :(NSArray *)theRoute
{
    BOOL fileExists = [MSUtilities fileExists:@"RouteHistory.plist"];
    NSArray *theFile = [[NSArray alloc]init];
    NSArray *savedRoutes = [[NSArray alloc]init];
    NSArray *previousRoutes = [[NSArray alloc]init];
    if (fileExists) {
        theFile = [MSUtilities loadArrayWithName:@"RouteHistory"];
        savedRoutes = [theFile objectAtIndex:0];
        previousRoutes = [theFile objectAtIndex:0];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fileExists) {
        if (section == 0) {
            return [savedRoutes count];
        } else if (section == 1) {
            return [previousRoutes count];
        }
    } else return 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        cell.showsReorderControl = true;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        NSArray *cellData = [savedRoutes objectAtIndex:row];
        cell.textLabel.text = [cellData objectAtIndex:0];
    } else if (section == 1) {
        NSArray *cellData = [previousRoutes objectAtIndex:row];
        cell.textLabel.text = [cellData objectAtIndex:0];
    }
    return cell;
}


@end
