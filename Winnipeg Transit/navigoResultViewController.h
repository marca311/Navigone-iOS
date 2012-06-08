//
//  navigoResultViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-30.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface navigoResultViewController : UniversalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) IBOutlet UIButton *planButton;

@end
