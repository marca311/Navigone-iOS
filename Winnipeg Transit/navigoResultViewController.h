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
#import "PlanSelectorTableVew.h"

@interface navigoResultViewController : UniversalViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UITableView *resultsTable;
    NSArray *resultsArray;
    
    UITextField *planField;
}

@property (nonatomic, retain) NSArray *planArray;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) IBOutlet UIButton *planButton;
@property (nonatomic, retain) NSArray *resultsArray;
@property (nonatomic, retain) IBOutlet UIButton *test;
@property (nonatomic, retain) PlanSelectorTableVew *testTable;

//Temporary text field till the table works
@property (nonatomic, retain) IBOutlet UITextField *planField;
@property (nonatomic, retain) IBOutlet UILabel *numPlans;

-(IBAction)reloadTable;

-(IBAction)testButton;

-(IBAction)closePlans;

@end
