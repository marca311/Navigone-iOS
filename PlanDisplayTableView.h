//
//  PlanDisplayTableView.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-10-04.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"

@interface PlanDisplayTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *currentArray;

@end
