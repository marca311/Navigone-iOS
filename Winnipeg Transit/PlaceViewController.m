//
//  PlaceViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlaceViewController.h"
#import "MSUtilities.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

@synthesize theTableView, editButton;
@synthesize savedLocations, previousLocations;

- (void)loadPlaceDictionary:(UIView *)superView {
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Saved Locations";
    } else {
        return @"Location History";
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath { return true; }

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 20; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        cell.showsReorderControl = true;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %i",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    //Add code to remove entry
}

-(IBAction)editTable {
    if (theTableView.editing == false) {
        [theTableView setEditing:true animated:true];
        [editButton setTitle:@"Done"];
        [editButton setStyle:UIBarButtonItemStyleDone];
    } else {
        [theTableView setEditing:false animated:true];
        [editButton setTitle:@"Edit"];
        [editButton setStyle:UIBarButtonItemStyleBordered];
    }
}

#pragma mark - File handling methods

-(void)saveFile {
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc]init];
    [theDictionary setObject:savedLocations forKey:@"SavedLocations"];
    [theDictionary setObject:previousLocations forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:theDictionary :@"SearchHistory"];
}
-(void)addLocation:(NSString *)locationName :(NSString *)locationKey {
    
}
-(void)removeLocation:(NSIndexPath *)index {
    NSInteger section = index.section;
    NSInteger row = index.row;
    switch (section) {
        case 0:
            [savedLocations removeObjectAtIndex:row];
            break;
            
        case 1:
            [previousLocations removeObjectAtIndex:row];
            break;
    }
}
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex {
    if ([currentIndex section] == 0) {
        
}
-(void)changeSavedName:(NSIndexPath *)index :(NSString *)newName {
    
}
//Static method for adding entries
+(void)addEntryToFile:(NSString *)locationName :(NSString *)locationKey {
    
}

@end
