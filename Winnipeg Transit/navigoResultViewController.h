//
//  navigoResultViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-30.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import "MSUtilities.h"
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"
#import "VariationSelectorTableVew.h"
#import "VariationDisplayTableViewController.h"
#import "MSRoute.h"

extern NSDictionary *resultDictionary;

@interface navigoResultViewController : UniversalViewController <UITableViewDelegate, UITextFieldDelegate> {
    VariationSelectorTableVew *planSelectorTable;
    NSUInteger currentVariation;
    MSRoute *routeData;
    MSVariation *variationData;
    VariationDisplayTableViewController *variationTable;
}

@property (nonatomic, retain) NSString *currentFile;
@property (nonatomic, retain) NSArray *planArray;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) IBOutlet UIButton *planButton;
@property (nonatomic, retain) NSArray *planList;
@property (nonatomic, retain) NSArray *planTitleArray;
//Plan selector button text boxes
@property (nonatomic, retain) IBOutlet UILabel *startTime;
@property (nonatomic, retain) IBOutlet UILabel *endTime;
@property (nonatomic, retain) IBOutlet UILabel *buses;

-(id)initWithMSRoute:(MSRoute *)route;

-(void)setRoute:(MSRoute *)theRoute;

-(IBAction)reloadTable;

-(IBAction)planButtonPress;

-(IBAction)closePlans;

-(void)changePlanSelectorArray:(int)arrayNumber;

@end
