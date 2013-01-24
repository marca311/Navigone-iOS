//
//  PlaceViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlaceViewController.h"
#import "MSUtilities.h"
#import "navigoInterpreter.h"
#import "AnimationInstructionSheet.h"

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
        previousLocations = [PlaceViewController checkNumberOfEntries:previousLocations];
        [self saveFile];
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if ([savedLocations count] == 0) return @"No saved locations";
    } else {
        if ([previousLocations count] == 0) return @"No history";
    }
    return NULL;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveEntry:sourceIndexPath :destinationIndexPath];
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
        NSArray *cellData = [savedLocations objectAtIndex:row];
        cell.textLabel.text = [cellData objectAtIndex:0];
    } else if (section == 1) {
        NSArray *cellData = [previousLocations objectAtIndex:row];
        cell.textLabel.text = [cellData objectAtIndex:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeLocation:indexPath];
        
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            [tableView reloadData];
            [tableView setEditing:false animated:true];
            [editButton setTitle:@"Edit"];
            [editButton setStyle:UIBarButtonItemStyleBordered];
        } else [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Load the parent view controller with compatability
    navigoViewController *theParentViewController;
    if ([MSUtilities firmwareIsHigherThanFour]) {
        theParentViewController = ((navigoViewController *)self.presentingViewController);
    } else {
        theParentViewController = ((navigoViewController *)self.parentViewController);
    }
    //Get info from correct array
    NSArray *chosenArray;
    if (indexPath.section == 0) {
        chosenArray = [savedLocations objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        chosenArray = [previousLocations objectAtIndex:indexPath.row];
    }
    int stage = [theParentViewController.submitButton checkCurrentLocation];
    if (stage == 1) {
        [queriedDictionary setObject:chosenArray forKey:@"origin"];
        [theParentViewController.originLabel setTitle:[chosenArray objectAtIndex:0] forState:UIControlStateNormal];
    } else if (stage == 2) {
        [queriedDictionary setObject:chosenArray forKey:@"destination"];
        [theParentViewController.destinationLabel setTitle:[chosenArray objectAtIndex:0] forState:UIControlStateNormal];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        //[theParentViewController fieldChecker];
        [AnimationInstructionSheet toNextStage:theParentViewController];
    });
    [self dismissModalViewControllerAnimated:YES];
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
        [self saveFile];
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
            if ([savedLocations count] == 0) {
                savedLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [savedLocations objectAtIndex:firstRow];
            [savedLocations removeObjectAtIndex:firstRow];
            if ([previousLocations count] == 0) {
                previousLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    } else if (firstSection == 1) {
        if (secondSection == 0) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            if ([savedLocations count] == 0) {
                savedLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            if ([previousLocations count] == 0) {
                previousLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    }
    [theTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    [self saveFile];
}
-(void)changeSavedName:(NSIndexPath *)index :(NSString *)newName {
    
}
//Static method for adding entries
+(void)addEntryToFile:(NSArray *)item {
    NSArray *savedLocationsList = [[NSArray alloc]init];
    NSMutableArray *previousLocationsList = [[NSMutableArray alloc]init];
    if ([MSUtilities fileExists:@"SearchHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        savedLocationsList = [file objectForKey:@"SavedLocations"];
        previousLocationsList = [file objectForKey:@"PreviousLocations"];
    }
    
    //Checks for duplicate entries
    BOOL placed = NO;
    NSString *key = [item objectAtIndex:1];
    for (int i=0; i<[savedLocationsList count]; i++) {
        NSString *checkKey = [[savedLocationsList objectAtIndex:i]objectAtIndex:1];
        if ([key isEqualToString:checkKey]) {
            NSArray *currentItem = [savedLocationsList objectAtIndex:i];
            [previousLocationsList removeObject:item];
            [previousLocationsList removeObject:currentItem];
            [previousLocationsList insertObject:currentItem atIndex:0];
            placed = YES;
        }
    }
    for (int i=0; i<[previousLocationsList count]; i++) {
        NSString *checkKey = [[previousLocationsList objectAtIndex:i]objectAtIndex:1];
        if ([key isEqualToString:checkKey]) {
            [previousLocationsList removeObject:item];
            [previousLocationsList insertObject:item atIndex:0];
            placed = YES;
        }
    }
    
    if (!placed) {
        if ([previousLocationsList count] == 0) {
            previousLocationsList = [[NSMutableArray alloc]initWithObjects:item, nil];
        } else {
            [previousLocationsList insertObject:item atIndex:0];

        }
    }
    
    previousLocationsList = [PlaceViewController checkNumberOfEntries:previousLocationsList];
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    [saver setObject:savedLocationsList forKey:@"SavedLocations"];
    [saver setObject:previousLocationsList forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:saver :@"SearchHistory"];
}
+(NSMutableArray *)checkNumberOfEntries:(NSMutableArray *)theArray {
    if ([theArray count] > 20) {
        for (int i = ([theArray count]-1); i > 19; i--) {
            [theArray removeObjectAtIndex:i];
        }
    }
    return theArray;
}

@end
