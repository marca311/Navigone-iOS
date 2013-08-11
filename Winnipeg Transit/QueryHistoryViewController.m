//
//  PlaceViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "QueryHistoryViewController.h"
#import "TextBoxCell.h"
#import "MSUtilities.h"
#import "AnimationInstructionSheet.h"

@implementation QueryHistoryViewController

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
    fileExists = [MSUtilities fileExists:@"QueryHistory.plist"];
    if (fileExists) {
        //Load Dictionary
        NSDictionary *theFile = [MSUtilities loadDictionaryWithName:@"QueryHistory"];
        //Convert NSData in dictionary into the NSArray filled with MSLocations
        NSData *savedData = [theFile objectForKey:@"SavedQueries"];
        savedQueries = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        //Ditto
        NSData *previousData = [theFile objectForKey:@"PreviousQueries"];
        previousQueries = [NSKeyedUnarchiver unarchiveObjectWithData:previousData];
        previousQueries = [QueryHistoryViewController checkNumberOfEntries:previousQueries];
        [self saveFile];
    }
    //theTableView.allowsSelectionDuringEditing = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Saved Queries";
    } else {
        return @"Query History";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if ([savedQueries count] == 0 || ![MSUtilities fileExists:@"QueryHistory.plist"]) return @"No saved queries";
    } else {
        if ([previousQueries count] == 0 || ![MSUtilities fileExists:@"QueryHistory.plist"]) return @"No history";
    }
    return NULL;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveEntry:sourceIndexPath :destinationIndexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fileExists) {
        if (section == 0) {
            return [savedQueries count];
        } else if (section == 1) {
            return [previousQueries count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueIdentifier = @"QueryCellIdentifier";
    TextBoxCell *cell = nil;
    cell = (TextBoxCell *) [tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"TextBoxCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (TextBoxCell *)currentObject;
                break;
            }
        }
    }

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        MSQuery *currentQuery = [savedQueries objectAtIndex:row];
        [cell.text setText:[currentQuery getHumanReadable]];
    } else if (section == 1) {
        MSQuery *currentQuery = [previousQueries objectAtIndex:row];
        [cell.text setText:[currentQuery getHumanReadable]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeQuery:indexPath];
        
        if ([tableView numberOfRowsInSection:indexPath.section] == 0) {
            [tableView reloadData];
            [tableView setEditing:false animated:true];
            [editButton setTitle:@"Edit"];
            [editButton setStyle:UIBarButtonItemStyleBordered];
        } else [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == TRUE) {
        //Put code in here to call up view to change name
    } else {
        //Load the parent view controller with compatability
        navigoViewController *theParentViewController;
        theParentViewController = ((navigoViewController *)self.presentingViewController);
        //Get info from correct array
        MSQuery *currentQuery;
        if (indexPath.section == 0) {
            currentQuery = [savedQueries objectAtIndex:indexPath.row];
        } else if (indexPath.section == 1) {
            currentQuery = [previousQueries objectAtIndex:indexPath.row];
        }
        //int stage = [theParentViewController.submitButton checkCurrentLocation];
        [currentQuery setDate:[NSDate date]];
        [theParentViewController setQuery:currentQuery];
        /*
        [theParentViewController.query setOrigin:currentQuery];
        [theParentViewController.originLabel setTitle:[currentQuery getHumanReadable] forState:UIControlStateNormal];
        [theParentViewController.query setDestination:currentQuery];
        [theParentViewController.destinationLabel setTitle:[currentQuery getHumanReadable] forState:UIControlStateNormal];
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [theParentViewController updateFields];
            [AnimationInstructionSheet toStageThree:theParentViewController];
        });
        [self dismissModalViewControllerAnimated:YES];
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
        [self saveFile];
    }
}

#pragma mark - File handling methods
-(void)saveFile {
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc]init];
    NSData *saved = [NSKeyedArchiver archivedDataWithRootObject:savedQueries];
    [theDictionary setObject:saved forKey:@"SavedQueries"];
    NSData *previous = [NSKeyedArchiver archivedDataWithRootObject:previousQueries];
    [theDictionary setObject:previous forKey:@"PreviousQueries"];
    [MSUtilities saveDictionaryToFile:theDictionary FileName:@"QueryHistory"];
}
-(void)removeQuery:(NSIndexPath *)index {
    NSInteger section = index.section;
    NSInteger row = index.row;
    switch (section) {
        case 0:
            [savedQueries removeObjectAtIndex:row];
            break;
        case 1:
            [previousQueries removeObjectAtIndex:row];
            break;
    }
    [self saveFile];
}

+(void)clearLocations {
    NSArray *savedLocationsList = [[NSArray alloc]init];
    NSArray *previousLocationsList = [[NSArray alloc]init];
    if ([MSUtilities fileExists:@"QueryHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"QueryHistory"];
        savedLocationsList = [file objectForKey:@"SavedQueries"];
    }
#warning This still uses the old system
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    [saver setObject:savedLocationsList forKey:@"SavedQueries"];
    [saver setObject:previousLocationsList forKey:@"PreviousQueries"];
    [MSUtilities saveDictionaryToFile:saver FileName:@"QueryHistory"];
}
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex {
    NSInteger firstSection = currentIndex.section;
    NSInteger firstRow = currentIndex.row;
    NSInteger secondSection = proposedIndex.section;
    NSInteger secondRow = proposedIndex.row;
    if (firstSection == 0) {
        if (secondSection == 0) {
            NSArray *currentItem = [savedQueries objectAtIndex:firstRow];
            [savedQueries removeObjectAtIndex:firstRow];
            if ([savedQueries count] == 0) {
                savedQueries = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedQueries insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [savedQueries objectAtIndex:firstRow];
            [savedQueries removeObjectAtIndex:firstRow];
            if ([previousQueries count] == 0) {
                previousQueries = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousQueries insertObject:currentItem atIndex:secondRow];
        }
    } else if (firstSection == 1) {
        if (secondSection == 0) {
            NSArray *currentItem = [previousQueries objectAtIndex:firstRow];
            [previousQueries removeObjectAtIndex:firstRow];
            if ([savedQueries count] == 0) {
                savedQueries = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedQueries insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [previousQueries objectAtIndex:firstRow];
            [previousQueries removeObjectAtIndex:firstRow];
            if ([previousQueries count] == 0) {
                previousQueries = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousQueries insertObject:currentItem atIndex:secondRow];
        }
    }
    [theTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    [self saveFile];
}
-(void)changeSavedName:(NSIndexPath *)index :(NSString *)newName {
    
}

#pragma mark - Static methods
//Static method for adding entries
+(void)addEntryToFile:(MSQuery *)item {
    NSArray *savedQueriesList = [[NSArray alloc]init];
    NSMutableArray *previousQueriesList = [[NSMutableArray alloc]init];
    if ([MSUtilities fileExists:@"QueryHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"QueryHistory"];
        //Convert NSData in dictionary into the NSArray filled with MSQueries
        NSData *savedData = [file objectForKey:@"SavedQueries"];
        savedQueriesList = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        //Ditto
        NSData *previousData = [file objectForKey:@"PreviousQueries"];
        previousQueriesList = [NSKeyedUnarchiver unarchiveObjectWithData:previousData];    }
    
    //Checks for duplicate entries
    BOOL placed = NO;
    for (int i = 0; i < [savedQueriesList count]; i++) {
        MSQuery *query = [savedQueriesList objectAtIndex:i];;
        //Check if query is currently saved queries list
        if ([item isEqualToQuery:query]) {
            //If it is, remove all occurances from previous queries (if any)
            [self removeInstancesOfQuery:item fromArray:previousQueriesList];
            //If previous queries list is empty, make it and add the item as the first entry
            if ([previousQueriesList count] == 0) {
                previousQueriesList = [[NSMutableArray alloc]initWithObjects:item, nil];
            } else {
                //If previous queries list exists, just put the entry at the top of the previous queries list
                [previousQueriesList insertObject:item atIndex:0];
            }
            placed = YES;
        }
    }
    for (int i = 0; i < [previousQueriesList count]; i++) {
        MSQuery *query = [previousQueriesList objectAtIndex:i];
        if ([item isEqualToQuery:query]) {
            [self removeInstancesOfQuery:query fromArray:previousQueriesList];
            [previousQueriesList insertObject:item atIndex:0];
            placed = YES;
        }
    }
    
    //If the query was not in query history at all (placed == NO), then add it to the list
    if (!placed) {
        if ([previousQueriesList count] == 0) {
            //Make previous queries list if it does not exist
            previousQueriesList = [[NSMutableArray alloc]initWithObjects:item, nil];
        } else {
            //Just add it if the list does exist
            [previousQueriesList insertObject:item atIndex:0];
        }
    }
    
    //Makes sure there are 20 or fewer entries in the previous locations list
    previousQueriesList = [QueryHistoryViewController checkNumberOfEntries:previousQueriesList];
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    //Converts array of MSQueries to data file
    NSData *saved = [NSKeyedArchiver archivedDataWithRootObject:savedQueriesList];
    [saver setObject:saved forKey:@"SavedQueries"];
    //Ditto
    NSData *previous = [NSKeyedArchiver archivedDataWithRootObject:previousQueriesList];
    [saver setObject:previous forKey:@"PreviousQueries"];
    [MSUtilities saveDictionaryToFile:saver FileName:@"QueryHistory"];
}
//Checks to see if there are over 20 entries in search history, if there are, it removes extras.
+(NSMutableArray *)checkNumberOfEntries:(NSMutableArray *)theArray {
    if ([theArray count] > 20) {
        for (int i = ([theArray count]-1); i > 19; i--) {
            [theArray removeObjectAtIndex:i];
        }
    }
    return theArray;
}
+(NSMutableArray *)removeInstancesOfQuery:(MSQuery *)query fromArray:(NSMutableArray *)array {
    for (int i = 0; i < [array count]; i++) {
        MSQuery *currentQuery = [array objectAtIndex:i];
        if ([query isEqualToQuery:currentQuery]) {
            [array removeObjectAtIndex:i];
            //This is to make sure that the script goes and checks the same index again for another duplicate
            i-=1;
        }
    }
    return array;
}

@end
