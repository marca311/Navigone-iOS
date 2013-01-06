//
//  PlaceViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface PlaceViewController : UniversalViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *theTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;

-(IBAction)editTable;

#pragma mark - File Handling methods

+(void)addLocation:(NSString *)locationName :(NSString *)locationKey;
+(void)removeLocation:(NSString *)index;
+(void)addToSaved:(NSString *)locationName :(NSString *)locationKey;
+(void)removeFromSaved:(NSString *)index;
+(void)changeSavedName:(NSString *)index :(NSString *)newName;

@end
