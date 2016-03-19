//
//  PlaceViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import "MSQuery.h"

@interface QueryHistoryViewController : UniversalViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *theTableView;
    IBOutlet UIBarButtonItem *editButton;
    NSMutableArray *savedQueries;
    NSMutableArray *previousQueries;
    BOOL fileExists;
}

-(IBAction)editTable;

#pragma mark - File Handling methods

-(void)saveFile;
-(void)removeQuery:(NSIndexPath *)index;
+(void)clearQueries;
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex;
-(void)changeSavedName:(NSString *)index :(NSString *)newName;
//Static method for adding entries
+(void)addEntryToFile:(MSQuery *)item;
+(NSMutableArray *)checkNumberOfEntries:(NSArray *)theArray;

@end
