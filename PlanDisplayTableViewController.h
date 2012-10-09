//
//  PlanDisplayTableViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-09-27.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"

@interface PlanDisplayTableViewController : UITableViewController

@property (nonatomic, retain) NSArray *currentArray;

-(PlanDisplayTableViewController *)initWithCorrectFrame;

-(void)showTable:(UIView *)theView;

-(void)setPlanDataArray:(NSArray *)array;

@end
