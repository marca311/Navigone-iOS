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

@interface PlanDisplayTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *currentArray;
@property (nonatomic, retain) UIImage *locationImage;
@property (nonatomic, retain) UIImage *stopImage;
@property (nonatomic, retain) UIImage *monumentImage;
@property (nonatomic, retain) UIImage *rideImage;
@property (nonatomic, retain) UIImage *walkImage;
@property (nonatomic, retain) UIImage *transferImage;

-(id)initWithCorrectFrame:(NSArray *)theArray;

-(void)showTable:(UIView *)theView;

-(void)changeTablePlan:(NSArray *)theArray;

-(UIImage *)useCorrectImage:(NSArray *)theArray;

@end
