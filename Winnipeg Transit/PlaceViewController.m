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
@synthesize fileExists;

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
    fileExists = [MSUtilities fileExists:@"SearchHistory.plist"];
    if (fileExists) {
        NSDictionary *theFile = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        savedLocations = [theFile objectForKey:@"SavedLocations"];
        previousLocations = [theFile objectForKey:@"PreviousLocations"];
    }
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
    NSString *cellContent = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([cellContent isEqualToString:@"No saved locations"] || [cellContent isEqualToString:@"No history"]) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fileExists) {
        if (section == 0) {
            return [savedLocations count];
        } else if (section == 1) {
            return [previousLocations count];
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
        if ([savedLocations count] > 0) {
            cell.textLabel.text = [savedLocations objectAtIndex:row];
        } else {
            cell.textLabel.text = @"No saved locations";
        }
    } else if (section == 1) {
        if ([savedLocations count] > 0) {
            cell.textLabel.text = [previousLocations objectAtIndex:row];
        } else {
            cell.textLabel.text = @"No history";
        }
    }
    return cell;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    for (int i = 0; i<[indexPaths count]; i++) {
        [self removeLocation:[indexPaths objectAtIndex:i]];
    }
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
    NSInteger firstSection = currentIndex.section;
    NSInteger firstRow = currentIndex.row;
    NSInteger secondSection = proposedIndex.section;
    NSInteger secondRow = proposedIndex.row;
    if (firstSection == 0) {
        if (secondSection == 0) {
            NSArray *currentItem = [savedLocations objectAtIndex:firstRow];
            [savedLocations removeObjectAtIndex:firstRow];
            [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [savedLocations objectAtIndex:firstRow];
            [savedLocations removeObjectAtIndex:firstRow];
            [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    } else if (firstSection == 1) {
        if (secondSection == 0) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    }
}
-(void)changeSavedName:(NSIndexPath *)index :(NSString *)newName {
    
}
//Static method for adding entries
+(void)addEntryToFile:(NSArray *)item {
    NSArray *saved = [[NSArray alloc]init];
    NSMutableArray *previous = [[NSMutableArray alloc]init];
    if ([MSUtilities fileExists:@"SearchHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        saved = [file objectForKey:@"SavedLocations"];
        previous = [file objectForKey:@"PreviousLocations"];
    }
    [previous addObject:item];
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    [saver setObject:saved forKey:@"SavedLocations"];
    [saver setObject:previous forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:saver :@"SearchHistory"];
}

//Static method to create a blank file on first run
+(void)createBlankFile {
    
}

@end
